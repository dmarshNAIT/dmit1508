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
SELECT * FROM Student
-- very dangerous, very risky