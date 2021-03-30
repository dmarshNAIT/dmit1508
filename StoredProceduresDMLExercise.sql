--Stored Procedures – DML exercise
--For this exercise you will need a local copy of the IQSchool database. 
USE IQSchool
GO

-- CHECKLIST:

-- check params aren't missing
-- check DML didn't fail
-- check how many records were updated/deleted



--1.	Create a stored procedure called ‘AddClub’ to add a new club record.

CREATE PROCEDURE AddClub (@ClubID VARCHAR(10) = NULL
		, @ClubName VARCHAR(50) = NULL) 
AS

-- check params. if they are NULL, RAISERROR
IF @ClubID IS NULL OR @ClubName IS NULL
	BEGIN
	RAISERROR('Missing parameters', 16, 1)
	END
ELSE -- if we DO have params:
	BEGIN
	-- add club: 
	INSERT INTO Club (ClubID, ClubName)
	VALUES (@ClubID, @ClubName)
	-- check if INSERT worked. if NOT, RAISERROR
	IF @@ERROR <> 0
		BEGIN
		RAISERROR('The INSERT failed.', 16, 1)
		END
	END

RETURN -- end of the procedure
GO -- end of the batch

SELECT * FROM Club
-- test with "good" params
EXEC AddClub 'AWC', 'Awesome Wild Club'
-- test with missing params
EXEC AddClub
-- test with "bad" param: duplicate PK
EXEC AddClub 'ACM', 'Awesome Chess Masters'

GO
--2.	Create a stored procedure called ‘DeleteClub’ to delete a club record.

