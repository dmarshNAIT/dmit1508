--Stored Procedures – DML exercise
--Use the IQSchool database
USE IQSchool
GO


--1.	Create a stored procedure called ‘AddClub’ to add a new club record.

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

-- Test plan:
-- test with missing params
-- test with "good" parameters
-- test with bad parameters e.g. a duplicate ClubID

--2.	Create a stored procedure called ‘DeleteClub’ to delete a club record.

CREATE PROCEDURE DeleteClub (@ClubID VARCHAR(10) = NULL)
AS

-- check params were provided:
IF @ClubID IS NULL
	BEGIN
	RAISERROR('Missing parameter', 16, 1)
	END
ELSE -- params WERE provided:
	BEGIN
	-- check if that record exists:
	IF EXISTS (	SELECT * FROM Club WHERE ClubID = @ClubID )
		BEGIN
		-- DELETE that Club:
		DELETE FROM Club WHERE ClubId = @ClubID
		-- check whether the DELETE worked:
		IF @@ERROR <> 0
			BEGIN
			RAISERROR('Oh no! The DELETE failed!', 16, 1)
			END -- end of the "if error" branch
		END
	ELSE -- that record does NOT exist
		BEGIN
		RAISERROR('That Club does not exist', 16, 1)
		END
	END

RETURN
GO


-- TEST PLAN:
-- 1: test with "good params": a Club that IS in the table
-- 2: test with "bad" params: a Club that has a child record in the Activity table
-- 3: test with a Club that's not in the Club table
-- 4: test with missing parameters

--3.	Create a stored procedure called ‘Updateclub’ to update a club record. Do not update the primary key!

CREATE PROCEDURE UpdateClub (@ClubID VARCHAR(10) = NULL, @NewClubName VARCHAR(50) = NULL)
AS

IF @ClubID IS NULL OR @NewClubName IS NULL -- check if params are missing
	BEGIN  --1
	RAISERROR('Missing parameter(s)', 16, 1)
	END   --1
ELSE -- we DO have params
	BEGIN  --2
	IF EXISTS (SELECT * FROM Club WHERE ClubId = @ClubID)-- check that the record exists
		BEGIN --3

		-- if so, UPDATE it
		UPDATE Club
		SET ClubName = @NewClubName
		WHERE ClubId = @ClubID

		-- check if the UPDATE worked
		IF @@ERROR <> 0
			BEGIN --5
			RAISERROR('Oh no! The UPDATE failed!', 16, 1)
			END -- 5
		END --3
	ELSE -- it does not exist
		BEGIN --4
		RAISERROR('That ClubID does not exist', 16, 1)
		END --4
	END --2
RETURN
GO

