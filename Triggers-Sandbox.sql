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

-- test:
-- UPDATE 0 rows:
UPDATE Student
SET BalanceOwing = 999
WHERE StudentID = 4359853498543

-- UPDATE 1 row:
UPDATE Student
SET BalanceOwing = 100
WHERE StudentID = 198933540

-- UPDATE many rows: