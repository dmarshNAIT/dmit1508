--SQL Flow Control and Variables(including exists)Exercise
USE IQSchool
GO

--1.	Create a stored procedure called StudentClubCount. 
-- It will accept a clubID as a parameter.
-- If the count of students in that club is greater than 2 print ‘A successful club!’ . If the count is not greater than 2 print ‘Needs more members!’.

CREATE PROCEDURE StudentClubCount
AS

-- create a variable called ClubID:
DECLARE @ClubID VARCHAR(10)
SET @ClubID = 'ACM' -- this is where we put our test data

-- create another variable to hold the count of students in that Club
DECLARE @StudentCount INT

SELECT @StudentCount = COUNT(*) 
		FROM Activity 
		WHERE ClubID = @ClubID

-- if count of students in that Club is > 2: 'Successful Club!'
IF @StudentCount > 2
	BEGIN
	PRINT 'Successful club!'
	END
-- else: print 'Needs more members!'
ELSE
	BEGIN
	PRINT 'Needs more members!'
	END

RETURN -- end of the procedure

-- test: 'ACM' should be successful
-- test: 'CHESS' will need more members







--2.	Create a stored procedure called BalanceOrNoBalance. It will accept a studentID as a parameter. 
-- Each course has a cost. If the total of the costs for the courses the student is registered in is more than the total of the payments that student has made then print ‘balance owing !’ otherwise print ‘Paid in full! Welcome to School 158!’
--Do Not use the BalanceOwing field in your solution. 

-- create a variable called @StudentID to hold the studentID we're testing
DECLARE @StudentID INT
SET @StudentID = 199899200 -- test data go here

-- create a variable called @TotalCost: total of the costs for the courses the student is registered in
DECLARE @TotalCost DECIMAL(8,2)

SELECT @TotalCost = SUM(CourseCost)
FROM Registration AS Reg -- adding an alias (bonus content!)
INNER JOIN Offering ON Reg.OfferingCode = Offering.OfferingCode
INNER JOIN Course ON Offering.CourseID = Course.CourseId
WHERE Reg.StudentID = @StudentID

-- create a variable called @TotalPayments: total of the payments that student has made
DECLARE @TotalPayments DECIMAL(8,2)

SELECT @TotalPayments = SUM(Amount)
FROM Payment
WHERE StudentID = @StudentID

-- if we wanted to be thorough about edge cases, we'd add something like:
-- IF @TotalCost IS NULL OR @TotalPayments IS NULL....

-- if: @TotalCost > @TotalPayments we print 'Balance Owing!'
IF @TotalCost > @TotalPayments
	BEGIN
	PRINT 'Balance owing!'
	END
-- else: 'Paid in full. Welcome!'
ELSE
	BEGIN
	PRINT 'Paid in full. Welcome!'
	END




--3.	Create a stored procedure called ‘DoubleOrNothin’. It will accept a students first name and last name as parameters. 
-- If the student name already is in the table then print ‘We already have a student with the name firstname lastname!’ Other wise print ‘Welcome firstname lastname!’

-- create a variable to hold the FirstName and LastName
DECLARE @FirstName VARCHAR(25)
	, @LastName VARCHAR(35)
SELECT @FirstName = 'Winnie', @LastName = 'Woo' -- test data goes here

-- if records exist in the table for that firstname & lastname: print 'We already have a student with the name firstname lastname'
IF EXISTS (
	SELECT *
	FROM Student
	WHERE FirstName = @FirstName AND LastName = @LastName
)
	BEGIN
	PRINT 'We already have a student with the name ' + @FirstName + ' ' + @LastName
	END

-- else: print 'welcome, firstname lastname.'
ELSE
	BEGIN
	PRINT 'Welcome, ' + @FirstName + ' ' + @LastName
	END

-- test with: 'Winnie Woo' already exists
-- test with your own name





--4.	Create a procedure called ‘StaffRewards’. It will accept a staff ID as a parameter. 
-- If the number of classes the staff member has ever taught is between 0 and 2 print ‘Well done!’, if it is between 3 and 5 print ‘Exceptional effort!’, if the number is greater than 5 print ‘Totally Awesome Dude!’

-- create a variable to hold the StaffID we're interested in
DECLARE @StaffID INT
SET @StaffID = 4 -- test data

-- create a variable called @NumberClassesTaught
DECLARE @NumberClassesTaught INT

-- asssign it a value:
SELECT @NumberClassesTaught = COUNT(*)
FROM Offering
WHERE StaffID = @StaffID

-- IF @NumberClassesTaught <=2: print 'Well done!'
IF @NumberClassesTaught BETWEEN 0 AND 2
	BEGIN
	PRINT 'Well done!'
	END
ELSE 
	BEGIN
-- ELSE
	-- IF @NumberClassesTaught <=5: print 'Exceptional effort!'
	IF @NumberClassesTaught BETWEEN 3 AND 5
		BEGIN
		PRINT 'Exceptional effort!'
		END
	-- ELSE: PRINT 'Totally awesome, dude!"
	ELSE
		BEGIN
		PRINT 'Totally awesome, dude!'
		END -- ends the inner else
	END -- ends the outer else

-- test: staffID 4 should be 'totally awesome'
-- staffID 6 should be 'exceptional'
-- need to create test data to test 'well done' 





