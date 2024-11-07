--SQL Flow Control and Variables Exercise
--Use IQSchool database
USE IQSchool
GO

SELECT * FROM Club
SELECT * FROM Activity
-- CHESS has one member, CSS has lots of members

--1. Declare a variable called @ClubID.
DECLARE @ClubID VARCHAR(10)
-- Assign a value to @ClubID (it can be any club)
SET @ClubID = 'CSS'
-- create another variable called @StudentCount, and give it a value.
DECLARE @StudentCount INT

SELECT @StudentCount = COUNT(StudentID) 
FROM Activity 
WHERE Activity.ClubId = @ClubID
-- If the count of students in that club is greater than 2 print ‘A successful club!’. If the count is not greater than 2 print ‘Needs more members!’.
IF @StudentCount > 2
	BEGIN
	PRINT 'A successful club!'
	END
ELSE -- otherwise, if it's NOT greater than 2
	BEGIN
	PRINT 'Needs more members!'
	END


--2. Declare a variable named @StudentID, and give it any valid student ID as a value.
DECLARE @StudentID INT
SET @StudentID = 199899200 -- Ivy Kent

-- Declare a variable named @CourseCosts, and assign it the appropriate value.
DECLARE @CourseCosts DECIMAL(8,2)

SELECT @CourseCosts = SUM(CourseCost)
FROM Course
INNER JOIN Offering ON Course.CourseId = Offering.CourseId
INNER JOIN Registration ON Offering.OfferingCode = Registration.OfferingCode
WHERE StudentID = @StudentID

-- Declare a variable named @StudentPayments, and assign it the appropriate value.
DECLARE @StudentPayments MONEY

SELECT @StudentPayments = SUM(Amount) 
FROM Payment 
WHERE StudentID = @StudentID

-- Each course has a cost. If the total of the costs for the courses the
--student is registered in is more than the total of the payments that student has
--made, then print ‘balance owing!’ otherwise print ‘Paid in full! Welcome to IQ
--School!’
IF @CourseCosts > @StudentPayments
	BEGIN
	PRINT 'Balance Owing!'
	END
ELSE 
	BEGIN
	PRINT 'Paid in full! Welcome to IQ School!'
	END
--Do Not use the BalanceOwing field in your solution.


--3. Declare variables for first and last name, and assign them any values.
-- If the student’s name already is in the table,
--then print ‘We already have a student with the name firstname lastname!’
--Otherwise print ‘Welcome firstname lastname!’


--4. Declare a variable called @StaffID and give it a valid staff ID value.
DECLARE @StaffID SMALLINT

SET @StaffID = 4

-- Declare a variable that holds the # of classes that staff member has taught.
DECLARE @ClassCount INT

SELECT @ClassCount = COUNT(OfferingCode)
FROM Offering
WHERE StaffID = @StaffID

-- If the number of classes the staff member has ever taught is between 0 and 2 print
--‘Well done!’, if it is between 3 and 5 print ‘Exceptional effort!’, if the number is
--greater than 5 print ‘Totally Awesome Dude!’

IF @ClassCount <= 2
	BEGIN
	PRINT 'Well done!'
	END
ELSE IF @ClassCount <=5
	BEGIN
	PRINT 'Exceptional effort!'
	END
ELSE 
	BEGIN
	PRINT 'Totally awesome, dude!'
	END

-- StaffID 1 has taught 0 courses: should say "Well Done"
-- StaffID 6 has taught 3 courses: should say "Exceptional Effort"
-- StaffID 4 has taught 6 courses: should say "Totally Awesome, Dude!"
