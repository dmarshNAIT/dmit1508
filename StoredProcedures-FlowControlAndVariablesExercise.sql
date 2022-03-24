--SQL Flow Control and Variables(including exists)Exercise
--Use IQ School tables
USE IQSchool
GO


-- 1. Create a stored procedure called StudentClubCount. It will accept a clubID as a parameter. If the count of students in that club is greater than 2 print ‘A successful club!’ . If the count is not greater than 2 print ‘Needs more members!’.

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

GO
--2. Create a stored procedure called BalanceOrNoBalance. It will accept a studentID as a parameter. Each course has a cost. If the total of the costs for the courses the student is registered in is more than the total of the payments that student has made then print ‘balance owing !’ otherwise print ‘Paid in full! Welcome to School 158!’
--Do Not use the BalanceOwing field in your solution. 

CREATE PROCEDURE BalanceOrNoBalance (@StudentID INT = NULL) AS

IF @StudentID IS NULL
	BEGIN
		PRINT 'Missing parameter'
	END
ELSE -- parameter was provided:
	BEGIN

	-- create variables for TotalCourseCost, TotalPayments
	DECLARE @TotalCourseCost DECIMAL(8,2)
		, @TotalPayments DECIMAL(8,2)

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
	END
RETURN
GO

	-- this doesn't account for NULL values in either table
	-- we could add something like:
	-- IF @TotalCourseCost IS NULL OR @TotalPayments IS NULL

EXEC BalanceOrNoBalance 199899200 -- 199899200 has more payments than costs: paid in full

-- create test data to test the other branch

GO

--3. Create a stored procedure called ‘DoubleOrNothin’. It will accept a students first name and last name as parameters. If the student name already is in the table then print ‘We already have a student with the name firstname lastname!’ Other wise print ‘Welcome firstname lastname!’

CREATE PROCEDURE DoubleOrNothin (@FirstName VARCHAR(25) = NULL
							, @LastName VARCHAR(35) = NULL) AS --- beginning of my SP
IF @FirstName IS NULL OR @LastName IS NULL
	BEGIN
	RAISERROR('Missing required parameter(s)', 16, 1)
	END

ELSE -- all parameters have been provided
	BEGIN
		-- check if that student EXISTS already, and print the appropriate message
		IF EXISTS (
			SELECT * FROM Student WHERE FirstName = @FirstName AND LastName = @LastName
		)
			BEGIN
				PRINT 'Sorry, we already have a student with that name.'
			END

		ELSE -- if the student does NOT exist
			BEGIN
				PRINT 'Welcome to our school, ' + @FirstName + ' ' + @LastName + '!'
			END
	END
RETURN -- end of the procedure

EXEC DoubleOrNothin 'sdfsdfsdfsdf', 'Woo' -- execute the stored procedure called "WelcomeStudent"

GO
--4. Create a procedure called ‘StaffRewards’. It will accept a staff ID as a parameter.  If the number of classes the staff member has ever taught is between 0 and 2 print ‘Well done!’, if it is between 3 and 5 print ‘Exceptional effort!’, if the number is greater than 5 print ‘Totally Awesome Dude!’

CREATE PROCEDURE StaffRewards (@StaffID INT = NULL) 
AS

IF @StaffID IS NULL
	BEGIN
		PRINT 'Missing parameter'
	END
ELSE -- parameter was provided
	BEGIN

	-- create variable(s)
	DECLARE @NumberOfCourses SMALLINT

	-- how many courses has that staff member taught?
	SELECT @NumberOfCourses = COUNT(*) FROM Offering WHERE StaffID = @StaffID 

	-- check if the # is between 0 and 2.
	IF @NumberOfCourses BETWEEN 0 AND 2
		BEGIN
			PRINT 'Well done'
		END
	ELSE -- it's not between 0 and 2
		IF @NumberOfCourses BETWEEN 3 AND 5
			BEGIN
				PRINT 'Exceptional effort!'
			END
		ELSE -- it's not between 3 & 5
			BEGIN
				PRINT 'Totally awesome, dude.'
			END		
	END
RETURN
GO


EXEC StaffRewards 7
	-- staff 6 has taught 3 courses -- exceptional effort 
	-- staff 5 has taught 6 courses -- totally awesome
	-- staff 7 has taught 0 courses -- well done






