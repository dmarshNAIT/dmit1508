-- tell SQL which db to run this script in
USE IQSchool
GO

-- view the name & city of each student
SELECT FirstName, LastName, City
FROM Student

-- view the course names & their cost
SELECT CourseName, CourseCost
FROM Course

-- we can combine fields together!
SELECT FirstName + LastName
	, FirstName + ' ' + LastName AS FullName
	, FullName = FirstName + ' ' + LastName
FROM Student

-- a dangerous but useful shortcut to see ALL the columns
SELECT *
FROM Student
-- we will never use this in a final query, but it's great to quickly see the contents of a table, or to use as a starting point

-- view just the students in Edmonton
SELECT FirstName, LastName, City
FROM Student
WHERE City = 'Edmonton'

-- view just the students in Edmonton & Calgary
SELECT FirstName, LastName, City
FROM Student
WHERE City = 'Edmonton'
	OR City = 'Calgary'
-- OR
SELECT FirstName, LastName, City
FROM Student
WHERE City IN ('Edmonton',  'Calgary')

-- all students EXCEPT students in Edmonton
SELECT FirstName, LastName, City
FROM Student
WHERE City != 'Edmonton'
-- or 
SELECT FirstName, LastName, City
FROM Student
WHERE City <> 'Edmonton'

-- all students whose name starts with D
SELECT FirstName, LastName, City
FROM Student
WHERE FirstName LIKE 'D%'
