--Stored Procedures – DML exercise
--Use the IQSchool database
USE IQSchool
GO

--1. Create a stored procedure called ‘AddClub’ to add a new club record.

-- create a procedure called AddClub
-- it will need parameters
-- I need to check if params were provided. If not, raise an error.
-- if I have all the params, then INSERT a new Club record

CREATE PROCEDURE AddClub (@ClubID VARCHAR(10) = NULL, @ClubName VARCHAR(50) = NULL)
AS

IF @ClubID IS NULL OR @ClubName IS NULL
	BEGIN --1
	RAISERROR('ClubID and ClubName are both required fields.', 16, 1)
	END  --1
ELSE -- we DO have parameters
	BEGIN  --2
	INSERT INTO Club (ClubID, ClubName) VALUES (@ClubID, @ClubName)
		IF @@ERROR != 0 --something went wrong
			BEGIN --3
			RAISERROR('Error when adding club', 16, 1)
			END --3
	END  --2
RETURN -- end of the SP
GO -- end of the batch

-- test:
-- test with missing params:
EXEC AddClub

-- test with valid params:
EXEC AddClub 'RBAS', 'Rodney Bread Appreciation Society'
SELECT * FROM Club

-- test with params that will cause the INSERT to fail:
EXEC AddClub 'RBAS', 'Really Bad Architecture Society'
-- this is a duplicate PK so this INSERT will not work.


--2. Create a stored procedure called ‘DeleteClub’ to delete a club record.
--3. Create a stored procedure called ‘Updateclub’ to update a club record. Do not update the
--primary key!

-- DO THIS ONE


--4. Create a stored procedure called ‘ClubMaintenance’. It will accept parameters for both ClubID
--and ClubName as well as a parameter to indicate if it is an insert, update or delete. This
--parameter will be ‘I’, ‘U’ or ‘D’. Insert, update, or delete a record accordingly. Focus on making
--your code as efficient and maintainable as possible.

--5. Create a stored procedure called ‘RegisterStudent’ that accepts StudentID and OfferingCode as parameters. If the number of students in that Offering is not greater than the Max Students for that course, add a record to the Registration table and add the cost of the course to the student’s balance. If the registration would cause the Offering to have greater than the MaxStudents raise an error.
GO

CREATE PROCEDURE RegisterStudent (@StudentID INT = NULL, @OfferingCode INT = NULL) AS

IF @StudentID IS NULL OR @OfferingCode IS NULL
	BEGIN --1
	RAISERROR('Student ID and Offering Code are both required fields', 16, 1)
	END --1
ELSE -- parameters WERE provided
	BEGIN

	DECLARE @NumberOfStudents INT
	DECLARE @MaxStudents INT
	DECLARE @CourseCost DECIMAL(6, 2)

	SELECT @NumberOfStudents = COUNT(StudentID)
	FROM Registration
	WHERE OfferingCode = @OfferingCode
		AND WithdrawYN = 'N'

	SELECT @MaxStudents = MaxStudents
		, @CourseCost = CourseCost
	FROM Course
	INNER JOIN Offering ON Course.CourseId = Offering.CourseId
	WHERE OfferingCode = @OfferingCode

	IF @NumberOfStudents >= @MaxStudents
		BEGIN
		RAISERROR('Sorry, that class is full', 16, 1)
		END
	ELSE -- there is room!
		BEGIN
		BEGIN TRANSACTION ------------------------------------------ START of transaction

		INSERT INTO Registration(OfferingCode, StudentID)
		VALUES (@OfferingCode, @StudentID)

		IF @@ERROR != 0 -- INSERT failed :(
			BEGIN
			RAISERROR('Could not register student', 16, 1)
			ROLLBACK TRANSACTION-----------------------------------------
			END
		ELSE -- INSERT worked!!!!
			BEGIN
		
			UPDATE Student
			SET BalanceOwing = BalanceOwing + @CourseCost
			WHERE StudentID = @StudentID

			IF @@ERROR != 0 -- UPDATE failed :(
				BEGIN
				RAISERROR('Could not update student', 16, 1)
				ROLLBACK TRANSACTION------------------------------------------
				END
			ELSE -- the UPDATE worked!!!
				BEGIN
				COMMIT TRANSACTION------------------------------------ END
				END

			END
		END
	END
RETURN -- the end of the SP

GO

--6. Create a procedure called ‘StudentPayment’ that accepts PaymentID, Student ID,
--paymentamount, and paymentTypeID as parameters. Add the payment to the payment table
--and adjust the students balance owing to reflect the payment.

--7. Create a stored procedure called ‘FireStaff’ that will accept a StaffID as a parameter. Fire the
--staff member by updating the record for that staff and entering today’s date as the
--DateReleased.
--8. Create a stored procedure called ‘WithdrawStudent’ that accepts a StudentID, and OfferingCode
--as parameters. Withdraw the student by updating their Withdrawn value to ‘Y’ and subtract ½
--of the cost of the course from their balance. If the result would be a negative balance set it to 0.