-- will do live on Wednesday (almost identical to #3)

--3.	Create a stored procedure called ‘Updateclub’ to update a club record. Do not update the primary key!

CREATE PROCEDURE UpdateClub (@ClubID VARCHAR(10) = NULL
							, @NewClubName VARCHAR(50) = NULL) 
AS

IF @ClubID IS NULL OR @NewClubName IS NULL -- check if params are missing
	BEGIN
	RAISERROR('Missing params', 16, 1)
	END
ELSE -- otherwise:
	IF EXISTS (SELECT * FROM Club WHERE ClubId = @ClubID) -- check to see the record exists.
		BEGIN

		UPDATE Club -- update the ClubName
		SET ClubName = @NewClubName
		WHERE ClubID = @ClubID		
		
		IF @@ERROR <> 0 -- check it worked. if not, raiserror.
			BEGIN
			RAISERROR('The UPDATE failed.', 16, 1)
			END

		END
		
	ELSE -- raiserror that the record does not exist
		BEGIN
		RAISERROR('No record to update', 16, 1)
		END

RETURN
GO


-- test plan:
-- 1. test with missing params / NULL params
-- 2. test with a ClubID that does not exist in the table
-- 3. test with a good ClubID
-- 4. test an UPDATE that will not work: given the fields we have, we can't easily test this.


--4.	Create a stored procedure called ‘ClubMaintenance’. It will accept parameters for both ClubID and ClubName as well as a parameter to indicate if it is an insert, update or delete. This parameter will be ‘I’, ‘U’ or ‘D’.  insert, update, or delete a record accordingly. Focus on making your code as efficient and maintainable as possible.


CREATE PROCEDURE ClubMaintenance (@ClubID VARCHAR(10) = NULL
								, @ClubName VARCHAR(50) = NULL
								, @DMLType CHAR(1) = NULL)
AS
IF @ClubID IS NULL OR @ClubName IS NULL OR @DMLType IS NULL
	BEGIN
	RAISERROR ('Must provide ClubID, Club Name, and DML Type.', 16, 1)
	END
ELSE
	BEGIN
	IF @DMLType = 'I'
		BEGIN
		INSERT INTO Club (ClubId, ClubName)
		VALUES (@ClubID, @ClubName)
		END -- INSERT branch
	ELSE -- DMLType is U or D
		BEGIN
		IF NOT EXISTS (SELECT * FROM Club WHERE ClubID = @ClubID) -- club doesn't exist
			BEGIN
			RAISERROR('That club does not exist', 16, 1)
			END
		ELSE -- the club DOES exist
			BEGIN
			IF @DMLType = 'U'
				BEGIN
				UPDATE Club
				SET ClubName = @ClubName
				WHERE ClubId = @ClubID
				END
			ELSE IF @DMLType = 'D' -- if we know they'll only pass I, U, or D, this could just be ELSE
				BEGIN
				DELETE FROM Club WHERE ClubId = @ClubID
				END -- if DELETE branch
			END -- if exist branch
		END -- if UPDATE/DELETE branch 
	IF @@ERROR <> 0
		BEGIN
		RAISERROR('operation FAILED!', 16, 1)
		END 
	END
RETURN
GO


--5.	 Create a stored procedure called ‘RegisterStudent’ that accepts StudentID and OfferingCode as parameters. If the number of students in that Offering are not greater than the Max Students for that course, add a record to the Registration table and add the cost of the course to the students balance. If the registration would cause the Offering to have greater than the MaxStudents   raise an error. 

-- check params
-- get @MaxStudents
-- get @StudentCount
-- get @CourseCost
-- if @StudentCount is not greater than @MaxStudents
	-- BEGIN TRANSACTION
	-- INSERT
		-- check if failed (RAISERROR & ROLLBACK)
	-- UPDATE
		-- check if failed (RAISERROR & ROLLBACK)
	-- if both work: COMMIT
-- otherwise: RAISERROR


CREATE PROCEDURE RegisterStudent (
	@StudentID INT = NULL
	, @OfferingCode INT = NULL
	)
AS
IF @StudentID IS NULL
	OR @OfferingCode IS NULL
BEGIN
	RAISERROR (
			'You must provide a studentid and offering code'
			, 16
			, 1
			)
END
ELSE
BEGIN
	DECLARE @MaxStudents SMALLINT
	DECLARE @CurrentCount SMALLINT
	DECLARE @CourseCost MONEY

	SELECT @MaxStudents = MaxStudents
	FROM Course
	INNER JOIN Offering ON course.CourseId = offering.CourseID
	WHERE offeringcode = @offeringcode

	SELECT @CurrentCount = COUNT(*)
	FROM Registration
	WHERE OfferingCode = @OfferingCode
		AND WithdrawYN <> 'Y'

	SELECT @CourseCost = coursecost
	FROM Course
	INNER JOIN Offering ON course.CourseId = offering.CourseID
	WHERE Offering.OfferingCode = @OfferingCode

	IF @MaxStudents = @currentcount
	BEGIN
		RAISERROR (
				'The course is already full'
				, 16
				, 1
				)
	END
	ELSE
	BEGIN
		INSERT INTO registration (
			StudentID
			, OfferingCode
			)
		VALUES (
			@StudentID
			, @OfferingCode
			)

		IF @@ERROR <> 0
		BEGIN
			RAISERROR (
					'registration insert failed'
					, 16
					, 1
					)
		END
		ELSE
		BEGIN
			UPDATE Student
			SET BalanceOwing = BalanceOwing + @CourseCost
			WHERE StudentID = @StudentID

			IF @@ERROR <> 0
			BEGIN
				RAISERROR (
						'balance update failed'
						, 16
						, 1
						)
			END
		END
	END
END

RETURN
GO


--6.	Create a procedure called ‘StudentPayment’ that accepts Student ID, paymentamount, and paymentTypeID as parameters. Add the payment to the payment table and adjust the students balance owing to reflect the payment.

-- check params. if null, error.
-- otherwise: INSERT
	-- check if failed
-- if it didn't fail: UPDATE
	-- check if failed

CREATE PROCEDURE StudentPayment (
	@StudentID INT = NULL
	, @PaymentAmount MONEY = NULL
	, @PaymentTypeID TINYINT = NULL
	)
AS
IF @StudentID IS NULL
	OR @PaymentAmount IS NULL
	OR @PaymentTypeID IS NULL
BEGIN
	RAISERROR (
			'Must provide a studentId, Paymentamount and Payment Type ID'
			, 16
			, 1
			)
END
ELSE
BEGIN
	INSERT INTO Payment (
		PaymentDate
		, Amount
		, PaymentTypeID
		, StudentID
		)
	VALUES (
		GETDATE()
		, @PaymentAmount
		, @PaymentTypeID
		, @StudentID
		)

	IF @@ERROR <> 0
	BEGIN
		RAISERROR (
				'Payment failed'
				, 16
				, 1
				)
	END
	ELSE
	BEGIN
		--do not need to check for exists since the previous insert would have failed if the
		--studentid was not a valid student
		UPDATE Student
		SET BalanceOwing = BalanceOwing - @PaymentAmount
		WHERE StudentID = @StudentID

		IF @@ERROR <> 0
		BEGIN
			RAISERROR (
					'Balance update failed'
					, 16
					, 1
					)
		END
	END
END

RETURN
GO


--7.	Create a stored procedure caller ‘FireStaff’ that will accept a StaffID as a parameter. Fire the staff member by updating the record for that staff and entering today's date as the DateReleased. 

CREATE PROCEDURE FireStaff (@StaffID INT = NULL)
AS
IF @StaffID IS NULL
	BEGIN
	RAISERROR('Must provide staff ID', 16, 1)
	END
ELSE
	BEGIN
	IF NOT EXISTS (SELECT * FROM Staff WHERE StaffID = @StaffID)
		BEGIN
		RAISERROR('That staff does not exist', 16, 1)
		END
	ELSE
		BEGIN
		UPDATE Staff
		SET DateReleased = GetDate()
		WHERE StaffID = @StaffID
		
		IF @@ERROR <> 0
			BEGIN
			RAISERROR('Firing failed', 16, 1)
			END
		END
	END
RETURN
GO


--8.	Create a stored procedure called ‘WithdrawStudent’ that accepts a StudentID, and OfferingCode as parameters. Withdraw the student by updating their Withdrawn value to ‘Y’ and subtract ½ of the cost of the course from their balance. If the result would be a negative balance set it to 0.



-- check params. if null, error.
-- otherwise:
	-- check there are records to update
	-- UPDATE
	-- check if that failed
	-- UPDATE**
	-- check if that one failed
	-- ** add logic to make sure the balance isn't negative

CREATE PROCEDURE WithdrawStudent (
	@StudentID INT = NULL
	, @OfferingCode INT = NULL
	)
AS
DECLARE @coursecost DECIMAL(6, 2)
DECLARE @amount DECIMAL(6, 2)
DECLARE @balanceowing DECIMAL(6, 2)
DECLARE @difference DECIMAL(6, 2)

IF @StudentID IS NULL
	OR @OfferingCode IS NULL
BEGIN
	RAISERROR (
			'You must provide a studentid and OfferingCode'
			, 16
			, 1
			)
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
		RAISERROR (
				'that student does not exist in that registration'
				, 16
				, 1
				)
	END
	ELSE
	BEGIN
		UPDATE registration
		SET WithdrawYN = 'Y'
		WHERE StudentID = @StudentID
			AND OfferingCode = @OfferingCode

		IF @@ERROR <> 0
		BEGIN
			RAISERROR (
					'registration update failed'
					, 16
					, 1
					)
		END
		ELSE
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
				RAISERROR (
						'balance update failed'
						, 16
						, 1
						)
			END
		END
	END
END

RETURN



