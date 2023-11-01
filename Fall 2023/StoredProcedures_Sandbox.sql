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
