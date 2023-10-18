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