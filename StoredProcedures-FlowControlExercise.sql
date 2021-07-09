--SQL Flow Control and Variables(including exists)Exercise
--Use IQSchool tables
USE IQSchool
GO

--1.	Create a variable called clubID. 
-- If the count of students in that club is greater than 2 print ‘A successful club!’ . If the count is not greater than 2 print ‘Needs more members!’.

CREATE PROCEDURE StudentClubCount (@ClubID VARCHAR(10) = NULL)
AS

-- check if parameters were provided
IF @ClubID IS NULL
	BEGIN
	PRINT 'Missing parameter!'
	END
ELSE -- if it's not null / the parameter IS provided:
	BEGIN

	DECLARE @StudentCount INT -- to hold the # of students

	-- assign a TEST value for ClubID
	-- 1 student in CHESS
	-- 3 students in ACM

	-- get the count of students from that club
	SELECT @StudentCount = COUNT(*)
					FROM Activity
					WHERE Activity.ClubId = @ClubID

	-- if count > 2 print 'A successful club!'
	IF @StudentCount > 2
		BEGIN
		PRINT 'A successful club!'
		END
	-- otherwise, print 'needs more members'
	ELSE
		BEGIN
		PRINT 'Needs more members'
		END
	END -- ends the param-check ELSE block

RETURN -- this marks the END of the procedure
GO -- this marks the end of the batch

-- to run this sp:
EXEC StudentClubCount -- running with NO parameters to make sure that check works
EXEC StudentClubCount 'ACM'
EXEC StudentClubCount 'CHESS'
-- to see the definition of this sp:
EXEC sp_helptext StudentClubCount

--2.	Create a variable called studentID. 
-- Each course has a cost. If the total of the costs for the courses the student is registered in is more than the total of the payments that student has made then print ‘balance owing !’ otherwise print ‘Paid in full! Welcome to School 158!’
--Do Not use the BalanceOwing field in your solution. 

-- create variables for StudentID, TotalCourseCost, TotalPayments
DECLARE @StudentID INT
	, @TotalCourseCost DECIMAL(8,2)
	, @TotalPayments DECIMAL(8,2)

-- assign values to each
SET @StudentID = 199899200 -- 199899200 has more payments than costs: paid in full

SELECT @TotalCourseCost = SUM(CourseCost)
FROM Course
INNER JOIN Offering ON Course.CourseId = Offering.CourseID
INNER JOIN Registration ON Offering.OfferingCode = Registration.OfferingCode
WHERE Registration.StudentID = @StudentID

SELECT @TotalPayments = SUM(Amount)
FROM Payment
WHERE Payment.StudentID = @StudentID

-- compare the values and print out the appropriate message
IF @TotalCourseCost > @TotalPayments
	BEGIN
	PRINT 'Balance owing!'
	END
ELSE
	BEGIN
	PRINT 'Paid in full: Welcome!'
	END

	-- this doesn't account for NULL values in either table
	-- we could add something like:
	-- IF @TotalCourseCost IS NULL OR @TotalPayments IS NULL

-- create test data to test the other branch


--3.	Create variables called FirstName and LastName. If the student name already is in the table then print ‘We already have a student with the name firstname lastname!’ Other wise print ‘Welcome firstname lastname!’

-- create variables called FirstName and LastName
DECLARE @FirstName VARCHAR(25)
	, @LastName VARCHAR(35)

-- assign values to variables
--SELECT @FirstName = 'Winnie', @LastName = 'Woo'
SELECT @FirstName = 'sdds', @LastName = 'sdfdsfsd'
-- Winnie Woo DOES exist

-- check IF the student EXISTS in the Student table
IF EXISTS (SELECT * FROM Student WHERE FirstName = @FirstName AND LastName = @LastName)
	-- if so, print a message
	BEGIN
	PRINT 'Sorry, already have a student with that name. Enrol elsewhere.'
	END
-- otherwise, print the other message.
ELSE
	BEGIN
	PRINT 'Welcome to our school, ' + @FirstName + ' ' + @LastName + '!'
	END


--4.	Create a variable called StaffID. If the number of classes the staff member has ever taught is between 0 and 2 print ‘Well done!’, if it is between 3 and 5 print ‘Exceptional effort!’, if the number is greater than 5 print ‘Totally Awesome Dude!’


-- create variables for StaffID and NumberOfClasses
DECLARE @StaffID SMALLINT
	, @NumberOfClasses SMALLINT

-- assign those a value
SET @StaffID = 6 -- test data goes here
-- Staff #1 has taught 0 classes: 'well done'
-- Staff #6 has taught 3 classes: 'exceptional effort'
-- Staff #4 has taught more than 5 classes: totally awesome, dude

SELECT @NumberOfClasses = COUNT(CourseID)
FROM Staff
LEFT JOIN Offering ON Staff.StaffID = Offering.StaffID
WHERE Staff.StaffID = @StaffID
-- Number of Classes is COUNT of records per Staff

IF @NumberOfClasses BETWEEN 0 AND 2
	BEGIN
	PRINT 'Well done!'
	END
ELSE
	BEGIN
	IF @NumberOfClasses BETWEEN 3 AND 5
		BEGIN
		PRINT 'Exceptional effort!'
		END
	ELSE
		BEGIN
		PRINT 'Totally awesome, dude!'
		END -- ends the inner ELSE
	END -- ends the outer ELSE

	SELECT * FROM Offering ORDER BY StaffID


