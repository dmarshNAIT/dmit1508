-- practice Q #1:
USE IQSchool
GO

-- create a trigger to demonstrate how triggers work
CREATE TRIGGER TR_PracticeQ_1
	ON Student -- which table is this trigger associated with?
	FOR UPDATE -- this trigger only executes if there has been an UPDATE on the Student table
AS

-- print a message
PRINT 'Trigger is starting...'

-- show the contents of the 3 tables
SELECT * FROM inserted
SELECT * FROM deleted
SELECT * FROM Student -- base table

-- ROLLBACK
PRINT 'Rolling back...'
ROLLBACK TRANSACTION

-- show the contents again
SELECT * FROM inserted
SELECT * FROM deleted
SELECT * FROM Student -- base table

-- print another message
PRINT 'Aaaand we are done.'

RETURN -- end of the trigger
GO

-- test:
-- UPDATE 0 rows:
UPDATE Student
SET BalanceOwing = 999
WHERE StudentID = 456456456

-- UPDATE 1 row:
UPDATE Student
SET BalanceOwing = 100
WHERE StudentID = 198933540

-- UPDATE many rows:
UPDATE Student
SET BalanceOwing = 500
WHERE City = 'Edmonton'

GO

--- practice Q #2:
-- Create a trigger to enforce a rule that CharacterWages must be >= 0.

USE MovieCharacter
GO

CREATE TRIGGER TR_PracticeQ_1
	ON MovieCharacter
	FOR INSERT, UPDATE -- triggered by BOTH insert & update operations on the MovieCharacter table
AS

IF @@ROWCOUNT > 0 AND UPDATE(CharacterWage)
	-- @@rowcount tells us how many rows were affected by the last DML statement.
	-- if no rows were affected, our trigger has nothing to do. 
	-- UPDATE() tells us if a specific column was updated by the last DML statement. It returns TRUE if it was, FALSE otherwise.
	BEGIN

	IF EXISTS (SELECT * FROM inserted WHERE CharacterWage < 0) -- check if the rule was violated
		BEGIN -- if so, ROLLBACK
		RAISERROR('Cannot have negative wage, you monster', 16, 1)
		ROLLBACK TRANSACTION 
		END
	END

RETURN
GO

-- UPDATE: zero rows
UPDATE MovieCharacter SET Characterwage = 1000 WHERE CharacterID = 999

-- UPDATE: 1 row: error
UPDATE MovieCharacter SET Characterwage = -10 WHERE CharacterID = 1

-- INSERT: many rows:  success
INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating,Characterwage, AgentID)
VALUES ('C3PO', 'Star Wars', 4, 500, 3)
	, ('Darth Vader', 'Star Wars', 1, 5000, 2)
GO


--- practice Q #3:
-- create a trigger to enforce a rule that an AgentFee cannot be updated by MORE than 100%
CREATE TRIGGER TR_PracticeQ_3
	ON Agent
	FOR UPDATE
AS

