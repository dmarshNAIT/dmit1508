--Stored Procedures – DML exercise
--For this exercise you will need a local copy of the IQSchool database. 
--1.	Create a stored procedure called ‘AddClub’ to add a new club record.
-- params: @ClubID, @ClubName

--2.	Create a stored procedure called ‘DeleteClub’ to delete a club record.
-- param: @ClubID

--3.	Create a stored procedure called ‘Updateclub’ to update a club record. Do not update the primary key!
-- params: @ClubID, @NewClubName
-- update the ClubName to @NewClubName for the ClubID that matches the @ClubID param

--4.	Create a stored procedure called ‘ClubMaintenance’. It will accept parameters for both ClubID and ClubName as well as a parameter to indicate if it is an insert, update or delete. This parameter will be ‘I’, ‘U’ or ‘D’.  insert, update, or delete a record accordingly. Focus on making your code as efficient and maintainable as possible.

-- params: @ClubID, @ClubName, @DMLType

--5.	 Create a stored procedure called ‘RegisterStudent’ that accepts StudentID and OfferingCode as parameters. If the number of students in that Offering are not greater than the Max Students for that course, add a record to the Registration table and add the cost of the course to the students balance. If the registration would cause the Offering to have greater than the MaxStudents   raise an error. 

-- variables: @NumberStudents, @MaxStudents, @CourseCost

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

