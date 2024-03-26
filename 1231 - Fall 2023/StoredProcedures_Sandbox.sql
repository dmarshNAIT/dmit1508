USE IQSchool
GO

--------- Nov 1: variables -------
-- declaring & assigning a single variable
DECLARE @FaveCandy VARCHAR(40) -- this creates the variable

SET @FaveCandy = 'Starburst & chocolate' -- this assigns a value to that variable

-- declaring & assigning multiple variables
DECLARE @FaveDessert VARCHAR(40)
	, @FaveBeverage VARCHAR(40)
	, @FaveNumber INT

SELECT @FaveDessert = 'ice cream'
	, @FaveBeverage = 'water'
	, @FaveNumber = 5

-- using a variable
SELECT @FaveBeverage

-- declaring & assigning from a SELECT statement
DECLARE @FaveClass CHAR(8)

SELECT @FaveClass = CourseID 
FROM Course
WHERE CourseName = 'Database Fundamentals'

-- using a variable
SELECT * FROM Course WHERE CourseID = @FaveClass

-- testing and debugging hack:
PRINT @FaveClass

--------- Nov 2: practicing IF statements -------
-- create a variable called @AvgMark
DECLARE @AvgMark DECIMAL(5,2)

-- assign it a value by calculating the average mark for a particular student
SELECT @AvgMark = AVG(Mark)
	FROM Registration
	WHERE StudentID = 199899200
	-- 199899200 has an average mark of 73.67

-- if that student has an avg mark above 80, congrats!
-- otherwise, we do nothing.
IF @AvgMark > 80
	BEGIN
	PRINT 'Congratulations!'
	END
ELSE IF @AvgMark < 50
	BEGIN
	PRINT 'Maybe book an office hour.'
	END
ELSE 
	BEGIN
	PRINT 'Good job.'
	END