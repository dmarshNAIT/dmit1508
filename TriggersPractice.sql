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

CREATE TRIGGER TR_MovieCharacter_Update_Insert
ON MovieCharacter
FOR UPDATE, INSERT
AS

IF UPDATE(CharacterWage) AND @@ROWCOUNT > 0 
-- any rows were affected, and if we're changing CharacterWage
	BEGIN
	IF EXISTS (SELECT *  FROM Inserted WHERE Characterwage < 0 )
		BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Wage cannot be negative', 16, 1)
		END
	END
RETURN

-- update
UPDATE MovieCharacter
SET Characterwage = 2250
WHERE CharacterID = 9999

-- insert
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