--SQL Flow Control and Variables(including exists)Exercise
--Use School158 tables
USE IQSchool
GO

--Q1: Create a stored procedure called StudentClubCount. It will accept a clubID as a parameter. If the count of students in that club is greater than 2 print ‘A successful club!’ . If the count is not greater than 2 print ‘Needs more members!’.

-- create a variable called @ClubID
DECLARE @ClubID VARCHAR(10)

-- give it a starting value
-- CHESS club has 1 member, CSS club has 5
SET @ClubID = 'CSS'

-- create a variable called @StudentCount 
DECLARE @StudentCount INT

-- assign a value to @StudentCount
SELECT @StudentCount = COUNT(*)
FROM Activity
WHERE Activity.ClubId = @ClubID

-- if @StudentCount is greater than 2, print 'a successful club!'
IF @StudentCount > 2
	BEGIN
		PRINT 'A successful club!'
	END
-- otherwise, print 'needs more members'
ELSE
	BEGIN
		PRINT 'Needs more members'
	END


--Q2: Create a stored procedure called BalanceOrNoBalance. It will accept a studentID as a parameter. Each course has a cost. If the total of the costs for the courses the student is registered in is more than the total of the payments that student has made then print ‘balance owing !’ otherwise print ‘Paid in full! Welcome to School 158!’
--Do Not use the BalanceOwing field in your solution. 

-- create a variable called @StudentID, then assign it a value (any Student)
DECLARE @StudentID INT

SET @StudentID = 199899200 -- arbitrary student from the Registration table

-- create a variable called @TotalCourseCosts, and assign it a value
DECLARE @TotalCourseCosts DECIMAL(8,2)

SELECT @TotalCourseCosts = SUM(CourseCost)
FROM Course
INNER JOIN Offering ON Course.CourseId = Offering.CourseId
INNER JOIN Registration ON Offering.OfferingCode = Registration.OfferingCode
WHERE Registration.StudentID = @StudentID

-- create a variable called @TotalPayments, and assign it a value
DECLARE @TotalPayments MONEY

SELECT @TotalPayments = SUM(Amount)
FROM Payment
WHERE Payment.StudentID = @StudentID

-- if @TotalCourseCosts > @TotalPayments, print 'Balance Owing!'
IF @TotalCourseCosts > @TotalPayments
	BEGIN
		PRINT 'Balance Owing!'
	END
-- otherwise, print 'Paid in full. Welcome!'
ELSE
	BEGIN
		PRINT 'Paid in full. Welcome!'
	END

--Q3: Create a stored procedure called ‘DoubleOrNothin’. It will accept a students first name and last name as parameters. If the student name already is in the table then print ‘We already have a student with the name firstname lastname!’ Other wise print ‘Welcome firstname lastname!’

-- create a variable for @firstname, and @lastname, then assign them values

-- if there EXISTS a student with that name, print 'we already have a student with the name INSERTNAME'

-- otherwise, print 'welcome INSERTNAME'

-- Q4: Create a procedure called ‘StaffRewards’. It will accept a staff ID as a parameter. If the number of classes the staff member has ever taught is between 0 and 10 print ‘Well done!’, if it is between 11 and 20 print ‘Exceptional effort!’, if the number is greater than 20 print ‘Totally Awesome Dude!’

-- create a variable for @StaffID, give it a value

-- create a variable for @NumberOfCourses, give it a value

-- if value is 2 or less, print 'well done!'

-- if it's 3-5, print 'exceptional effort!'

-- if it's >5, print 'totally awesome, dude'







