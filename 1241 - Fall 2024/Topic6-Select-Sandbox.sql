-- October 10: Intro to SELECT

-- tell SSMS which db to use
USE IQSchool
GO

-- I want a list of student names & cities
SELECT FirstName, LastName, City 
FROM Student

SELECT FirstName + ' ' + LastName AS FullName		-- v1
	, FullName = FirstName + ' ' + LastName			-- v2
	, City
FROM Student

-- we can do calculations in a SELECT statement, too:
SELECT Amount
	, Amount * 0.05 AS GST
FROM Payment

-- what if I want all the columns in the Student table?
SELECT * 
FROM Student
-- very dangerous, very risky

-- what if we want to filter records?
SELECT FirstName, LastName, City 
FROM Student
WHERE City = 'Edmonton'

-- I want to see all the students whose lastname starts with K
SELECT FirstName, LastName, City 
FROM Student
WHERE LastName LIKE 'K%'

-- I want to see students in Edmonton OR Calgary
SELECT FirstName, LastName, City 
FROM Student
WHERE City = 'Edmonton' OR City = 'Calgary'

-- or:
SELECT FirstName, LastName, City 
FROM Student
WHERE City IN ('Edmonton', 'Calgary')