--Stored Procedures – DML exercise
--For this exercise you will need a local copy of the IQSchool database. 
USE IQSchool
GO


--1. Create a stored procedure called ‘AddClub’ to add a new club record.

-- create a procedure with 2 params: ClubID, ClubName
CREATE PROCEDURE AddClub (@ClubID VARCHAR(10) = NULL, @ClubName VARCHAR(50) = NULL)
AS

-- check for params
IF @ClubID IS NULL OR @ClubName IS NULL
	BEGIN
		RAISERROR('Missing parameter(s)', 16, 1)
	END
ELSE -- if we DO have both params:
	BEGIN-- INSERT a record into the Club table using these values
		INSERT INTO Club (ClubID, ClubName)
		VALUES (@ClubID, @ClubName)

		-- check the value of @@error, and raise an error if the statement failed
		IF @@ERROR != 0
			BEGIN
				RAISERROR('Oh no, the INSERT failed.', 16, 1)
			END
	END
RETURN -- end of the procedure
GO -- end of the batch

-- testing the SP:
SELECT * FROM Club
-- test missing params:
EXEC AddClub
-- test good params:
EXEC AddClub 'SA', 'Scotch Appreciation Club'
-- test bad params: 
EXEC AddClub 'SA', 'Sharmeen also'
GO

--2. Create a stored procedure called ‘DeleteClub’ to delete a club record.

--3. Create a stored procedure called ‘Updateclub’ to update a club record. Do not update the primary key!

--4. Create a stored procedure called ‘ClubMaintenance’. It will accept parameters for both ClubID and ClubName as well as a parameter to indicate if it is an insert, update or delete. This parameter will be ‘I’, ‘U’ or ‘D’.  insert, update, or delete a record accordingly. Focus on making your code as efficient and maintainable as possible.

--5.  Create a stored procedure called ‘RegisterStudent’ that accepts StudentID and OfferingCode as parameters. If the number of students in that Offering are not greater than the Max Students for that course, add a record to the Registration table and add the cost of the course to the students balance. If the registration would cause the Offering to have greater than the MaxStudents   raise an error.

-- create a SP called RegisterStudent (@StudentID, @OfferingCode)
CREATE PROCEDURE RegisterStudent (@StudentID INT = NULL, @OfferingCode INT = NULL) AS

-- check for missing params. If any are missing, RAISERROR.
IF @StudentID IS NULL OR @OfferingCode IS NULL
	BEGIN
		RAISERROR('Missing param(s) :(', 16, 1)
	END
-- otherwise:
ELSE
	BEGIN
		DECLARE @NumberOfStudents INT -- create a variable called @NumberOfStudents
		DECLARE @MaxStudents INT -- create a variable called @MaxStudents
		DECLARE @CourseCost DECIMAL(6, 2)

		-- provide values to both variables:
		SELECT @NumberOfStudents = COUNT(*)
		FROM Registration
		WHERE OfferingCode = @OfferingCode AND WithdrawYN != 'Y'

		SELECT @MaxStudents = MaxStudents
			, @CourseCost = CourseCost
		FROM Course
		INNER JOIN Offering ON Course.CourseId = Offering.CourseID
		WHERE OfferingCode = @OfferingCode

		-- if @NumberOfStudents is not greater than @MaxStudents
		IF @NumberOfStudents < @MaxStudents -- we have room!
			BEGIN
			BEGIN TRANSACTION
			
			INSERT INTO Registration (OfferingCode, StudentID)
			VALUES (@OfferingCode, @StudentID)

			IF @@ERROR <> 0 -- check if it failed: if so, RAISERROR & ROLLBACK
				BEGIN
					RAISERROR('Insert failed :(', 16, 1)
					ROLLBACK TRANSACTION
				END
			ELSE -- the INSERT worked!!!
				BEGIN

				UPDATE Student
				SET BalanceOwing = BalanceOwing + @CourseCost
				WHERE StudentID = @StudentID

				IF @@ERROR <> 0 -- check if it failed: if so, RAISERROR & ROLLBACK
					BEGIN
						RAISERROR('Update failed :(', 16, 1)
						ROLLBACK TRANSACTION
					END
				ELSE -- the update worked!!!!
					BEGIN
						COMMIT TRANSACTION
					END
				END
			END
		ELSE -- we don't have room
			BEGIN
				RAISERROR('Sorry, class is full', 16, 1)
			END
	END
RETURN -- end of SP
GO -- end of batch

--6. Create a procedure called ‘StudentPayment’ that accepts Student ID, paymentamount, and paymentTypeID as parameters. Add the payment to the payment table and adjust the students balance owing to reflect the payment. 

--7. Create a stored procedure caller ‘FireStaff’ that will accept a StaffID as a parameter. Fire the staff member by updating the record for that staff and entering todays date as the DateReleased. 

--8. Create a stored procedure called ‘WithdrawStudent’ that accepts a StudentID, and OfferingCode as parameters. Withdraw the student by updating their Withdrawn value to ‘Y’ and subtract ½ of the cost of the course from their balance. If the result would be a negative balance set it to 0.

-- SP with @StudentID & @OfferingCode as parameters

-- check params. If any are missing, RAISERROR.
-- otherwise:
	-- check if that student exists. If not, RAISERROR
	-- if they DO exist:
		BEGIN TRANSACTION
		-- UPDATE that Student's Registration: SET Withdrawn = 'Y'
			-- check if UPDATE worked. if not, RAISERROR & ROLLBACK

		-- create a variable to hold @CourseCost, and assign it a value
		-- create a variable to hold @NewBalance, and assign it a value
		-- if that @NewBalance is less than 0, change it to 0.

		-- UPDATE that STudent's Balance Owing
			-- check if UPDATE worked. if not, RAISERROR & ROLLBACK
			-- if it worked, COMMIT TRANSACTION

