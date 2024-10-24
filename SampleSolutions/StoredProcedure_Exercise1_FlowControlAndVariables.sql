--SQL Flow Control and Variables(including exists)Exercise
--Use School158 tables
USE IQSchool
GO

--Q1: Create a stored procedure called StudentClubCount. It will accept a clubID as a parameter. If the count of students in that club is greater than 2 print ‘A successful club!’ . If the count is not greater than 2 print ‘Needs more members!’.
DROP PROCEDURE IF EXISTS StudentClubCount
GO

CREATE PROCEDURE StudentClubCount ( @ClubID VARCHAR(10) = NULL )
AS
	IF @ClubID IS NULL
		BEGIN
		PRINT 'Missing parameter'
		END
	ELSE -- a parameter WAS provided
		BEGIN
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
	END
RETURN -- the end of the SP

-- testing this SP:
-- CHESS club has 1 member, CSS club has 5
EXEC StudentClubCount 'CSS'
EXEC StudentClubCount 'CHESS'
EXEC StudentClubCount -- testing with no params
EXEC StudentClubCount 'xyz' -- not a real club
-- As a bonus challenge, we could update the SP to check if it's a real club.

GO

--Q2: Create a stored procedure called BalanceOrNoBalance. It will accept a studentID as a parameter. Each course has a cost. If the total of the costs for the courses the student is registered in is more than the total of the payments that student has made then print ‘balance owing !’ otherwise print ‘Paid in full! Welcome to School 158!’
--Do Not use the BalanceOwing field in your solution. 

CREATE PROCEDURE BalanceOrNoBalance ( @StudentID INT = NULL)
AS
	IF @StudentID IS NULL
		BEGIN
		PRINT 'Missing parameter'
		END
	ELSE -- a parameter WAS provided
		BEGIN

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
	END
RETURN

EXEC BalanceOrNoBalance 199899200 -- this tests the 'Balance Owing' branch
-- need to test the "welcome" branch
EXEC BalanceOrNoBalance
GO

--Q3: Create a stored procedure called ‘DoubleOrNothin’. It will accept a students first name and last name as parameters. If the student name already is in the table then print ‘We already have a student with the name firstname lastname!’ Other wise print ‘Welcome firstname lastname!’

CREATE PROCEDURE DoubleOrNothin ( @FirstName VARCHAR(25) = NULL, @LastName VARCHAR(35) = NULL)
AS
	IF @FirstName IS NULL OR @LastName IS NULL
		BEGIN
		PRINT 'Missing parameter'
		END
	ELSE -- a parameter WAS provided
		BEGIN

		-- if there EXISTS a student with that name, print 'we already have a student with the name INSERTNAME'
		IF EXISTS (SELECT * FROM Student WHERE Student.FirstName = @FirstName AND Student.LastName = @LastName )
			BEGIN
				PRINT 'We already have a student with the name ' + @FirstName + ' ' + @LastName
			END
		-- otherwise, print 'welcome INSERTNAME'
		ELSE
			BEGIN
				PRINT 'Welcome, ' + @FirstName + ' ' + @LastName
			END
		END
RETURN
GO

-- test that it works:
EXEC DoubleOrNothin 'Winnie', 'Woo'
EXEC DoubleOrNothin 'sdfklj', 'sdf'

GO

-- Q4: Create a procedure called ‘StaffRewards’. It will accept a staff ID as a parameter. If the number of classes the staff member has ever taught is between 0 and 10 print ‘Well done!’, if it is between 11 and 20 print ‘Exceptional effort!’, if the number is greater than 20 print ‘Totally Awesome Dude!’


CREATE PROCEDURE StaffRewards (@StaffID SMALLINT = NULL)
AS
	IF @StaffID IS NULL
		BEGIN
		PRINT 'Missing parameter'
		END
	ELSE -- a parameter WAS provided
		BEGIN
		-- create a variable for @NumberOfCourses, give it a value
		DECLARE @NumberOfCourses SMALLINT

		SELECT @NumberOfCourses = COUNT(CourseID) -- or COUNT(*)
		FROM Offering
		WHERE Offering.StaffID = @StaffID

		-- if value is 2 or less, print 'well done!'
		IF @NumberOfCourses <= 2
			BEGIN
				PRINT 'Well done!'
			END
		-- if it's 3-5, print 'exceptional effort!'
		ELSE IF @NumberOfCourses BETWEEN 3 AND 5
			BEGIN
				PRINT 'Exceptional Effort!'
			END
		-- if it's >5, print 'totally awesome, dude'
		ELSE
			BEGIN
				PRINT 'Totally awesome, dude.'
			END
		END
RETURN

EXEC StaffRewards 1
EXEC StaffRewards 6
EXEC StaffRewards 4

-- staff ID 1 has taught 0 courses
-- staff ID 6 has taught 3
-- staff ID 4 has taught >5




