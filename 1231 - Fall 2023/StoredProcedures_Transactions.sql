--Transaction Exercise
--Use the IQSchool database
USE IQSchool
GO

--1.	Create a stored procedure called ‘RegisterStudentTransaction’ that accepts StudentID and offering code as parameters. If the number of students in that course and semester are not greater than the Max Students for that course, add a record to the Registration table and add the cost of the course to the students balance. If the registration would cause the course in that semester to have greater than MaxStudents for that course raise an error.

-- check if params were provided. if not, RAISERROR
-- otherwise: BEGIN TRANSACTION 
	-- INSERT INTO Registration ...
	-- check if the INSERT worked. if not, RAISERROR & ROLLBACK
	-- if it DID work: UPDATE Student ...
		-- check if the UPDATE worked. if not, RAISERROR & ROLLBACK
		-- if the UPDATE DID work: COMMIT TRANSACTION

CREATE PROCEDURE RegisterStudentTransaction (@StudentID INT = NULL, @OfferingCode INT = NULL)
AS

IF @StudentID IS NULL OR @OfferingCode IS NULL -- check params
	BEGIN
	RAISERROR('Missing param(s)', 16, 1)
	END
ELSE -- we DO have params
	BEGIN

	DECLARE @NumberStudents INT
	DECLARE @MaxStudents SMALLINT
	DECLARE @CourseCost DECIMAL(6,2)

	SELECT @NumberStudents = COUNT(*)
	FROM Registration
	WHERE OfferingCode = @OfferingCode AND WithdrawYN <> 'Y'

	SELECT @MaxStudents = MaxStudents
		, @CourseCost = CourseCost
	FROM Course
	INNER JOIN Offering ON Course.CourseId = Offering.CourseID
	WHERE OfferingCode = @OfferingCode

	IF @NumberStudents < @MaxStudents
		BEGIN

		BEGIN TRANSACTION -- because there are 2+ DML statements that need to both run

		INSERT INTO Registration (OfferingCode, StudentID)
		VALUES (@OfferingCode, @StudentID)

		IF @@ERROR <> 0 -- the INSERT failed :(
			BEGIN
			RAISERROR('Error adding student to Registration table', 16, 1)
			ROLLBACK TRANSACTION
			END
		ELSE -- the INSERT worked :)
			BEGIN

			UPDATE Student
			SET BalanceOwing = BalanceOwing + @CourseCost
			WHERE StudentID = @StudentID

			IF @@ERROR <> 0 -- the UPDATE failed :(
				BEGIN
				RAISERROR('Error updating balance owing', 16, 1)
				ROLLBACK TRANSACTION
				END
			ELSE -- the UPDATE worked :)
				BEGIN
				COMMIT TRANSACTION
				END
			END
		END
	ELSE -- @NumberStudents >= @MaxStudents
		BEGIN
		RAISERROR('Sorry, class is full', 16, 1)
		END
	END

RETURN
GO

--2.	Create a procedure called ‘StudentPaymentTransaction’  that accepts Student ID and paymentamount as parameters. Add the payment to the payment table and adjust the students balance owing to reflect the payment.

CREATE PROCEDURE StudentPaymentTransaction (@StudentID INT = NULL, @PaymentAmount MONEY = NULL) 
AS

IF @StudentID IS NULL OR @PaymentAmount IS NULL
	BEGIN
	RAISERROR('Missing param(s)', 16, 1)
	END
ELSE -- we DO have params:
	BEGIN
	BEGIN TRANSACTION -- our checkpoint

	INSERT INTO Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
	VALUES(100, GetDate(), @PaymentAmount, 1, @StudentID)
	-- this is hacky approach, but I wanted to keep the logic simple. 
	-- See DML Exercise for a more elegant approach

	IF @@ERROR <> 0 -- the INSERT failed
		BEGIN
		RAISERROR('The INSERT failed', 16, 1)
		ROLLBACK TRANSACTION
		END
	ELSE -- the INSERT worked!
		BEGIN

		UPDATE Student
		SET BalanceOwing = BalanceOwing - @PaymentAmount
		WHERE StudentID = @StudentID

		IF @@ERROR <> 0 -- the UPDATE failed
			BEGIN
			RAISERROR('the UPDATE failed', 16, 1)
			ROLLBACK TRANSACTION
			END
		ELSE -- the UPDATE worked
			BEGIN
			COMMIT TRANSACTION
			END
		END
	END
RETURN -- end of my SP
GO

--3.	Create a stored procedure called ‘WithdrawStudentTransaction’ that accepts a StudentID and offeringcode as parameters. Withdraw the student by updating their Withdrawn value to ‘Y’ and subtract ½ of the cost of the course from their balance. If the result would be a negative balance set it to 0.

CREATE PROCEDURE WithdrawStudentTransaction (@StudentID INT = NULL, @OfferingCode INT = NULL)
AS

IF @StudentID IS NULL OR @OfferingCode IS NULL
	BEGIN
	RAISERROR('Missing params', 16, 1)
	END