-- TEST PLAN:
-- 1: test with missing params
-- 2: test with a ClubID that is NOT in the table
-- 3: test with a ClubID that IS in the table & can be updated
-- 4: test with a ClubID that cannot be UPDATEd (given the fields in this table, we can't easily test this)

--4.	Create a stored procedure called ‘ClubMaintenance’. It will accept parameters for both ClubID and ClubName as well as a parameter to indicate if it is an insert, update or delete. This parameter will be ‘I’, ‘U’ or ‘D’.  Insert, update, or delete a record accordingly. Focus on making your code as efficient and maintainable as possible.


CREATE PROCEDURE ClubMaintenance (@ClubID VARCHAR(10) = NULL
							, @ClubName VARCHAR(50) = NULL
							, @DMLType CHAR(1) = NULL)
AS
IF @ClubID IS NULL OR @ClubName IS NULL OR @DMLType IS NULL-- check if params are missing
	BEGIN  
	RAISERROR('Missing parameter(s)', 16, 1)
	END   
ELSE -- we DO have params
	BEGIN
	
	IF @DMLType = 'I' -- if it's an INSERT
		BEGIN
		-- add club record to Club table
		INSERT INTO Club (ClubID, ClubName)
		VALUES (@ClubID, @ClubName)
		END -- INSERT branch
	ELSE -- it's either UPDATE or DELETE
		BEGIN
		IF EXISTS (SELECT * FROM Club WHERE ClubId = @ClubID)-- check that the record exists
			BEGIN
			IF @DMLType = 'U' -- if it's an UPDATE
				BEGIN
				UPDATE Club
				SET ClubName = @ClubName
				WHERE ClubId = @ClubID
				END
			ELSE IF @DMLType = 'D' -- if it's a DELETE
				BEGIN
				DELETE FROM Club WHERE ClubId = @ClubID
				END
			END
		ELSE -- it does not exist
			BEGIN
			RAISERROR('That Club does not exist', 16, 1)
			END -- end of "it does not exist branch"
		END -- UPDATE/DELETE branch
	IF @@ERROR <> 0
		BEGIN
		RAISERROR('Something went wrong.', 16, 1)
		END
	END -- end of the "we do have params" branch
RETURN
GO

-- test plan:
-- 1: missing params
-- 2: successful INSERT
-- 3: failed INSERT: bad params
-- 4: successful UPDATE
-- 5: failed UPDATE: bad params AND does not exist
-- 6: successful DELETE
-- 7: failed DELETE: bad params AND does not exist

--5.	 Create a stored procedure called ‘RegisterStudent’ that accepts StudentID and OfferingCode as parameters. If the number of students in that Offering is not greater than the Max Students for that course, add a record to the Registration table and add the cost of the course to the student’s balance. If the registration would cause the Offering to have greater than the MaxStudents raise an error. 


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

--6.	Create a procedure called ‘StudentPayment’ that accepts PaymentID, Student ID, paymentamount, and paymentTypeID as parameters. Add the payment to the payment table and adjust the students balance owing to reflect the payment. 


CREATE PROCEDURE StudentPayment (@StudentID INT = NULL
								, @PaymentAmount MONEY = NULL
								, @PaymentTypeID TINYINT = NULL)
AS
IF @StudentID IS NULL OR @PaymentAmount IS NULL OR @PaymentTypeID IS NULL
	BEGIN
	RAISERROR('Missing param(s)', 16, 1)
	END
ELSE -- we DO have paramaters
	BEGIN

	DECLARE @PaymentID INT
	SELECT @PaymentID = MAX(PaymentID) + 1 FROM Payment

	INSERT INTO Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
	VALUES (@PaymentID, GetDate(), @PaymentAmount, @PaymentTypeID, @StudentID)

	IF @@ERROR <> 0 -- the INSERT failed :(
		BEGIN
		RAISERROR('Error adding Payment', 16, 1)
		END
	ELSE -- the INSERT worked :)
		BEGIN
		
		UPDATE Student
		SET BalanceOwing = BalanceOwing - @PaymentAmount
		WHERE StudentID = @StudentID

		IF @@ERROR <> 0
			BEGIN
			RAISERROR('Error updating balance owing', 16, 1)
			END
		END
	END
RETURN
GO

--7.	Create a stored procedure called ‘FireStaff’ that will accept a StaffID as a parameter. Fire the staff member by updating the record for that staff and entering today’s date as the DateReleased. 

CREATE PROCEDURE FireStaff (@StaffID INT = NULL)
AS
IF @StaffID IS NULL
	BEGIN
	RAISERROR('StaffID is required', 16, 1)
	END
ELSE -- we DO have params:
	BEGIN
	IF NOT EXISTS (SELECT * FROM Staff WHERE StaffID = @StaffID)
		BEGIN
		RAISERROR('That Staff member does not work here', 16, 1)
		END
	ELSE -- the Staff member DOES exist
		BEGIN

		UPDATE Staff
		SET DateReleased = GetDate()
		WHERE StaffID = @StaffID

		IF @@ERROR <> 0
			BEGIN
			RAISERROR('Staff member could not be let go', 16, 1)
			END
		END
	END
RETURN
GO

--8.	Create a stored procedure called ‘WithdrawStudent’ that accepts a StudentID, and OfferingCode as parameters. Withdraw the student by updating their Withdrawn value to ‘Y’ and subtract ½ of the cost of the course from their balance. If the result would be a negative balance set it to 0.

-- SP with @StudentID & @OfferingCode as parameters

-- check params. If any are missing, RAISERROR.
-- otherwise:
	-- check if that student exists. If not, RAISERROR
	-- if they DO exist:
		-- BEGIN TRANSACTION
		-- UPDATE that Student's Registration: SET Withdrawn = 'Y'
			-- check if UPDATE worked. if not, RAISERROR & ROLLBACK

		-- create a variable to hold @CourseCost, and assign it a value
		-- create a variable to hold @NewBalance, and assign it a value
		-- if that @NewBalance is less than 0, change it to 0.

		-- UPDATE that STudent's Balance Owing
			-- check if UPDATE worked. if not, RAISERROR & ROLLBACK
			-- if it worked, COMMIT TRANSACTION

CREATE PROCEDURE WithdrawStudent (@StudentID INT = NULL, @OfferingCode INT = NULL)
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

			IF @@ERROR <> 0
				BEGIN
				RAISERROR('Error updating Balance Owing', 16, 1)
				ROLLBACK TRANSACTION
				END	
			ELSE -- the UPDATE worked
				BEGIN
				COMMIT TRANSACTION
				END
			END
		END
	END
RETURN
GO

-- test!
-- missing params
-- good params (a student who CAN be withdrawn and has a > 0 balance)
-- good params (a student who CAN be withdrawn and has a < 0 balance)
-- bad params (a student who is not Registered)