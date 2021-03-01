--String and Date Functions Exercise
USE IQSchool
GO

--1. Select the staff names and the name of the month they were hired
SELECT FirstName + ' ' + LastName AS FullName
	, DATENAME(mm, DateHired) AS HiredMonth
FROM Staff

--2. How many days did Tess Agonor work for the school?
SELECT DATEDIFF(dd, DateHired, DateReleased) AS DaysWorked
FROM Staff
WHERE FirstName = 'Tess' AND LastName = 'Agonor'

--3. How Many Students were born in each month? Display the Month Name and the Number of Students.
SELECT DATENAME(mm, Birthdate) AS BirthMonth
	, COUNT(*) AS NumStudents -- how many rows per month?
	, COUNT(DISTINCT StudentID) AS NumStudents 
		-- how many values in the StudentID column?
FROM Student
GROUP BY DATENAME(mm, Birthdate)
-- bonus: order by month order
	, MONTH(Birthdate)
ORDER BY MONTH(Birthdate)

--4. Select the Names of all the students born in December.
SELECT FirstName + ' ' + LastName AS FullName
FROM Student
WHERE DATENAME(mm, Birthdate) = 'December'

--5. select last three characters of all the courses
SELECT RIGHT(CourseID, 3) AS LastThree
FROM Course

--6. Select the characters in the position description from characters 8 to 13 for PositionID 5
SELECT SUBSTRING(PositionDescription, 8, 6) AS [SubString]
FROM Position
WHERE PositionID = 5

--7. Select all the Student First Names as upper case.
SELECT UPPER(FirstName) AS YellingFirstName
FROM Student

--8. Select the First Names of students whose first names are 3 characters long.
SELECT FirstName
FROM Student
WHERE LEN(FirstName) = 3


-- bonus: SQL is language-dependent:
SET LANGUAGE Italian;  
SELECT DATENAME(month, GetDate()) AS 'Month Name';  
  
SET LANGUAGE us_english;  
SELECT DATENAME(month, GetDate()) AS 'Month Name' ;  