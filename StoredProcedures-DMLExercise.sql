--Stored Procedures – DML exercise
--For this exercise you will need a local copy of the IQSchool database. 
USE IQSchool
GO

--1.	Create a stored procedure called ‘AddClub’ to add a new club record.
-- params: @ClubID, @ClubName

CREATE PROCEDURE AddClub (@ClubID VARCHAR(10) = NULL, @ClubName VARCHAR(50) = NULL)
AS

-- check for missing params
IF @ClubID IS NULL OR @ClubName IS NULL
	BEGIN
	RAISERROR('Missing parameter(s)', 16, 1)
	END
ELSE
	BEGIN
	-- add club record to Club table
	INSERT INTO Club (ClubID, ClubName)
	VALUES (@ClubID, @ClubName)

	-- check if INSERT worked / check @@error
	IF @@ERROR <> 0
		BEGIN
		RAISERROR('Oh no! The INSERT failed!', 16, 1)
		END -- end of the "if error" branch
	END -- end of the "params aren't missing" branch

RETURN -- end of the procedure
GO -- end of the batch


SELECT * FROM Club

-- test with "good" params / test the INSERT worked
EXEC AddClub 'CC', 'Churros Club'

-- test with "bad" params / test the INSERT did NOT work
EXEC AddClub 'CC', 'Churros Consortium' -- duplicate PK

-- test with missing params
EXEC AddClub

GO

--2.	Create a stored procedure called ‘DeleteClub’ to delete a club record.
-- param: @ClubID

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
-- params: @ClubID, @NewClubName
-- update the ClubName to @NewClubName for the ClubID that matches the @ClubID param

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


--4.	Create a stored procedure called ‘ClubMaintenance’. It will accept parameters for both ClubID and ClubName as well as a parameter to indicate if it is an insert, update or delete. This parameter will be ‘I’, ‘U’ or ‘D’.  insert, update, or delete a record accordingly. Focus on making your code as efficient and maintainable as possible.

-- params: @ClubID, @ClubName, @DMLType

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


--5.	 Create a stored procedure called ‘RegisterStudent’ that accepts StudentID and OfferingCode as parameters. If the number of students in that Offering are not greater than the Max Students for that course, add a record to the Registration table and add the cost of the course to the students balance. If the registration would cause the Offering to have greater than the MaxStudents   raise an error. 

-- variables: @NumberStudents, @MaxStudents, @CourseCost

-- check params
-- get @MaxStudents
-- get @NumberStudents
-- get @CourseCost
-- if @NumberStudents is not greater than @MaxStudents
	-- INSERT
		-- check if failed (RAISERROR)
	-- UPDATE
		-- check if failed (RAISERROR)
-- otherwise: RAISERROR

--6.	Create a procedure called ‘StudentPayment’ that accepts Student ID, paymentamount, and paymentTypeID as parameters. Add the payment to the payment table and adjust the students balance owing to reflect the payment. 

-- check params. if null, ERROR
-- otherwise: INSERT into Payment
	-- check if it failed. if so, RAISERROR
	-- otherwise: UPDATE BalanceOwing
		-- check if that failed. if so, RAISERROR

--7.	Create a stored procedure called ‘FireStaff’ that will accept a StaffID as a parameter. Fire the staff member by updating the record for that staff and entering today's date as the DateReleased. 

-- check params. if null, ERROR
-- otherwise: check to see if that staff exists. if not, RAISERROR
	-- otherwise: UPDATE Staff SET DateReleased = ?
	-- check if UPDATE worked. if not, RAISERROR

--8.	Create a stored procedure called ‘WithdrawStudent’ that accepts a StudentID, and OfferingCode as parameters. Withdraw the student by updating their Withdrawn value to ‘Y’ and subtract ½ of the cost of the course from their balance. If the result would be a negative balance set it to 0.

-- check params. if null, error.
-- otherwise:
	-- check there are records to update
	-- UPDATE
		-- check if that failed
		-- UPDATE**
			-- check if that one failed
			-- ** add logic to make sure the balance isn't negative
