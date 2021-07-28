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