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

-- test on Wednesday