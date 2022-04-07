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


-- Practice Q #6:
-- createa a trigger to log when changes are made to the CourseCost in the Course table

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
	WHERE inserted.CourseCost != deleted.CourseCost

	END
RETURN
GO

-- test:
SELECT * FROM Course
UPDATE Course SET CourseCost = 500 WHERE MaxStudents = 4

SELECT * FROM CourseChanges