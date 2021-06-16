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

