USE IQSchool
GO

-- Oct 11
SELECT FirstName
, LastName
, FirstName + ' ' + LastName AS [Full Name]
, FullName = FirstName + ' ' + LastName
FROM Student

SELECT *
FROM Student
-- a handy shortcut, but not something we will have in final version!

-- all students who owe money:
SELECT FirstName, LastName, BalanceOwing
FROM Student
WHERE BalanceOwing > 0

-- all students with an 'a' in their first name
SELECT FirstName + ' '  + LastName AS FullName
FROM Student
WHERE FirstName LIKE '%a%'

-- Oct 12: More WHERE practice
SELECT FirstName, LastName, City
FROM Student
WHERE City = 'Edmonton' OR City = 'Leduc'
-- this is the same as:
SELECT FirstName, LastName, City
FROM Student
WHERE City IN ('Edmonton', 'Leduc')

-- now let's do the opposite
SELECT FirstName, LastName, City
FROM Student
WHERE City != 'Edmonton' AND City != 'Leduc'
-- or
SELECT FirstName, LastName, City
FROM Student
WHERE City NOT IN ('Edmonton', 'Leduc')

-- Aggregations
-- the overall average of all the marks in the Registration table
SELECT AVG(Mark) AS AverageMark
FROM Registration
-- what if we want the average for a particular student?
SELECT AVG(Mark) AS AverageMark
FROM Registration
WHERE StudentID = 200122100

-- what is the total amount of all payments received?
SELECT SUM(Amount) AS TotalPayments
	, MIN(Amount) AS SmallestPayment
	, MAX(Amount) AS LargestPayment
FROM Payment

-- COUNT(*) counts the # of records
-- COUNT(ColumnName) counts the # of non-null values
SELECT COUNT(*) AS NumberOfRows
	, COUNT(DateReleased) AS NumberOfExStaff
FROM Staff

-- using GROUP BY
SELECT	StudentID 
,	AVG(Mark) AS AverageMark
FROM Registration
GROUP BY StudentID -- average mark PER student

SELECT	StudentID 
,	AVG(Mark) AS AverageMark
FROM Registration
GROUP BY StudentID
HAVING Avg(Mark) > 80

-- Oct 18
SELECT ALL FirstName FROM Student -- we see all 17 students
SELECT DISTINCT FirstName FROM Student -- 14 unique names
-- DISTINCT removes duplicate rows from the result

-- combining COUNT with DISTINCT
SELECT COUNT(*) AS '# of students'
,	COUNT(FirstName) AS '# of students with a First Name'
,	COUNT(DISTINCT FirstName) AS '# of unique first names'
FROM Student

SELECT FirstName 
FROM Student
ORDER BY FirstName -- alphabetical order

SELECT FirstName 
FROM Student
ORDER BY FirstName DESC -- reverse ABC

-- string functions:
SELECT PostalCode
, LEN(PostalCode) AS Length
, LEFT(PostalCode, 3) AS 'First 3 characters of Postal Code'
, RIGHT(PostalCode, 3) AS 'Last 3 characters of Postal Code'
, SUBSTRING(PostalCode, 3, 2) AS 'Middle 2 characters'
, REVERSE(FirstName) AS 'Reverse First Name'
, UPPER(FirstName) AS UpperCaseName
, LOWER(FirstName) AS LowerCaseName
, '       ABC    ' AS OriginalString
, LTRIM('       ABC    ') AS LeftTrimmedString
, RTRIM('       ABC    ') AS RightTrimmedString
FROM Student

-- date functions
SELECT GetDate() AS CurrentDateTime

SELECT Birthdate
, DateAdd(yy, 16, Birthdate) AS 'Eligible for Driver License'
, DateDiff(dd, Birthdate, GetDate()) AS 'How many days old'
, DateName(mm, Birthdate) AS 'Birth month'
, DatePart(mm, Birthdate) AS 'Birth month'
, Month(Birthdate) AS 'Birth month'
FROM Student

-------------------- JOINs ------------------------------
-- we have 17 students at the school (because there are 17 rows in the Student table)
SELECT FirstName, LastName, Mark
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
ORDER BY FirstName, LastName

SELECT FirstName, LastName, AVG(Mark) AS AverageMark
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
GROUP BY Student.StudentID, FirstName, LastName
-- we are grouping by StudentID bc FirstName + LastName aren't necessarily unique
-- we don't want to group together both Dave Browns
ORDER BY FirstName, LastName
-- this gives us 8 rows: there are 8 students who are registered

SELECT FirstName, LastName, AVG(Mark) AS AverageMark
FROM Student
LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
GROUP BY Student.StudentID, FirstName, LastName
ORDER BY FirstName, LastName
-- this gives us 17 rows: there are 17 students in total

SELECT FirstName, LastName, AVG(Mark) AS AverageMark
FROM Student
RIGHT JOIN Registration ON Student.StudentID = Registration.StudentID
GROUP BY Student.StudentID, FirstName, LastName
ORDER BY FirstName, LastName
-- this returns the exact same as the INNER

-- Oct 24 UNION examples
SELECT FirstName, LastName
FROM Student -- 17 students
UNION ALL
SELECT FirstName, LastName
FROM Staff -- 10 staff
-- by default, UNION removes duplicate results
-- UNION ALL forces them to be shown

-- subqueries
-- show me all students who have NOT made a payment
SELECT StudentID, FirstName, LastName
FROM Student
WHERE StudentID NOT IN
	(SELECT DISTINCT StudentID FROM Payment)
	-- this subquery gives me all the students who HAVE made a payment

GO

-- Oct 25 class examples
-- first let's create a view using an existing (working) SELECT statement:
CREATE VIEW v_StudentMarks
AS
SELECT FirstName + ' ' + LastName AS FullName
	, CourseName
	, Mark
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
INNER JOIN Course ON Offering.CourseID = Course.CourseId

GO -- batch terminator

-- now we can select from that view just like we select from a table:
SELECT * FROM v_StudentMarks

-- retrieve the definition
sp_helptext v_StudentMarks

