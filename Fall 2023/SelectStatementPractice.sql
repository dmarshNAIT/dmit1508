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