-- check to see if the trigger needs to run
IF @@ROWCOUNT > 0 AND UPDATE(AgentFee)
	BEGIN

	-- look at the old value for Agent Fee: deleted.AgentFee
	-- compare to the new value of Agent Fee: inserted.AgentFee
	-- if new value > (old value + old value): RAISERROR & ROLLBACK
	-- or: new value > (2 * old value)
	IF EXISTS (
		SELECT *
		FROM inserted
		INNER JOIN deleted ON inserted.AgentID = deleted.AgentID
		WHERE inserted.AgentFee > (2 * deleted.AgentFee)
	) -- the rule has been broken :(
		BEGIN
		RAISERROR('That is too much, man', 16, 1)
		ROLLBACK TRANSACTION
		END

	END
RETURN
GO

-- test
-- UPDATE 0 records: nothing should happen
SELECT * FROM Agent
UPDATE Agent SET AgentFee = 55 WHERE AgentID = 999

-- UPDATE 1 record successfully
UPDATE Agent SET AgentFee = 55 WHERE AgentID = 1

-- UPDATE many records: unsuccessfully
UPDATE Agent SET AgentFee = 200 WHERE AgentName LIKE '%a%'
GO

-- Practice Q #4
-- movie characters cannot be deleted if their agent's fee is >= 50

CREATE TRIGGER TR_PracticeQ4
ON MovieCharacter
FOR DELETE
AS

-- make sure at least 1 character was deleted
IF @@ROWCOUNT > 0
	BEGIN
		-- check if any deleted records have an agent whose fee is >=50
		IF EXISTS (
			SELECT *
			FROM deleted
			INNER JOIN Agent ON deleted.AgentID = Agent.AgentID
			WHERE AgentFee >= 50
		)
		-- if so: 
			BEGIN
			ROLLBACK TRANSACTION
			RAISERROR('Cannot delete: agent makes too much money', 16, 1)
			END
	END
RETURN
GO

-- practice Q #5:
-- Create a trigger that enforces a rule that an Agent cannot represent more than 2 movie characters.

CREATE TRIGGER TR_PracticeQ5
ON MovieCharacter
FOR INSERT, UPDATE
AS

-- check to see if the trigger needs to run
IF @@ROWCOUNT > 0 AND UPDATE(AgentID)
	BEGIN
	-- check to see if the rule was broken
	IF EXISTS (
		SELECT *
		FROM MovieCharacter
		INNER JOIN inserted ON inserted.AgentID = MovieCharacter.AgentID -- because we want to connect the new characters to the existing characters with the same agent
		GROUP BY MovieCharacter.AgentID
		HAVING COUNT(*) > 2 -- counting the # of rows = # of characters
	)
		-- if so, RAISERROR & ROLLBACK
		BEGIN
			RAISERROR('Sorry, that agent is busy', 16, 1)
			ROLLBACK TRANSACTION
		END
	END
RETURN
GO

-- Practice Q #6:
-- create a trigger to log when changes are made to the CourseCost in the Course table

USE IQSchool
GO

-- first, create the logging table:
CREATE TABLE CourseChanges(
	LogID INT IDENTITY(1,1) NOT NULL CONSTRAINT pk_CourseChanges PRIMARY KEY CLUSTERED
	,	ChangeDate datetime NOT NULL
	,	OldCourseCost money NOT NULL
	,	NewCourseCost money NOT NULL
	,	CourseID CHAR(7) NOT NULL
)
GO

-- then, create a trigger that INSERTs into the logging table:
CREATE TRIGGER TR_PracticeQ6
ON Course
FOR UPDATE
AS

-- check to see if the trigger needs to run
IF @@ROWCOUNT > 0 AND UPDATE(CourseCost)
	BEGIN

	-- insert into loggging table
	INSERT INTO CourseChanges (ChangeDate, OldCourseCost, NewCourseCost, CourseID)
	SELECT GetDate(), deleted.CourseCost, inserted.CourseCost, inserted.CourseID
	FROM inserted
	INNER JOIN deleted ON inserted.CourseId = deleted.CourseId
	WHERE inserted.CourseCost != deleted.CourseCost -- we only want to log CHANGES to the cost

	END
RETURN
GO

-- test:
SELECT * FROM Course
UPDATE Course SET CourseCost = 500 WHERE MaxStudents = 4

SELECT * FROM CourseChanges

-- Q7: Create a trigger to enforce referential integrity between the Agent and MovieCharacter table.

-- This is a bit of a silly example because FKs already do this for us, but it would make sense if we had separate databases that didn't have FKs defining that relationship.
-- to "hack" this, we will disable the FK between these tables, and recreate the functionality in a trigger instead.

USE MovieCharacter
GO

-- first, disable the FK:
ALTER TABLE MovieCharacter NOCHECK CONSTRAINT fk_MovieCharacterToAgent
GO

-- then, I need 2 triggers. One on the parent, one on the child.

-- on the child table, I need to make sure that every child has a parent record:
CREATE TRIGGER TR_MovieCharacter_FK_Child
ON MovieCharacter
FOR UPDATE, INSERT
AS

IF @@ROWCOUNT > 0 AND UPDATE(AgentID)
	BEGIN
	IF EXISTS (
			SELECT * FROM inserted
			WHERE AgentID NOT IN (Select AgentID FROM Agent)
	
	) -- if there are records with no valid parent
		BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('this child has no parent :(', 16, 1)
		END
	END
RETURN
GO

-- on the parent table, I need to make sure I'm not deleting a parent who has a child:
CREATE TRIGGER TR_MovieCharacter_FK_Parent
ON Agent
FOR DELETE
AS
IF @@ROWCOUNT > 0
	BEGIN
	IF EXISTS (
		SELECT * FROM deleted
		INNER JOIN MovieCharacter ON deleted.AgentID = MovieCharacter.AgentID
	) -- if this parent has 1+ child record
		BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('this parent has children: cannot dropkick', 16, 1)
		END
	END
RETURN
GO