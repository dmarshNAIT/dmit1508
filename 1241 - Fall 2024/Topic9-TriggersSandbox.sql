USE IQSchool
GO

-- this is NOT a realistic trigger, this is just an excuse to check out the temp tables

-- Practice Q #1
CREATE TRIGGER TR_PracticeQ1
	ON Student
	FOR UPDATE
AS
	PRINT 'The trigger is starting...'
	SELECT * FROM inserted
	SELECT * FROM deleted
	SELECT * FROM Student -- the "base" table

	PRINT 'Rolling back...'
	ROLLBACK TRANSACTION
	SELECT * FROM inserted
	SELECT * FROM deleted
	SELECT * FROM Student

	PRINT 'Trigger is done.'
RETURN
GO

-- testing time!
-- test with an UPDATE of 1 row
UPDATE Student 
SET BalanceOwing = 99000
WHERE StudentID = 200978500

SELECT * FROM Student
-- test with an UPDATE of many rows
UPDATE Student 
SET BalanceOwing = 99000
-- test with an UPDATE of 0 rows
UPDATE Student 
SET BalanceOwing = 99000
WHERE StudentID = 999999
GO

-- using our fancy new DB
USE MovieDB
GO

-- Practice Q #2
-- Character Wage must be >= 0
CREATE TRIGGER TR_PracticeQ2
	ON MovieCharacter
	FOR INSERT, UPDATE
AS

-- check to see if the trigger needs to run
IF @@ROWCOUNT > 0 AND UPDATE(CharacterWage)
	BEGIN
	-- check to see if the rule was broken
	-- i.e. are there any newly updated/inserted records with a wage < 0?
	IF EXISTS (SELECT * FROM inserted WHERE Characterwage < 0)
		BEGIN
		-- if so, undo the change
		ROLLBACK TRANSACTION
		RAISERROR('You must pay your characters', 16, 1)
		END
	END

RETURN

-- test with 0 rows -- UPDATE
UPDATE MovieCharacter SET Characterwage = 100 WHERE CharacterID = 9999
-- we expect nothing to happen, and 0 rows were affected 
-- TEST PASSES!

-- test with 1 row -- INSERT
INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, CharacterWage)
VALUES ('Donald Duck', 'NOT Looney Tunes', 3, .03)

INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, CharacterWage)
VALUES ('Donald Duck', 'NOT Looney Tunes', 3, -.03)

SELECT * FROM MovieCharacter

-- test with many rows -- once successful, once with a violation
