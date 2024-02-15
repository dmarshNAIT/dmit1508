USE IQSchool
GO

SELECT FirstName + ' ' + LastName AS FullName
	, FullName = FirstName + ' ' + LastName
	-- 2 different ways to create aliases
	, City
FROM Student

SELECT PaymentDate 
	, Amount
	, Amount * 0.05 AS GST
	-- the AS keyword lets us name this derived column
FROM Payment

-- a dangerous shorcut
SELECT *
FROM Student
-- we will use this as a starting point: NOT in our final queries

-- what if I don't want all the students?
SELECT FirstName, LastName, City
FROM Student
WHERE City = 'Edmonton'

-- students with a Q or Z in their postal code
SELECT FirstName, LastName, PostalCode
FROM Student
WHERE PostalCode LIKE '%Q%' OR PostalCode LIKE '%Z%'
-- or
SELECT FirstName, LastName, PostalCode
FROM Student
WHERE PostalCode LIKE '%[QZ]%'

------------ Feb 14 class ------------
-- aggregate functions

SELECT Mark FROM Registration

-- what is the average mark per student?
SELECT Avg(Mark) AS 'Average Mark'
	,	'Average Mark' = Avg(Mark)
FROM Registration

-- what is the average, total, highest, and lowest payment for a specific student?
SELECT SUM(Amount) AS 'Total Payments'
	, AVG(Amount) AS 'Average Payment'
	, MAX(Amount) AS 'Highest Payment'
	, MIN(Amount) AS 'Lowest Payment'
FROM Payment
WHERE StudentID =  199899200

-- 2 different ways to use COUNT
SELECT COUNT(*) AS 'Number of Rows in this table'
, COUNT(DateReleased) AS '# of non-null values in this column'
FROM Staff

-- what is the average mark per student?
SELECT StudentID
	, Avg(Mark) AS 'Average Mark'
FROM Registration
GROUP BY StudentID -- " for each student "

-- what is the largest payment made by each student?
SELECT StudentID
	, Max(Amount) AS LargestPayment
FROM Payment
GROUP BY StudentID