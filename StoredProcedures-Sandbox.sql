USE IQSchool

-- variables

-- creating a variable:
DECLARE @FirstName VARCHAR(30)
-- assign a value using a literal:
SET @FirstName = 'Bob'

-- creating multiple variables:
DECLARE @MiddleName VARCHAR(30)
	, @LastName VARCHAR(30)
SELECT @MiddleName = 'J'
	, @LastName = 'Smith'

-- assigning a value from a query:
SELECT @LastName = LastName
	FROM Staff
	WHERE StaffID = 1
PRINT @LastName -- for debugging & testing purposes

-- if/else
DECLARE @Total INT
SET @Total = 75

IF @Total > 100
	BEGIN
	PRINT 'Value is greater than 100'
	END
ELSE
	BEGIN
	PRINT 'Value is NOT greater than 100'
	END

-- if exists
IF EXISTS (SELECT * FROM Staff WHERE StaffID = 5)
	BEGIN
	PRINT 'That staff member exists'
	END
ELSE
	BEGIN
	PRINT 'That staff does NOT exist'
	END

-- reviewing COUNT:
SELECT * 
FROM Payment
-- we see there are 33 rows: each row has a unique PaymentID
-- there are 6 different PaymentTypeIDs that are repeated throughout the table

SELECT COUNT(*) AS NumberRows -- 33 records
	, COUNT(PaymentID) AS CountPaymentID -- how many times is PaymentID NOT NULL
	, COUNT(DISTINCT PaymentID) AS CountDistinctPaymentID -- how many unique values for PaymentID
	, COUNT(DISTINCT PaymentTypeID) AS CountDistinctTypeID -- how many unique values for PaymentTypeID
FROM Payment -- child
-- if the question is: how many payments were there? We can use any of the first 3 COUNTs in this query
-- the last COUNT answers a slightly different question.


-- let's add a new PaymentType that has no Payments, so we can see what happens when we GROUP BY a parent with no children.
INSERT INTO PaymentType (PaymentTypeID, PaymentTypeDescription)
VALUES (7, 'Churros')

SELECT PaymentTypeDescription
	, COUNT(*) AS NumberRows 
	, COUNT(DISTINCT Payment.PaymentTypeID) AS CountDistinctTypeID -- how many unique values for PaymentTypeID in the child table
	, COUNT(DISTINCT PaymentType.PaymentTypeID) AS CountDistinctTypeID -- how many unique values for PaymentTypeID in the parent table
FROM Payment -- child
RIGHT JOIN PaymentType ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
GROUP BY PaymentTypeDescription, PaymentType.PaymentTypeID
-- OR we could have JOINed as follows:
--FROM PaymentType
--LEFT JOIN Payment ON Payment.PaymentTypeID = PaymentType.PaymentTypeID

-- if the question is "how many times has each payment type been used?" only one of these is correct: the count of PaymentType on the CHILD table.


-- reviewing HAVING:
-- select a list of payment type descriptions that have at least 3 payments
SELECT PaymentTypeDescription
	, COUNT(Payment.PaymentID) AS NumberPayments
FROM Payment
RIGHT JOIN PaymentType AS Type ON Payment.PaymentTypeID = Type.PaymentTypeID
GROUP BY Type.PaymentTypeID, PaymentTypeDescription
HAVING COUNT(Payment.PaymentID) > 3


-- global variables
-- @@ error:
INSERT INTO PaymentType (PaymentTypeID, PaymentTypeDescription)
VALUES (8, 'Churros')

PRINT @@ERROR

-- @@identity:
USE MemoriesForever

SELECT * FROM Item

INSERT INTO Item (ItemDescription, PricePerDay, ItemTypeID)
VALUES ('Watch', 100, 3)

PRINT @@identity

-- @@rowcount:
USE IQSchool
DELETE FROM PaymentType WHERE PaymentTypeID = 8

PRINT @@rowcount

