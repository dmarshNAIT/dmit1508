--Transaction Exercise
--Use the IQSchool database
USE IQSchool
GO
--1. Create a stored procedure called ‘RegisterStudentTransaction’ that accepts StudentID
--and offering code as parameters. If the number of students in that course and semester
--are not greater than the Max Students for that course, add a record to the Registration
--table and add the cost of the course to the students balance. If the registration would
--cause the course in that semester to have greater than MaxStudents for that course
--raise an error.

--2. Create a procedure called ‘StudentPaymentTransaction’ that accepts Student ID and
--paymentamount as parameters. Add the payment to the payment table and adjust the
--students balance owing to reflect the payment.
CREATE PROCEDURE StudentPaymentTransaction (@StudentID INT = NULL, @PaymentAmount MONEY = NULL)
AS

-- check for missing params
IF @StudentID IS NULL OR @PaymentAmount IS NULL
	BEGIN
	RAISERROR('You forgot to give me some params', 16, 1)
	END
ELSE
	BEGIN
	BEGIN TRANSACTION
	-- INSERT payment to payment table
	INSERT INTO Payment (PaymentId, PaymentDate, Amount, PaymentTypeID, StudentID)
	VALUES (999, GetDate(), @PaymentAmount, 1, @StudentID) -- assumptions were made.
	-- using 999 is a terrible choice because it'll mean I can only run this SP once.
	-- realistically this column should have been an IDENTITY
	-- however, to keep it simple, we will hardcode this value and hope for better questions on the quiz. :)

	IF @@error != 0 -- check if it worked: ROLLBACK if not
		BEGIN
		RAISERROR('Something went wrong in the insert.', 16, 1)
		ROLLBACK TRANSACTION
		END
	ELSE -- the INSERT worked!!
		BEGIN
		-- UPDATE the student's balance owing
		UPDATE Student SET BalanceOwing = BalanceOwing - @PaymentAmount
		WHERE StudentID = @StudentID

		-- check if it worked: ROLLBACK if not, COMMIT if so
		IF @@ERROR != 0 -- something went wrong :(
			BEGIN
			RAISERROR('Update failed', 16, 1)
			ROLLBACK TRANSACTION
			END
		ELSE -- it worked!!!
			BEGIN
			COMMIT TRANSACTION
			END
		END
	END
RETURN
GO


--3. Create a stored procedure called ‘WithdrawStudentTransaction’ that accepts a
--StudentID and offeringcode as parameters. Withdraw the student by updating their
--Withdrawn value to ‘Y’ and subtract ½ of the cost of the course from their balance. If
--the result would be a negative balance set it to 0.

--4. Create a stored procedure called ‘DisappearingStudent’ that accepts a StudentID as a
--parameter and deletes all records pertaining to that student. It should look like that
--student was never in IQSchool!

--5. Create a stored procedure that will accept a year and will archive all registration records
--from that year (startdate is that year) from the registration table to an
--archiveregistration table. Copy all the appropriate records from the registration table to
--the archiveregistration table and delete them from the registration table. The
--archiveregistration table will have the same definition as the registration table but will
--not have any constraints.