ELSE -- the params WERE provided
	BEGIN

	IF NOT EXISTS (	SELECT * 
					FROM Registration 
					WHERE StudentID = @StudentID 
						AND OfferingCode = @OfferingCode) 
					-- does Student have this record in the Reg table?
		BEGIN
		RAISERROR('That student is not registered for this course', 16, 1)
		END
	ELSE -- the student IS registered
		BEGIN

		BEGIN TRANSACTION

		-- UPDATE WithDrawn value
		UPDATE Registration
		SET WithdrawYN = 'Y'
		WHERE StudentID = @StudentID 
			AND OfferingCode = @OfferingCode

		-- check if UPDATE worked:
		IF @@ERROR <> 0
			BEGIN
			RAISERROR('Student could not be withdrawn', 16, 1)
			ROLLBACK TRANSACTION
			END
		ELSE -- the UPDATE did work
			BEGIN

			-- create a helper variable:
			DECLARE @CourseCost DECIMAL(6,2)

			SELECT @CourseCost = CourseCost
			FROM Course
			INNER JOIN Offering ON Course.CourseId = Offering.CourseID
			WHERE OfferingCode = @OfferingCode

			DECLARE @NewBalanceOwing MONEY

			SELECT @NewBalanceOwing = BalanceOwing - (@CourseCost / 2)
			FROM Student
			WHERE StudentID = @StudentID

			IF @NewBalanceOwing < 0 
				BEGIN
				SET @NewBalanceOwing = 0 
				END

			UPDATE Student
			SET BalanceOwing = @NewBalanceOwing
			WHERE StudentID = @StudentID

			IF @@ERROR <> 0 -- the UPDATE failed
				BEGIN
				RAISERROR('Error updating Balance Owing', 16, 1)
				ROLLBACK TRANSACTION
				END
			ELSE -- the UPDATE worke!
				BEGIN
				COMMIT TRANSACTION
				END
			END
		END
	END
RETURN
GO

--4.	Create a stored procedure called ‘DisappearingStudent’ that accepts a StudentID as a parameter and deletes all records pertaining to that student. It should look like that student was never in IQSchool! 

CREATE PROCEDURE DisappearingStudent (@StudentID INT = NULL)
AS
IF @StudentID IS NULL
	BEGIN
	RAISERROR ('You must provide a student ID', 16, 1)
	END
ELSE
	BEGIN
	BEGIN TRANSACTION

	DELETE FROM Registration
	WHERE StudentID = @StudentID

	IF @@ERROR <> 0
		BEGIN
		RAISERROR ('Grade delete failed', 16, 1)
		ROLLBACK TRANSACTION
		END
	ELSE -- DELETE worked
		BEGIN
		DELETE FROM Payment
		WHERE StudentID = @StudentID

		IF @@ERROR <> 0
			BEGIN
			RAISERROR ('Payment delete failed', 16, 1)
			ROLLBACK TRANSACTION
			END
		ELSE -- delete worked
			BEGIN
			DELETE FROM Activity
			WHERE StudentID = @StudentID

			IF @@ERROR <> 0
				BEGIN
				RAISERROR ('Activity delete failed', 16, 1)
				ROLLBACK TRANSACTION
				END
			ELSE -- delete worked
				BEGIN
				DELETE FROM Student
				WHERE StudentID = @StudentID

				IF @@ERROR <> 0
					BEGIN
					RAISERROR ('Student delete failed', 16, 1)
					ROLLBACK TRANSACTION
					END
				ELSE
					BEGIN
					COMMIT TRANSACTION
					END
				END
			END
		END
	END

RETURN
GO

--5.	Create a stored procedure that will accept a year and will archive all registration records from that year (startdate is that year) from the registration table to an archiveregistration table. Copy all the appropriate records from the registration table to the archiveregistration table and delete them from the registration table. The archiveregistration table will have the same definition as the registration table but will not have any constraints.

-- first, let's create ArchiveRegistration
CREATE TABLE ArchiveRegistration
(
	OfferingCode	INT NOT NULL,
	StudentID		INT	NOT NULL,
	Mark			DECIMAL(5,2)	NULL,
	WithdrawYN		CHAR(1)			NULL
)

GO
-- create a SP with year as a param
CREATE PROCEDURE sp_ArchiveRegistration (@year INT = NULL)
AS

-- check if params are missing. if so, RAISERROR
IF @year IS NULL
	BEGIN
	RAISERROR('Year is a required parameter for this SP', 16, 1)
	END

ELSE -- we do have parameters
	BEGIN

	BEGIN TRANSACTION 

	-- copy from reg to archive (SELECT & INSERT)
	INSERT INTO ArchiveRegistration (OfferingCode, StudentID, Mark, WithdrawYN)
	SELECT Offering.OfferingCode, StudentID, Mark, WithdrawYN
	FROM Registration
	INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
	INNER JOIN Semester ON Offering.SemesterCode = Semester.SemesterCode
	WHERE YEAR(StartDate) = @year

	-- check if it worked. if not, RAISERROR & ROLLBACK
	IF @@ERROR != 0 -- something went wrong
		BEGIN
		RAISERROR('Could not archive records', 16, 1)
		ROLLBACK TRANSACTION
		END
	ELSE -- the INSERT was a success
		BEGIN

		DELETE FROM Registration
		WHERE OfferingCode IN  -- offering code was in a semester that started in 2023
			(SELECT OfferingCode FROM Offering WHERE SemesterCode IN
				-- a list of semesters that started in the given year:
				(SELECT SemesterCode FROM Semester WHERE YEAR(StartDate) = @year)
			) -- instead of multiple subqueries, we could have used a JOIN

		IF @@ERROR != 0 -- something went wrong
			BEGIN
			RAISERROR('Could not delete records', 16, 1)
			ROLLBACK TRANSACTION
			END
		ELSE -- it worked!!!
			BEGIN
			COMMIT TRANSACTION
			END
		END
	END -- ends the outer ELSE
RETURN -- end my SP
GO -- end my batch

-- testing time:
SELECT COUNT(*) FROM Registration -- 70 records
SELECT COUNT(*) FROM ArchiveRegistration -- 0 records
EXEC sp_ArchiveRegistration 2022
SELECT COUNT(*) FROM Registration -- 70-9 = 61 records?
SELECT COUNT(*) FROM ArchiveRegistration -- 9 records