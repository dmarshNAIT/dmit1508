--Transaction Exercise
--1.	Create a stored procedure called ‘RegisterStudentTransaction’ that accepts StudentID and offering code as parameters. If the number of students in that course and semester are not greater than the Max Students for that course, add a record to the Registration table and add the cost of the course to the students balance. If the registration would cause the course in that semester to have greater than MaxStudents for that course raise an error.

CREATE PROCEDURE RegisterStudentTransaction (@StudentID INT = NULL, @OfferingCode INT = NULL)
AS

IF @StudentID IS NULL OR @OfferingCode IS NULL -- check params
	BEGIN
	RAISERROR('Must provide required parameters', 16, 1)
	END
ELSE -- we have parameters
	BEGIN
	DECLARE @MaxStudents INT
	DECLARE @StudentCount INT
	DECLARE @CourseCost MONEY

	SELECT @MaxStudents = MaxStudents -- get @MaxStudents
		, @CourseCost = CourseCost -- get @CourseCost
	FROM Course
	INNER JOIN Offering ON Course.CourseId = Offering.CourseID
	WHERE OfferingCode = @OfferingCode
	
	SELECT @StudentCount = COUNT(*) -- get @StudentCount
	FROM Registration
	WHERE OfferingCode = @OfferingCode
		AND WithdrawYN <> 'Y'
	
	IF @StudentCount >= @MaxStudents
		BEGIN
		RAISERROR('Class is already full', 16, 1)
		END
	ELSE -- there is room!
		BEGIN
		BEGIN TRANSACTION
		INSERT INTO Registration (StudentID, OfferingCode)
		VALUES (@StudentID, @OfferingCode)

		IF @@ERROR <> 0 -- check if INSERT failed 
			BEGIN
			RAISERROR('INSERT FAILED!', 16, 1)
			ROLLBACK TRANSACTION
			END 
		ELSE -- the INSERT worked :)
			BEGIN
			UPDATE Student
			SET BalanceOwing += @CourseCost
			WHERE StudentID = @StudentID
			IF @@ERROR <> 0 -- check if UPDATE failed 
				BEGIN
				RAISERROR('UPDATE FAILED!', 16, 1)
				ROLLBACK TRANSACTION
				END 
			ELSE -- the UPDATE worked :)
				BEGIN
				COMMIT TRANSACTION
				END 
			END 
		END 
	END
RETURN
GO
--2.	Create a procedure called ‘StudentPaymentTransaction’  that accepts Student ID and paymentamount as parameters. Add the payment to the payment table and adjust the students balance owing to reflect the payment.

CREATE PROCEDURE StudentPaymentTransaction (@StudentID INT = NULL, @PaymentAmount MONEY = NULL, @PaymentTypeID TINYINT = NULL)
AS
IF @StudentID IS NULL
	OR @PaymentAmount IS NULL
	OR @PaymentTypeID IS NULL
BEGIN
	RAISERROR ('Must provide a studentId, PaymentAmount and Payment Type ID', 16, 1)
END
ELSE
BEGIN
	BEGIN TRANSACTION

	INSERT INTO Payment (PaymentDate, Amount, PaymentTypeID, StudentID)
	VALUES (GETDATE(), @PaymentAmount, @PaymentTypeID, @StudentID)

	IF @@ERROR <> 0
	BEGIN
		RAISERROR ('Payment failed', 16, 1)
		ROLLBACK TRANSACTION
	END
	ELSE -- insert worked
		UPDATE Student
		SET BalanceOwing = BalanceOwing - @PaymentAmount
		WHERE StudentID = @StudentID

		IF @@ERROR <> 0
		BEGIN
			RAISERROR ('Balance update failed', 16, 1)

			ROLLBACK TRANSACTION
		END
		ELSE -- UPDATE worked
		BEGIN
			COMMIT TRANSACTION
		END
END

RETURN
GO

--3.	Create a stored procedure called ‘WithdrawStudentTransaction’ that accepts a StudentID and offeringcode as parameters. Withdraw the student by updating their Withdrawn value to ‘Y’ and subtract ½ of the cost of the course from their balance. If the result would be a negative balance set it to 0.

CREATE PROCEDURE WithdrawStudentTransaction (@StudentID INT = NULL, @OfferingCode INT = NULL)
AS
DECLARE @coursecost DECIMAL(6, 2)
DECLARE @amount DECIMAL(6, 2)
DECLARE @balanceowing DECIMAL(6, 2)
DECLARE @difference DECIMAL(6, 2)

IF @StudentID IS NULL
	OR @OfferingCode IS NULL
