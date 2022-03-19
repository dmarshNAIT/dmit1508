--SQL Flow Control and Variables(including exists)Exercise
--Use IQ School tables
USE IQSchool
GO


-- 1. If the count of students in a club is greater than 2 print ‘A successful club!’ . If the count is not greater than 2 print ‘Needs more members!’.

-- pick a Club to test
-- create a variable called @studentCount
-- check its value, then print the appropriate message

--2. Each course has a cost. If the total of the costs for the courses a given student is registered in is more than the total of the payments that student has made then print ‘balance owing !’ otherwise print ‘Paid in full! Welcome to School 158!’
--Do Not use the BalanceOwing field in your solution. 

-- create a variable to hold a @StudentID
-- create a variable called @TotalCourseCost, and assign it a value for a specific student
-- create a variable called @TotalPayments, and assign it a value for a specific student
-- compare variables, and print the appropriate message

--3. Create variables for student @firstName and student @lastName. If that student name already is in the table then print ‘We already have a student with the name firstname lastname!’ Otherwise print ‘Welcome firstname lastname!’

CREATE PROCEDURE WelcomeStudent AS --- beginning of my SP

-- create variables for the first and last name
DECLARE @FirstName VARCHAR(25)
	, @LastName VARCHAR(35)

-- assign values to each
SELECT @FirstName = 'Winnie'
	, @LastName = 'Woo'

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

RETURN -- end of the procedure

EXEC WelcomeStudent 

--4. Create a variable to hold a @staffID. If the number of classes the staff member has ever taught is between 0 and 2 print ‘Well done!’, if it is between 3 and 5 print ‘Exceptional effort!’, if the number is greater than 5 print ‘Totally Awesome Dude!’

-- create variable(s)
DECLARE @StaffID SMALLINT
	, @NumberOfCourses SMALLINT

-- assign values to the variables
SET @StaffID = 7
-- staff 6 has taught 3 courses -- exceptional effort 
-- staff 5 has taught 6 courses -- totally awesome
-- staff 7 has taught 0 courses -- well done

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








