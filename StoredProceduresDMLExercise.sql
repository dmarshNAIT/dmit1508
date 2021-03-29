--Stored Procedures – DML exercise
--For this exercise you will need a local copy of the IQSchool database. 
USE IQSchool
GO

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

--3.	Create a stored procedure called ‘Updateclub’ to update a club record. Do not update the primary key!

--4.	Create a stored procedure called ‘ClubMaintenance’. It will accept parameters for both ClubID and ClubName as well as a parameter to indicate if it is an insert, update or delete. This parameter will be ‘I’, ‘U’ or ‘D’.  insert, update, or delete a record accordingly. Focus on making your code as efficient and maintainable as possible.

--5.	 Create a stored procedure called ‘RegisterStudent’ that accepts StudentID and OfferingCode as parameters. If the number of students in that Offering are not greater than the Max Students for that course, add a record to the Registration table and add the cost of the course to the students balance. If the registration would cause the Offering to have greater than the MaxStudents   raise an error. 

--6.	Create a procedure called ‘StudentPayment’ that accepts Student ID, paymentamount, and paymentTypeID as parameters. Add the payment to the payment table and adjust the students balance owing to reflect the payment. 

--7.	Create a stored procedure caller ‘FireStaff’ that will accept a StaffID as a parameter. Fire the staff member by updating the record for that staff and entering today's date as the DateReleased. 

--8.	Create a stored procedure called ‘WithdrawStudent’ that accepts a StudentID, and OfferingCode as parameters. Withdraw the student by updating their Withdrawn value to ‘Y’ and subtract ½ of the cost of the course from their balance. If the result would be a negative balance set it to 0.




-- CHECKLIST:

-- check params aren't missing
-- check DML didn't fail
-- check how many records were updated/deleted