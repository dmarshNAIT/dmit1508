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