BEGIN
	RAISERROR ('You must provide a studentid and OfferingCode', 16, 1)
END
ELSE
BEGIN
	IF NOT EXISTS (
			SELECT *
			FROM registration
			WHERE StudentID = @StudentID
				AND OfferingCode = @OfferingCode
			)
	BEGIN
		RAISERROR ('that student does not exist in that registration', 16, 1)
	END
	ELSE
	BEGIN
		BEGIN TRANSACTION

		UPDATE registration
		SET WithdrawYN = 'Y'
		WHERE StudentID = @StudentID
			AND OfferingCode = @OfferingCode

		IF @@ERROR <> 0
		BEGIN
			RAISERROR ('registration update failed', 16, 1)

			ROLLBACK TRANSACTION
		END
		ELSE -- update worked
		BEGIN
			SELECT @coursecost = coursecost
			FROM Course
			INNER JOIN Offering ON course.CourseId = offering.CourseID
			WHERE Offering.OfferingCode = @OfferingCode

			SELECT @balanceowing = balanceowing
			FROM student
			WHERE StudentID = @studentId

			SELECT @difference = @balanceowing - @coursecost / 2

			IF @difference > 0
				SET @amount = @difference
			ELSE
				SET @amount = 0

			UPDATE Student
			SET BalanceOwing = @amount
			WHERE StudentID = @StudentID

			IF @@ERROR <> 0
			BEGIN
				RAISERROR ('balance update failed', 16, 1)
				ROLLBACK TRANSACTION
			END
			ELSE -- update worked!
			BEGIN
				COMMIT TRANSACTION
			END
		END
	END
END

RETURN
GO

--4.	Create a stored procedure called ‘DisappearingStudent’ that accepts a studentID as a parameter and deletes all records pertaining to that student. It should look like that student was never in IQSchool! 
CREATE PROCEDURE DisappearingStudent (@studentID INT = NULL)
AS
IF @studentID IS NULL
BEGIN
	RAISERROR ('You must provide a student ID', 16, 1)
END
ELSE
BEGIN
	BEGIN TRANSACTION

	DELETE registration
	WHERE StudentID = @studentID

	IF @@ERROR <> 0
	BEGIN
		RAISERROR ('Grade delete failed', 16, 1)

		ROLLBACK TRANSACTION
	END
	ELSE -- DELETE worked
	BEGIN
		DELETE Payment
		WHERE StudentID = @studentID

		IF @@ERROR <> 0
		BEGIN
			RAISERROR ('Payment delete failed', 16, 1)

			ROLLBACK TRANSACTION
		END
		ELSE -- delete worked
		BEGIN
			DELETE Activity
			WHERE StudentID = @studentID

			IF @@ERROR <> 0
			BEGIN
				RAISERROR ('Activity delete failed', 16, 1)

				ROLLBACK TRANSACTION
			END
			ELSE -- delete worked
			BEGIN
				DELETE Student
				WHERE StudentID = @studentID

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

CREATE TABLE ArchiveRegistration (OfferingCode INT, StudentID INT, Mark DECIMAL(5,2), WithdrawYN CHAR(1))

CREATE PROCEDURE ArchiveRegistrationRecords (@Year CHAR(4) = NULL)
AS
IF @Year IS NULL
	BEGIN
	RAISERROR ('Must provide year', 16, 1)
	END
ELSE
	BEGIN

	BEGIN TRANSACTION

	INSERT INTO ArchiveRegistration (OfferingCode, StudentID, Mark, WithdrawYN)
	SELECT Offering.OfferingCode, StudentID, Mark, WithdrawYN
		, StartDate
	FROM Registration
	INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
	INNER JOIN Semester ON Offering.SemesterCode = Semester.SemesterCode
	WHERE DATEPART(yy, StartDate) = @Year

	IF @@ERROR <> 0 -- check if INSERT failed 
		BEGIN
		RAISERROR('INSERT FAILED!', 16, 1)
		ROLLBACK TRANSACTION
		END 
	ELSE -- INSERT worked!
		BEGIN

		DELETE FROM Registration
		WHERE OfferingCode IN (
			SELECT OfferingCode
			FROM Offering
			WHERE SemesterCode IN ( -- or use a JOIN
				SELECT SemesterCode
				FROM Semester
				WHERE DATEPART(yy, StartDate) = @Year
			)
		)

		IF @@ERROR <> 0 -- check if DELETE failed 
			BEGIN
			RAISERROR('DELETE FAILED!', 16, 1)
			ROLLBACK TRANSACTION
			END 
		ELSE -- DELETE worked!
			BEGIN
			COMMIT TRANSACTION
			END
		END
	END
RETURN
GO