-- Author: Dana Marsh
-- String and Date Functions Exercise
--1. Select the staff names and the name of the month they were hired
SELECT FirstName, DATENAME(MONTH, DateHired) AS MonthHired
FROM Staff

SELECT FirstName, DATENAME(mm, DateHired) AS MonthHired
FROM Staff

--2. How many days did Tess Agonor work for the school?
SELECT FirstName
	, LastName
	, DATEDIFF(dd, DateHired, DateReleased) AS DaysWorking
FROM Staff
WHERE FirstName = 'Tess' AND LastName = 'Agonor'

--3. How Many Students where born in each month? Display the Month Name and the Number of Students. Bonus: Sort by month #
SELECT DATENAME(MONTH, Birthdate) As MonthBorn
	, COUNT(*) AS NumStudents
FROM Student
GROUP BY DATENAME(MONTH, Birthdate), DATEPART(mm, Birthdate)
ORDER BY DATEPART(mm, Birthdate)

--4. Select the Names of all the students born in December.
SELECT FirstName + ' ' +  LastName AS StudentName
FROM Student
WHERE DATENAME(MONTH, Birthdate) = 'December'

--5. select last three characters of all the courses
SELECT RIGHT(CourseID, 3) AS Last3Chars
FROM Course

--6. Select the characters in the position description from characters 8 to 13 for PositionID 5
SELECT SUBSTRING(PositionDescription, 8, 6) AS PartOfDescription
FROM Position
WHERE PositionID = 5

--7. Select all the Student First Names as upper case.
SELECT UPPER(FirstName) AS FirstName
FROM Student

--8. Select the First Names of students whose first names are 3 characters long.
SELECT FirstName
FROM Student
WHERE FirstName LIKE '___'

SELECT FirstName
FROM Student
WHERE LEN(FirstName) = 3