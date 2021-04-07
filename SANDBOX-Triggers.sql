USE IQSchool
GO


-- exercise 1:

CREATE TRIGGER TR_Student_Update
	ON Student
	FOR UPDATE
AS

-- print a message: trigger started
PRINT 'Executing trigger now...'
-- view all the tables
SELECT * FROM inserted
SELECT * FROM deleted
SELECT * FROM Student

-- print a message: ROLLBACK
PRINT 'Rolling back...'
-- ROLLBACK
ROLLBACK TRANSACTION
-- view all the tables
SELECT * FROM inserted
SELECT * FROM deleted
SELECT * FROM Student

-- print a message: done
PRINT 'Trigger is complete'

RETURN -- end of trigger

GO

-- test:
-- updating zero rows:
UPDATE Student
SET BalanceOwing = 1000
WHERE StudentID = 999999

SELECT * FROM Student WHERE StudentID = 999999

-- updating 1 row:
UPDATE Student
SET BalanceOwing = 1000
WHERE StudentID = 198933540

SELECT * FROM Student WHERE StudentID = 198933540

-- updating many rows:
UPDATE Student
SET BalanceOwing = 1000