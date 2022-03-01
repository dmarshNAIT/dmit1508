--String and Date Functions Exercise
USE IQSchool
GO
--1. Select the staff names and the name of the month they were hired
SELECT FirstName + ' ' + LastName AS FullName
	, DATENAME(mm, DateHired) AS MonthHired
FROM Staff

--2. How many days did Tess Agonor work for the school?
SELECT DATEDIFF(dy, DateHired, DateReleased) AS NumberOfDays
FROM Staff
WHERE FirstName = 'Tess' AND LastName = 'Agonor'

--3. How Many Students where born in each month? Display the Month Name and the Number of Students.
SELECT DATENAME(mm, Birthdate)	AS BirthMonth
	, COUNT(*)					AS NumberOfStudents
FROM Student
GROUP BY DATENAME(mm, Birthdate)
-- challenge: how to sort these chronologically?

--4. Select the Names of all the students born in December.
SELECT FirstName + ' ' + LastName AS StudentName
FROM Student
WHERE DATENAME(mm, Birthdate) = 'December'

-- OR:
SELECT FirstName + ' ' + LastName AS StudentName
FROM Student
WHERE Birthdate LIKE '%DEC%'

-- or a similar solution:
SELECT FirstName + ' ' + LastName AS StudentName
FROM Student
WHERE DATEPART(mm, Birthdate) = 12

--5. select last three characters of all the courses
SELECT RIGHT(CourseName, 3) AS Last3Chars
FROM Course

--6. Select the characters in the position description from characters 8 to 13 for PositionID 5
SELECT SUBSTRING(PositionDescription, 8, 6) AS Substring
FROM Position
WHERE PositionID = 5

--7. Select all the Student First Names as upper case.
SELECT UPPER(FirstName) AS YellingNames
FROM Student

--8. Select the First Names of students whose first names are 3 characters long.
SELECT FirstName
FROM Student
WHERE FirstName LIKE '___'

-- or
SELECT FirstName
FROM Student
WHERE LEN(FirstName) = 3
