--Stored Procedures – DML exercise
--Author: Dana Marsh
--For this exercise you will need a local copy of the IQSchool database. 
USE [IQ-School]
GO


--1.	Create a stored procedure called ‘AddClub’ to add a new club record.
CREATE PROCEDURE AddClub (@ClubID VARCHAR(10) = NULL, @ClubName VARCHAR(50) = NULL)
AS
IF @ClubID IS NULL OR @ClubName IS NULL
	BEGIN
		RAISERROR('Must provide ClubID and ClubName', 16, 1)
	END
ELSE
	BEGIN
		INSERT INTO Club (ClubId, ClubName)
		VALUES (@ClubID, @ClubName)

		IF @@ERROR <> 0
			BEGIN
				RAISERROR('INSERT FAILED!', 16, 1)
			END
	END
RETURN
GO

SELECT * FROM Club
EXEC AddClub 'ACM', 'Amazing Chess Masters'
EXEC AddClub 'ZZZ', 'dgdgdfgdfgdfg'
EXEC AddClub 'ZZZZZZZZZZZZ', 'dgdgdfgdfgdfg' -- Dana to look into why this works

GO


--2.	Create a stored procedure called ‘DeleteClub’ to delete a club record.

CREATE PROCEDURE DeleteClub (@ClubID VARCHAR(10) = NULL)
AS
IF @ClubID IS NULL
	BEGIN
		RAISERROR('Must provide ClubID', 16, 1)
	END
ELSE
	BEGIN
	IF NOT EXISTS (SELECT * FROM Club WHERE ClubID = @ClubID)
		BEGIN
			RAISERROR('There are no records with that ClubID', 16, 1)
		END
	ELSE
		BEGIN
			DELETE FROM Club WHERE ClubId = @ClubID
			IF @@ERROR <> 0
			BEGIN
				RAISERROR('DELETE FAILED!', 16, 1)
			END
		END		
	END
RETURN
GO

--3.	Create a stored procedure called ‘Updateclub’ to update a club record. Do not update the primary key!

CREATE PROCEDURE UpdateClub (@ClubID VARCHAR(10) = NULL, @ClubName VARCHAR(50) = NULL)
AS
IF @ClubID IS NULL OR @ClubName IS NULL
	BEGIN
		RAISERROR('Must provide ClubID and ClubName', 16, 1)
	END
ELSE 
	BEGIN
		IF NOT EXISTS (SELECT * FROM Club WHERE ClubID = @ClubID)
			BEGIN
				RAISERROR('There are no records with that ClubID', 16, 1)
			END
		ELSE
			BEGIN
				UPDATE Club
				SET ClubName = @ClubName
				WHERE ClubId = @ClubID

				IF @@ERROR <> 0
					BEGIN
						RAISERROR('UPDATE FAILED!', 16, 1)
					END 
			END
	END
RETURN 
GO

SELECT * FROM Club
EXEC UpdateClub 'ZZZ', 'here is a valid name'
EXEC UpdateClub 'ABC', 'sflsdlkfsdsd'
EXEC UpdateClub 'CHESS', 'asdasdasda'
GO

--4.	Create a stored procedure called ‘ClubMaintenance’. It will accept parameters for both ClubID and ClubName as well as a parameter to indicate if it is an insert, update or delete. This parameter will be ‘I’, ‘U’ or ‘D’.  insert, update, or delete a record accordingly. Focus on making your code as efficient and maintainable as possible.
CREATE PROCEDURE ClubMaintenance (@ClubID VARCHAR(10) = NULL, @ClubName VARCHAR(50) = NULL, @DMLType CHAR(1) = NULL)
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
		IF NOT EXISTS (SELECT * FROM Club WHERE ClubID = @ClubID)
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

--5.	 Create a stored procedure called ‘RegisterStudent’ that accepts StudentID and OfferingCode as parameters. If the number of students in that Offering are not greater than the Max Students for that course, add a record to the Registration table and add the cost of the course to the student's balance. If the registration would cause the Offering to have greater than the MaxStudents,  raise an error. 

-- check params
-- get @MaxStudents
-- get @StudentCount
-- get @CourseCost
-- if @StudentCount is not greater than @MaxStudents
	-- INSERT
		-- check if failed
	-- UPDATE
		-- check if failed
-- otherwise: RAISERROR


--6.	Create a procedure called ‘StudentPayment’ that accepts Student ID, paymentamount, and paymentTypeID as parameters. Add the payment to the payment table and adjust the students balance owing to reflect the payment. 

-- check params. if null, error.
-- otherwise: INSERT
	-- check if failed
-- if it didn't fail: UPDATE
	-- check if failed

--7.	Create a stored procedure called ‘FireStaff’ that will accept a StaffID as a parameter. Fire the staff member by updating the record for that staff and entering todays date as the DateReleased. 

-- check params
-- see if record exists. if not, raiserror
-- otherwise, UPDATE
-- check if UPDATE worked


--8.	Create a stored procedure called ‘WithdrawStudent’ that accepts a StudentID, and OfferingCode as parameters. Withdraw the student by updating their Withdrawn value to ‘Y’ and subtract ½ of the cost of the course from their balance. If the result would be a negative balance set it to 0.

-- check params. if null, error.
-- otherwise:
	-- check there are records to update
	-- UPDATE
	-- check if that failed
	-- UPDATE**
	-- check if that one failed
	-- ** add logic to make sure the balance isn't negative
