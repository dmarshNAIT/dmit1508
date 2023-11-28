USE IQSchool
GO

CREATE TRIGGER TR_Student_Update
	ON Student -- this is the base table
	FOR UPDATE
AS

	-- print message
	PRINT 'Trigger is starting...'
	-- show the contents of all 3 table
	SELECT * FROM inserted
	SELECT * FROM deleted
	SELECT * FROM Student
	-- roll back
	ROLLBACK TRANSACTION
	-- print message
	PRINT 'Txn has been rolled back.'
	-- show the contents of all 3 table again
	SELECT * FROM inserted
	SELECT * FROM deleted
	SELECT * FROM Student
	-- print message
	PRINT 'Trigger is complete!'

RETURN -- marks the end of the trigger

-- testing time!
-- in order to test this, I need to UPDATE the Student table
UPDATE Student
SET BalanceOwing = 5
WHERE StudentID = 199899200 -- this should try to update just one student

UPDATE Student
SET BalanceOwing = 5
WHERE StudentID = 1 -- NO students were updated

UPDATE Student
SET BalanceOwing = 5
WHERE City = 'Edmonton' -- this should try to update MANY students

SELECT * FROM Student

GO

USE Movie
GO
-- Practice #2

CREATE TRIGGER TR_PracticeQ2
	ON MovieCharacter
	FOR INSERT, UPDATE 
AS
-- first, we make sure there is at least one character whose wage is being updated:
IF @@ROWCOUNT > 0 AND UPDATE(CharacterWage)
	BEGIN
	-- check if the newly inserted or updated records violate the rule
	-- if so, we roll back
	IF EXISTS (SELECT * FROM inserted WHERE Characterwage < 0)
		BEGIN
		RAISERROR('Cannot have a negative wage.', 16, 1)
		ROLLBACK TRANSACTION
		END
	END
RETURN

-- test our trigger
-- does it work as expected for 0 rows?
UPDATE MovieCharacter SET CharacterWage = -100 WHERE CharacterID = 9999
-- does it work as expected for 1 row?
UPDATE MovieCharacter SET CharacterWage = -100 WHERE CharacterID = 3
UPDATE MovieCharacter SET CharacterWage = 100 WHERE CharacterID = 3
-- does it work as expected for many rows?
UPDATE MovieCharacter SET Characterwage = 500 WHERE CharacterMovie = 'Star Wars'
UPDATE MovieCharacter SET Characterwage = -5 WHERE CharacterMovie = 'Star Wars'

SELECT * FROM MovieCharacter