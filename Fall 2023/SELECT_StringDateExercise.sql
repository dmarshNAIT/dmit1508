--String and Date Functions Exercise
USE IQSchool
GO

--1. Select the staff names and the name of the month they were hired
SELECT FirstName + ' ' + LastName AS StaffName
	, DATENAME(mm, DateHired) AS HiredMonth
FROM Staff

--2. How many days did Tess Agonor work for the school?
SELECT DATEDIFF(dd, DateHired, DateReleased) AS 'Number of Days'
FROM Staff
WHERE FirstName = 'Tess' AND LastName = 'Agonor'

--3. How many students were born in each month? Display the month name and the number of students.
SELECT DateName(mm, Birthdate) AS 'Birth Month'
,	COUNT(*) AS 'Number of Students'
FROM Student
GROUP BY DateName(mm, Birthdate)

SELECT DateName(mm, Birthdate) AS 'Birth Month'
,	COUNT(StudentID) AS 'Number of Students'
FROM Student
GROUP BY DateName(mm, Birthdate)

SELECT DateName(mm, Birthdate) AS 'Birth Month'
,	COUNT(DISTINCT StudentID) AS 'Number of Students'
FROM Student
GROUP BY DateName(mm, Birthdate)

--4. Select the names of all the students born in December.

--5. select last three characters of all the CourseIDs

--6. Select the characters in the position description from characters 8 to 13 for PositionID 5
SELECT SUBSTRING(PositionDescription, 8, 6) AS RandomSubstring
FROM Position
WHERE PositionID = 5

--7. Select all the student first names as upper case.

--8. Select the first names of students whose first names are 3 characters long.

