--SQL Flow Control and Variables Exercise
--Use IQSchool database
USE IQSchool
GO

--1.	Create a stored procedure called StudentClubCount. It will accept a clubID as a parameter. If the count of students in that club is greater than 2 print ‘A successful club!’. If the count is not greater than 2 print ‘Needs more members!’.

-- create a variable called @ClubID
DECLARE @ClubID VARCHAR(10)

-- assign it a literal value (any ClubID is fine)
SET @ClubID = 'Chess'

-- (optional) create another variable called @StudentCount & assign it a value from the data in the DB
DECLARE @StudentCount INT
SELECT @StudentCount = COUNT(*)
	FROM Activity
	WHERE ClubID = @ClubID

-- If the count of students in that club is greater than 2 print ‘A successful club!’. If the count is not greater than 2 print ‘Needs more members!’.
IF @StudentCount > 2
	BEGIN
	PRINT 'A successful club!'
	END
ELSE
	BEGIN
	PRINT 'Needs more members'
	END
-- testing for ACM (3 members): successful club! Test has passed.
-- testing for CHESS (1 lonely member): needs more members. Test has passed.



--2.	Create a stored procedure called BalanceOrNoBalance. It will accept a studentID as a parameter. Each course has a cost. If the total of the costs for the courses the student is registered in is more than the total of the payments that student has made, then print ‘balance owing!’ otherwise print ‘Paid in full! Welcome to IQ School!’
--Do Not use the BalanceOwing field in your solution. 

-- create a variable called @StudentID and assign it any literal value
-- create a variable called @TotalCourseCost
-- create a variable called @TotalPayments
-- assign each variable a value using data from our DB
-- If the total of the costs for the courses the student is registered in is more than the total of the payments that student has made, then print ‘balance owing!’ otherwise print ‘Paid in full! Welcome to IQ School!’



--3.	Create a stored procedure called ‘DoubleOrNothin’. It will accept a student’s first name and last name as parameters. If the student’s name already is in the table, then print ‘We already have a student with the name firstname lastname!’ Otherwise print ‘Welcome firstname lastname!’

-- create variables called @FirstName and @LastName
-- assign each variable a literal value
-- If the student’s name already is in the table, then print ‘We already have a student with the name firstname lastname!’ Otherwise print ‘Welcome firstname lastname!’



--4.	Create a procedure called ‘StaffRewards’. It will accept a staff ID as a parameter. If the number of classes the staff member has ever taught is between 0 and 10 print ‘Well done!’, if it is between 11 and 20 print ‘Exceptional effort!’, if the number is greater than 20 print ‘Totally Awesome Dude!’

-- create a variable called @StaffID
-- assign it a literal value
-- create a variable called @NumberOfCourses and assign it a value using data in our DB
-- if that value is 2 or less: print 'Well done'
-- if it's between 3 and 5: print 'Exceptional Effort
-- if it's more than 5: print 'Totally Awesome, Dude.

