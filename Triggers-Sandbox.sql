USE IQSchool
GO

-- practice Q 1:
CREATE TRIGGER TR_PracticeQ1
	ON Student -- which table is this trigger associated with?
	FOR UPDATE -- this trigger is only executed for UPDATEs on the Student table
AS
	-- print a message that the trigger started
	PRINT 'Executing trigger....'
	-- view all the tables
	SELECT * FROM inserted
	SELECT * FROM deleted
	SELECT * FROM Student -- base table
	
	-- ROLLBACK
	PRINT 'Rolling back...'
	ROLLBACK TRANSACTION
	-- view all the tables again
	SELECT * FROM inserted
	SELECT * FROM deleted
	SELECT * FROM Student -- base table

	-- our trigger is done
	PRINT 'The trigger is complete'

RETURN -- end of the trigger
GO

-- test
-- UPDATE zero rows
UPDATE Student
SET BalanceOwing = 1000
WHERE StudentID = 999

-- UPDATE 1 row
UPDATE Student
SET BalanceOwing = 1000
WHERE StudentID = 198933540

-- UPDATE many rows
UPDATE Student
SET BalanceOwing = 1000
WHERE Province = 'BC'


USE MovieCharacter
-- practice Q #2
-- Create a trigger to enforce a rule that CharacterWages must be >= 0.
GO

CREATE TRIGGER TR_PracticeQ2
	ON MovieCharacter
	FOR INSERT, UPDATE -- triggered by BOTH insert & update statements on the MovieCharacter table
AS

IF @@ROWCOUNT > 0 AND UPDATE(CharacterWage)
	-- @@rowcount tells us how many rows were affected by the LAST DML statement.
	-- if no rows were affected, our trigger doesn't have anything to do.
	-- UPDATE() tells us whether a specific column was updated by the last DML statement. It returns TRUE if it was, FALSE otherwise.
	BEGIN

	-- look at the changed record(s) & see if any violate the rule.
	IF EXISTS (SELECT * FROM inserted WHERE Characterwage < 0)
	-- if so: ROLLBACK & RAISERROR
		BEGIN
		RAISERROR('Cannot have negative wage', 16, 1)
		ROLLBACK TRANSACTION
		END
	END

RETURN
GO

-- INSERT zero rows: do nothing
-- INSERT 1 row: check rule
INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, Characterwage, AgentID)
VALUES ('Egon Spengler', 'Ghostbusters', 3, 100, 1)
-- INSERT many rows: check rule
-- UPDATE of zero rows: do nothing
UPDATE MovieCharacter SET Characterwage = -10 WHERE CharacterID = 99999
-- UPDATE of 1 row: check rule
UPDATE MovieCharacter SET Characterwage = 50 WHERE CharacterID = 6
UPDATE MovieCharacter SET Characterwage = -50 WHERE CharacterID = 6
-- UPDATE of many rows: check rule
UPDATE MovieCharacter SET Characterwage = 50 WHERE CharacterID > 4
UPDATE MovieCharacter SET Characterwage = -50 WHERE CharacterID > 4

-- how to check which fields are IDENTITY:
exec sp_help MovieCharacter
GO

-- practice Q #3:
-- Create a trigger that enforces a rule that an AgentFee cannot be increased by more than 100% in one update.

CREATE TRIGGER TR_PracticeQ3
	ON Agent
	FOR UPDATE
AS

IF @@ROWCOUNT > 0 AND UPDATE(AgentFee)
	BEGIN

	-- look at the old value for AgentFee: deleted.AgentFee
	-- compare to the NEW value for Agent Fee: inserted.AgentFee
	-- if new value > 2 * old value: RAISERROR & ROLLBACK
	IF EXISTS (
		SELECT *
		FROM inserted
		INNER JOIN deleted ON inserted.AgentID = deleted.AgentID
		WHERE inserted.AgentFee > 2* deleted.AgentFee
	) -- we've broken the rule :(
		BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Too much of a change', 16, 1)
		END
	END
RETURN
GO

-- test:
-- UPDATE zero records
UPDATE Agent SET AgentFee = 100 WHERE AgentFee = 500 -- no agent exists
-- UPDATE 1 record successfully
UPDATE Agent SET AgentFee = 75 WHERE AgentID = 1
SELECT * FROM Agent
-- UPDATE 1 record unsuccessfully
UPDATE Agent SET AgentFee = 750 WHERE AgentID = 1
SELECT * FROM Agent
-- UPDATE many records
UPDATE Agent SET AgentFee = 100
SELECT * FROM Agent

GO
-- practice Q #4
-- Create a trigger that enforces a rule that a MovieCharacter cannot be deleted if their Agent's AgentFee is >= 50.

CREATE TRIGGER TR_PracticeQ4
	ON MovieCharacter
	FOR DELETE
AS

-- make sure at least 1 character is being deleted
IF @@ROWCOUNT > 0
	BEGIN
	-- check if any deleted records have an agent whose fee is >=50]
	IF EXISTS (
		SELECT * 
		FROM deleted
		INNER JOIN Agent ON deleted.AgentID = Agent.AgentID
		WHERE AgentFee >=50
	)
		BEGIN
		RAISERROR('cannot delete', 16, 1)
		ROLLBACK TRANSACTION
		END
	END
RETURN
GO

-- test
SELECT * FROM MovieCharacter
SELECT * FROM Agent

-- delete ZERO records
DELETE FROM MovieCharacter WHERE CharacterID = 99999
SELECT * FROM MovieCharacter
-- delete 1 record successfully
DELETE FROM MovieCharacter WHERE CharacterID = 1
SELECT * FROM MovieCharacter
-- delete many records (including 1 with a high-paid agent): should fail
DELETE FROM MovieCharacter WHERE AgentID = 2
SELECT * FROM MovieCharacter

GO

--- practice Q #5:
-- Create a trigger that enforces a rule that an Agent cannot represent more than 2 movie characters.
CREATE TRIGGER TR_PracticeQ5
ON MovieCharacter
FOR INSERT, UPDATE
AS

IF @@ROWCOUNT > 0 AND UPDATE(AgentID)
	BEGIN
	-- check to see if the rule was broken
	-- if so, ROLLBACK & RAISERROR
	IF EXISTS (
		SELECT *
		FROM MovieCharacter
		INNER JOIN inserted ON MovieCharacter.CharacterID = inserted.CharacterID
		GROUP BY MovieCharacter.AgentID
		HAVING COUNT(*) > 2
	)
		BEGIN
		RAISERROR('too many characters!', 16, 1)
		ROLLBACK TRANSACTION
		END

	END
RETURN -- end of my trigger

-- insert 0 records
-- insert 1 record successfully
-- insert many records at least one unsuccessfully
-- update 0
-- update 1
-- update many
GO

-- practice Q #6:
-- Create a trigger to Log when changes are made to the CourseCost in the Course table. The changes will be inserted in to the following Logging table:
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

-- then create the trigger that INSERTs into the logging table:
CREATE TRIGGER TR_PracticeQ6
ON Course
FOR UPDATE
AS

IF @@ROWCOUNT > 0 AND UPDATE(CourseCost)
	BEGIN

	INSERT INTO CourseChanges (ChangeDate, OldCourseCost, NewCourseCost, CourseID)
	SELECT GetDate(), deleted.CourseCost, inserted.CourseCost, inserted.CourseId
	FROM deleted
	INNER JOIN inserted ON deleted.CourseId = inserted.CourseID
	-- WHERE deleted.CourseCost <> inserted.CourseCost

	END


RETURN
GO


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