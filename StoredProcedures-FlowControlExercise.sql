--SQL Flow Control and Variables(including exists)Exercise
--Use IQSchool tables
USE IQSchool

--1.	Create a variable called clubID. 
-- If the count of students in that club is greater than 2 print ‘A successful club!’ . If the count is not greater than 2 print ‘Needs more members!’.

-- declare variable called ClubID
DECLARE @ClubID VARCHAR(10)
	, @StudentCount INT -- to hold the # of students

-- assign a TEST value for ClubID
SET @ClubID = 'ACM'
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
-- assign values to variables
-- check IF the student EXISTS in the Student table
	-- if so, print a message
-- otherwise, print the other message.


--4.	Create a variable called StaffID. If the number of classes the staff member has ever taught is between 0 and 2 print ‘Well done!’, if it is between 3 and 5 print ‘Exceptional effort!’, if the number is greater than 5 print ‘Totally Awesome Dude!’


-- create variables for StaffID and NumberOfClasses

-- assign those a value
	-- Number of Classes is COUNT of records per Staff

IF @NumberOfClasses BETWEEN 0 AND 2
	BEGIN
	-- something
	END
ELSE
	BEGIN
	IF @NumberOfClasses BETWEEN 3 AND 5
		BEGIN
		-- do something
		END
	ELSE
		BEGIN
		-- do something else
		END -- ends the inner ELSE
	END -- ends the outer ELSE




