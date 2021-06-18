USE IQSchool

-- selecting specific columns from the Student table
SELECT FirstName, LastName, City
FROM Student

-- four different ways to name combined fields:
SELECT FirstName + ' ' + LastName AS StudentName
, StudentName = FirstName + ' ' + LastName
, FirstName + ' ' + LastName AS [Student Name]
, FirstName + ' ' + LastName AS 'Student Name'
FROM Student

-- doing math with derived fields:
SELECT Amount
, Amount * 0.05 AS GST
, CAST(Amount * 0.05 AS MONEY) AS GSTButPretty
-- ^ CAST is bonus content / not required to know
FROM Payment

-- a dangerous but useful shortcut
SELECT *
FROM Student
-- this will never be used in a final query, just to quickly explore a table's contents

-- a list of students whose first name starts with W
SELECT FirstName, LastName, City
FROM Student
WHERE FirstName LIKE 'W%'

-- a list of students in Edmonton:
SELECT FirstName, LastName
FROM Student
WHERE City = 'Edmonton'

-- a list of students EXCEPT those in Edmonton:
SELECT FirstName, LastName
FROM Student
WHERE City != 'Edmonton'



-- all payments over $1000:
SELECT PaymentID, Amount
FROM Payment
WHERE Amount > 1000

-- students whose name starts with W AND who live in Edmonton
SELECT FirstName, LastName, City
FROM Student
WHERE FirstName LIKE 'W%' AND City = 'Edmonton'
-- no results, because Winnie lives in Calgary

-- students whose name starts with W OR they live in Edmonton
SELECT FirstName, LastName, City
FROM Student
WHERE FirstName LIKE 'W%' OR City = 'Edmonton'

-- all payments between $500 and $1000
SELECT PaymentID, Amount
FROM Payment
WHERE Amount BETWEEN 500 AND 1000

-- all students in Edmonton OR Calgary:
SELECT FirstName, City
FROM Student
WHERE City = 'Edmonton' OR City = 'Calgary'

-- or:
SELECT FirstName, City
FROM Student
WHERE City IN ('Edmonton', 'Calgary') 

-- or everyone EXCEPT those in Edmonton or Calgary:
SELECT FirstName, City
FROM Student
WHERE City NOT IN ('Edmonton', 'Calgary') -- opposite day

-- more on the LIKE operator
SELECT 
	FirstName
, 	LastName 
FROM Student
WHERE FirstName LIKE 'W%'
-- this does NOT return the same as 
SELECT 
	FirstName
, 	LastName 
FROM Student
WHERE FirstName = 'W%' -- because no student has the last name W%


-- UNION
SELECT FirstName, LastName
FROM Student -- 17 students
UNION
SELECT FirstName, LastName
FROM Staff -- 10 staff
-- plain old UNION gets rid of duplicates

SELECT FirstName, LastName
FROM Student -- 17 students
UNION ALL -- does NOT get rid of duplicates
SELECT FirstName, LastName
FROM Staff -- 10 staff
ORDER BY LastName, FirstName -- optional: how we SORT our results

-- a nonsense query combining numbers:
SELECT Mark AS ImportantAlias FROM Registration -- 70 rows
UNION
SELECT OfferingCode FROM Offering -- 15 rows

-- working with aggregate data
SELECT AVG(Mark) AS AverageMark
	, MIN(Mark) AS LowestMark
	, MAX(Mark) AS HighestMark
FROM Registration

SELECT SUM(Amount) AS TotalPayments
FROM Payment

SELECT COUNT(*) AS NumberOfRecords
, COUNT(DateReleased) AS NumberOfRecordsWhereDateReleasedIsNotNull
FROM Staff


-- group data
SELECT 
	StudentID
,	AVG(Mark) AS AverageMark
FROM Registration
GROUP BY StudentID

-- what were the total Payments per student?
SELECT StudentID, SUM(Amount) AS TotalPayments
FROM Payment
GROUP BY StudentID

