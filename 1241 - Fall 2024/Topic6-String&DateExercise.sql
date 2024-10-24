--String and Date Functions Exercise
USE IQSchool
GO

--1. Select the staff names and the name of the month they were hired
SELECT FirstName + ' ' + LastName AS FullName
	, DATENAME(mm, DateHired) AS MonthHired
FROM Staff

--2. How many days did Tess Agonor work for the school?
SELECT DATEDIFF(dd, DateHired, DateReleased) AS DaysWorked
FROM Staff
WHERE FirstName = 'Tess' AND LastName = 'Agonor'

--3. How many students were born in each month? Display the month name and the number of students.
SELECT DateName(mm, Birthdate) AS BirthMonth
	, COUNT(*) AS NumStudents
	, COUNT(StudentID) AS NumStudentsV2
FROM Student
GROUP BY DateName(mm, Birthdate)
-- bonus challenge: put the months in order
	, DatePart(mm, Birthdate)
ORDER BY DatePart(mm, Birthdate)

--4. Select the names of all the students born in December.
SELECT FirstName + ' ' + LastName AS FullName
FROM Student
WHERE DateName(mm, Birthdate) = 'December'

--5. select last three characters of all the CourseIDs
SELECT RIGHT(CourseID, 3) AS Last3Characters
FROM Course

--6. Select the characters in the position description from characters 8 to 13 for PositionID 5
SELECT SUBSTRING(PositionDescription, 8, 6) AS SillyString
FROM Position
WHERE PositionID = 5

--7. Select all the student first names as upper case.
SELECT UPPER(FirstName) AS UppercaseFirstName
FROM Student

--8. Select the first names of students whose first names are 3 characters long.
SELECT FirstName
FROM Student
WHERE LEN(FirstName) = 3

SELECT FirstName
FROM Student
WHERE FirstName LIKE '___'