-- creating then altering a procedure
GO

CREATE PROCEDURE SimpleSP AS
SELECT FirstName, LastName FROM Student
RETURN

GO

EXEC SimpleSP

GO

ALTER PROCEDURE SimpleSP AS
SELECT FirstName + ' ' + LastName AS FullName
FROM Student
RETURN

GO

EXEC SimpleSP

-- viewing the definition of an existing SP:
EXEC sp_helptext SimpleSP

------ TRANSACTIONS ------


-- first, an example using ROLLBACK:
BEGIN TRANSACTION -- creating our starting point 

SELECT * FROM Registration
DELETE FROM Registration -- deleting ALL the records
SELECT * FROM Registration

ROLLBACK TRANSACTION -- takes us back to what the db looked like @ the start
SELECT * FROM Registration

-- now, an example using COMMIT

USE quiz2
BEGIN TRANSACTION

SELECT * FROM ClubMembership
DELETE FROM ClubMembership

COMMIT TRANSACTION
SELECT * FROM ClubMembership

-- putting this together with DML:

-- BEGIN TRANSACTION
-- INSERT INTO Registration ...
-- check @@error
	-- if it didn't work: ROLLBACK TRANSACTION & RAISERROR
	-- if it worked: UPDATE Student ...
			-- check @@error
				-- if it worked: COMMIT TRANSACTION
				-- if the UPDATE failed: RAISERROR & ROLLBACK



-- review of SP:

GO
-- 4.	Create a stored procedure called ‘DisappearingStudent’ that accepts a studentID as a parameter and deletes all records pertaining to that student. It should look like that student was never in IQSchool! 

CREATE PROCEDURE DisappearingStudent (@StudentID INT = NULL)

AS

IF @StudentID IS NULL -- parameter is missing
	BEGIN
	RAISERROR('Student ID is required', 16, 1)
	END

ELSE -- param IS NOT missing
	BEGIN

	-- make sure that student exists:
	IF NOT EXISTS (SELECT * FROM Student WHERE StudentID = @StudentID) -- the student does NOT exist
		BEGIN
		RAISERROR('That student does not exist', 16, 1)
		END

	ELSE -- the student does exist
		BEGIN

		BEGIN TRANSACTION

		DELETE FROM Registration WHERE StudentID = @StudentID
		IF @@ERROR <> 0 -- the Registration delete FAILED
			BEGIN
			RAISERROR('Error deleting from Registration table', 16, 1)
			ROLLBACK TRANSACTION
			END

		ELSE -- that DELETE worked
			BEGIN
			DELETE FROM Activity WHERE StudentID = @StudentID
			IF @@ERROR <> 0 -- the Activity delete FAILED
				BEGIN
				RAISERROR('Error deleting from Activity table', 16, 1)
				ROLLBACK TRANSACTION
				END

			ELSE -- the Activity DELETE worked!
				BEGIN
				DELETE FROM Payment WHERE STudentID = @StudentID
				IF @@ERROR <> 0 -- the Payment delete FAILED
					BEGIN
					RAISERROR('Error deleting from Payment table', 16, 1)
					ROLLBACK TRANSACTION
					END

				ELSE -- the Payment delete worked
					BEGIN

					DELETE FROM Student WHERE StudentID = @StudentID
					IF @@ERROR <> 0 -- the Student delete FAILED
						BEGIN
						RAISERROR('Error deleting from Student table', 16, 1)
						ROLLBACK TRANSACTION
						END

					ELSE -- the student delete worked!!
						BEGIN
						COMMIT TRANSACTION
						END

					END
				END
			END
		END
	END


RETURN

GO

-- test case 1: test with NO parameters
EXEC DisappearingStudent
-- test with BAD params: test EACH DELETE statements: test with a student that doesn't exist
EXEC DisappearingStudent 111
-- test with GOOD params: all 4 DELETEs worked
EXEC DisappearingStudent 200578400
SELECT * FROM Student