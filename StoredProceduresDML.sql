--Stored Procedures – DML exercise
--Author: Dana Marsh
--For this exercise you will need a local copy of the IQSchool database. 
USE [IQ-School]
GO


--1.	Create a stored procedure called ‘AddClub’ to add a new club record.

-- parameters: clubID, clubname
-- check if params are null. if so, RAISERROR
-- otherwise: INSERT
-- check if the INSERT failed. if so, RAISERROR


--2.	Create a stored procedure called ‘DeleteClub’ to delete a club record.

-- parameter: clubID
-- check if params are null. if so, RAISERROR
-- otherwise: check if there are any records to delete. if so: DELETE
-- check if DELETE failed. if so, RAISERROR

--3.	Create a stored procedure called ‘Updateclub’ to update a club record. Do not update the primary key!

-- parameter: clubID, clubname
-- check if params are null. if so, RAISERROR
-- otherwise: UPDATE
-- check if UPDATE failed. if so, RAISERROR
-- check @@rowcount and RAISERROR if no rows were updated

--4.	Create a stored procedure called ‘ClubMaintenance’. It will accept parameters for both ClubID and ClubName as well as a parameter to indicate if it is an insert, update or delete. This parameter will be ‘I’, ‘U’ or ‘D’.  insert, update, or delete a record accordingly. Focus on making your code as efficient and maintainable as possible.

-- parameter: clubID, clubname, DMLType
-- check if params are null. if so, RAISERROR
-- if I:
	-- INSERT
-- otherwise, (U or D)
	-- check if records to update. if not, RAISERROR
	-- if so, check if U. UPDATE.
	-- check if D: DELETE
-- check if failed

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
