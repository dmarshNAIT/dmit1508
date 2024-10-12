---------------------------------- October 10: Intro to SELECT ----------------------------------

-- tell SSMS which db to use
USE IQSchool
GO

-- I want a list of student names & cities
SELECT FirstName, LastName, City 
FROM Student

SELECT FirstName + ' ' + LastName AS FullName		-- v1
	, FullName = FirstName + ' ' + LastName			-- v2
	, City
FROM Student

-- we can do calculations in a SELECT statement, too:
SELECT Amount
	, Amount * 0.05 AS GST
FROM Payment

-- what if I want all the columns in the Student table?
SELECT * 
FROM Student
-- very dangerous, very risky

-- what if we want to filter records?
SELECT FirstName, LastName, City 
FROM Student
WHERE City = 'Edmonton'

-- I want to see all the students whose lastname starts with K
SELECT FirstName, LastName, City 
FROM Student
WHERE LastName LIKE 'K%'

-- I want to see students in Edmonton OR Calgary
SELECT FirstName, LastName, City 
FROM Student
WHERE City = 'Edmonton' OR City = 'Calgary'

-- or:
SELECT FirstName, LastName, City 
FROM Student
WHERE City IN ('Edmonton', 'Calgary')

---------------------------------- October 11: Aggregations ----------------------------------

-- look at all the payments in the payment table
SELECT Amount
FROM Payment

-- what is the overall average amount across all payments?
SELECT  AVG(Amount) AS AveragePayment
FROM Payment

-- tell me the largest & smallest payments
SELECT MIN(Amount) AS LowestPayment
, MAX(Amount) AS HighestPayment
, SUM(Amount) AS TotalPayments
, COUNT(*) AS NumberOfRows
FROM Payment

-- what are the 2 ways to use COUNT?
SELECT COUNT(*) AS NumberOfStaff
	, COUNT(StaffID) AS NumberOfRecordsWithAStaffID
	, COUNT(DateReleased) AS NumberOfRecordsWithADateReleased
FROM Staff

-- CHALLENGE:
-- how many students live in Calgary
SELECT COUNT(*) AS NumberOfStudents
FROM Student
WHERE City = 'Calgary'

-- what is the highest balance owing?
-- what is the total balance owing?
SELECT MAX(BalanceOwing) AS HighestBalance
	, SUM(BalanceOwing) AS TotalBalanceOwing
FROM Student

-- what if I want to aggregate across categories?
-- what is the average payment per payment type?
SELECT PaymentTypeID
	, AVG(Amount) AS AverageAmount
FROM Payment
GROUP BY PaymentTypeID -- "for each PaymentTypeID"

-- I want to see the students with an average mark > 75
SELECT StudentID
	, Avg(Mark) AS AverageMark
FROM Registration
GROUP BY StudentID
HAVING Avg(Mark) > 75


