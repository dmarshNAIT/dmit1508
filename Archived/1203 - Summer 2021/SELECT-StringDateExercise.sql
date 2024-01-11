--String and Date Functions Exercise
USE IQSchool


--1. Select the staff full names and the name of the month they were hired
SELECT FirstName + ' ' + LastName AS FullName
	, DATENAME(mm, DateHired) AS MonthHired
FROM Staff

--2. How many days did Tess Agonor work for the school?
SELECT FirstName + ' ' + LastName AS FullName
	, DATEDIFF(dd, DateHired, DateReleased) AS NumberOfDays
FROM Staff
WHERE FirstName = 'Tess' AND LastName = 'Agonor'

SELECT DATEDIFF(dy, DateHired, DateReleased) AS NumberOfDays
FROM Staff
WHERE FirstName = 'Tess' AND LastName = 'Agonor'

--3. How Many Students were born in each month? Display the Month Name and the Number of Students.
SELECT DATENAME(mm, Birthdate)	AS BirthMonth
	, COUNT(*)					AS NumberOfStudents
FROM Student
GROUP BY DATENAME(mm, Birthdate)
-- challenge: how to sort these chronologically?

--4. Select the Names of all the students born in December.
SELECT FirstName + ' ' + LastName AS FullName
FROM Student
WHERE DATENAME(mm, Birthdate) = 'December'

-- bonus content:
SET LANGUAGE us_english

--5. select the last three characters of all the courses
SELECT RIGHT(CourseName, 3) AS Last3Chars
FROM Course

--6. Select the characters in the position description from characters 8 to 13 for PositionID 5
SELECT Substring(PositionDescription, 8, 6) AS Substring
FROM Position
WHERE PositionID = 5

--7. Select all the Student First Names as upper case.
SELECT UPPER(FirstName) AS YellingNames
FROM Student

--8. Select the Last Names of students whose last names are 5 characters long.
SELECT LastName
FROM Student
WHERE LEN(LastName) = 5

