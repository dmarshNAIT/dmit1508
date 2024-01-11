USE [IQ-School]
GO

CREATE TRIGGER TR_Student_Update
ON Student
FOR UPDATE
AS

PRINT 'The trigger is starting!'

SELECT * FROM Inserted -- after
SELECT * FROM deleted -- before
SELECT * FROM Student

ROLLBACK TRANSACTION

SELECT * FROM Inserted
SELECT * FROM deleted
SELECT * FROM Student

PRINT 'Trigger is complete'

RETURN

-- TEST

-- updating zero rows: studentID 1
UPDATE Student
SET BalanceOwing = 123
WHERE StudentID = 1

-- updating 1 row: studentID 198933540
UPDATE Student
SET BalanceOwing = 123
WHERE StudentID = 198933540

-- updating 2+ rows: all students
UPDATE Student
SET BalanceOwing = 123

-- test bad data type
UPDATE Student
SET BalanceOwing = 'abc'

SELECT * FROM Student 
GO


-- create a trigger that enforces a rule that a CharactersWage must be >=0
USE Movies
GO


CREATE TRIGGER TR_MovieCharacter_Update_Insert
ON MovieCharacter
FOR UPDATE, INSERT
AS

IF UPDATE(CharacterWage) AND @@ROWCOUNT > 0  -- IF any rows were affected, AND we're changing CharacterWage
	BEGIN
	IF EXISTS (SELECT *  FROM Inserted WHERE Characterwage < 0 )
		BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Wage cannot be negative', 16, 1)
		END
	END
RETURN

-- test
UPDATE MovieCharacter
SET Characterwage = 2250
WHERE CharacterID = 9999

-- test
INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
VALUES ('grumpy cat', 'the office', '2', 2000, 1)

SELECT * FROM MovieCharacter
GO 


-- enforcing a rule that the AgentFee cannot be updated by more than 100%


CREATE TRIGGER TR_Agent_Update
ON Agent
FOR Update
AS

IF @@ROWCOUNT > 0 AND Update(AgentFee)
	BEGIN
	-- check old value from Deleted
	-- compare it to new value from Inserted
	IF EXISTS (
			SELECT * FROM inserted
			INNER JOIN deleted ON inserted.AgentID = deleted.AgentID
			WHERE inserted.AgentFee > 2* deleted.AgentFee
	)
		BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('TOO MUCH!', 16, 1)
		END
	END
RETURN

GO

--Create a trigger that enforces a rule that a MovieCharacter cannot be deleted if their Agent's AgentFee is >= 50.

CREATE TRIGGER TR_MovieCharacter_Delete
ON MovieCharacter
FOR DELETE
AS
IF @@ROWCOUNT > 0
	BEGIN
	IF EXISTS (SELECT * FROM deleted
				INNER JOIN Agent ON deleted.AgentID = Agent.AgentID
				WHERE AgentFee >= 50)
		BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('That agent makes too much. Cannot delete.', 16, 1)
		END
	END
RETURN

-- Create a trigger that enforces a rule that an Agent cannot represent more than 2 movie characters.
GO

CREATE TRIGGER TR_MovieCharacter_Insert_Update
ON MovieCharacter
FOR INSERT, UPDATE
AS
IF @@ROWCOUNT > 0 AND UPDATE(AgentID)
BEGIN
-- count of characters for that agentID
	IF EXISTS (
		SELECT *
		FROM MovieCharacter
		INNER JOIN inserted ON MovieCharacter.AgentID = inserted.AgentID
		GROUP BY MovieCharacter.AgentID
		HAVING COUNT(*) > 2
	)
		BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Cannot represent more than 2', 16, 1)
		END
END
RETURN

GO


--Create a trigger to Log when changes are made to the CourseCost in the Course table. The changes will be inserted in to the following Logging table:

USE [IQ-School]

-- we create the table outside the trigger, as it's only created once:
CREATE TABLE CourseChanges(
		LogID INT IDENTITY(1,1) NOT NULL  CONSTRAINT pk_CourseChanges PRIMARY KEY CLUSTERED
	,	ChangeDate datetime NOT NULL
	,	OldCourseCost money NOT NULL
	,	NewCourseCost money NOT NULL
	,	CourseID CHAR(7) NOT NULL
)

GO

CREATE TRIGGER TR_CourseUpdate
ON Course
FOR UPDATE
AS
IF @@ROWCOUNT > 0 AND UPDATE(CourseCost) -- if CourseCost changes
	BEGIN
		INSERT INTO CourseChanges (
				ChangeDate
			,	OldCourseCost
			,	NewCourseCost
			,	CourseID)
		SELECT	GETDATE()
			,	deleted.CourseCost -- the old CourseCost
			,	inserted.CourseCost -- the new CourseCost
			,	inserted.CourseID
		FROM inserted 
		INNER JOIN deleted on inserted.CourseID = deleted.CourseID
	END
RETURN

GO


-- Create a trigger to enforce referential integrity between the Agent and MovieCharacter table.

-- this is a little silly because FK already do this, but this type of trigger would make sense if we were working across databases that didn't already have FKs

-- we will simulate this by disabling the FK constraint.
USE Movies

ALTER TABLE MovieCharacter NOCHECK Constraint fk_MovieCharacterToAgent
GO

-- then, we think about when this relationship could be violated.

-- first, if I create a child record that doesn't have a parent:

CREATE TRIGGER TR_Parent_Check_Insert_Update
ON MovieCharacter
FOR UPDATE, INSERT
AS

IF @@ROWCOUNT > 0 AND UPDATE(AgentID)
	BEGIN
		IF EXISTS (SELECT * FROM inserted WHERE AgentID NOT IN (Select AgentID from Agent))
			BEGIN
			RAISERROR('Invalid AgentID', 16, 1)
			ROLLBACK TRANSACTION
			END
	END
RETURN
GO

-- test:
INSERT INTO MovieCharacter (CharacterName, CharacterMovie, Characterwage, AgentID)
VALUES ('bob', 'that movie', 50, 99999), ('joe', 'that other movie', 50, 500)

UPDATE MovieCharacter SET AgentID = 999

GO

-- second, we need to make sure we don't remove a parent record that has a child:
CREATE TRIGGER TR_Child_Check_Delete
ON Agent
FOR DELETE
AS

IF @@ROWCOUNT > 0 
	BEGIN
		IF EXISTS (SELECT * FROM deleted
					INNER JOIN MovieCharacter ON deleted.AgentID = MovieCharacter.AgentID )
			BEGIN
			RAISERROR('Cannot delete that agent: it has clients!', 16, 1)
			ROLLBACK TRANSACTION
			END
	END
RETURN
GO