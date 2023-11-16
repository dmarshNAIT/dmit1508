--Transaction Exercise
--Use the IQSchool database
USE IQSchool
GO

--1.	Create a stored procedure called ‘RegisterStudentTransaction’ that accepts StudentID and offering code as parameters. If the number of students in that course and semester are not greater than the Max Students for that course, add a record to the Registration table and add the cost of the course to the students balance. If the registration would cause the course in that semester to have greater than MaxStudents for that course raise an error.

--2.	Create a procedure called ‘StudentPaymentTransaction’  that accepts Student ID and paymentamount as parameters. Add the payment to the payment table and adjust the students balance owing to reflect the payment.

--3.	Create a stored procedure called ‘WithdrawStudentTransaction’ that accepts a StudentID and offeringcode as parameters. Withdraw the student by updating their Withdrawn value to ‘Y’ and subtract ½ of the cost of the course from their balance. If the result would be a negative balance set it to 0.

--4.	Create a stored procedure called ‘DisappearingStudent’ that accepts a StudentID as a parameter and deletes all records pertaining to that student. It should look like that student was never in IQSchool! 

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
			)

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
RETURN
GO