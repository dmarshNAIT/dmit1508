USE IQSchool
GO

SELECT 
	StudentID
,	FirstName + ' ' + LastName AS FullName
-- OR:
,	FullName = FirstName + ' ' + LastName
FROM Student

SELECT Amount
,	Amount * 0.05 AS GST
FROM Payment

-- BONUS: if we want to hide the extra decimals, we can change the data type:
SELECT Amount
,	CAST(Amount * 0.05 AS DECIMAL(10,2)) AS GST
FROM Payment

SELECT PaymentID, PaymentDate, Amount, StudentID
FROM Payment
WHERE Amount > 1000
-- Payment table has 33 rows
-- 12 of those rows have an Amount > $1000

SELECT PaymentID
, PaymentDate
, '$' + CONVERT(VARCHAR, Amount) AS Amount
, StudentID
FROM Payment
WHERE StudentID = 199912010
	OR StudentID = 200494470

SELECT PaymentID
, PaymentDate
, '$' + CONVERT(VARCHAR, Amount) AS Amount
, StudentID
FROM Payment
WHERE StudentID IN ( 199912010, 200494470 )

-- UNION

SELECT FirstName
	, LastName
	, 'Student' AS Type
	, StudentID AS ID
FROM Student -- 17 students
UNION ALL
SELECT FirstName
	, LastName
	, 'Staff'
	, StaffID
FROM Staff -- 10 staff
ORDER BY LastName, FirstName

-- Aggregate Functions

SELECT Mark FROM Registration -- 70 rows
SELECT AVG(Mark) AS AverageMark 
, MIN(Mark) AS LowestMark
, MAX(Mark) AS HighestMark 
, COUNT(Mark) AS NumberOfMarks
FROM Registration
WHERE OfferingCode = 1000

SELECT COUNT(DISTINCT OfferingCode) FROM Registration -- 15 offerings

SELECT OfferingCode
	, AVG(Mark) AS AverageMark
FROM Registration
GROUP BY OfferingCode

SELECT COUNT(StaffID) AS NumberOfStaff
	, COUNT(DateReleased) AS NumberRetired
	, COUNT(*) AS NumberOfRows
FROM Staff

SELECT SUM(Amount) AS TotalPayments FROM Payment

-- ALL vs DISTINCT

SELECT FirstName -- defaults to ALL
FROM Student 

SELECT DISTINCT FirstName -- remove duplicate records
FROM Student 

SELECT COUNT(*) AS NumberOfRows
	, COUNT(FirstName) AS NumberOfRecordsWithFirstNames
	, COUNT(DISTINCT FirstName) AS NumberOfUniqueFirstNames
FROM Student

SELECT DISTINCT FirstName, LastName
FROM Student
ORDER BY FirstName

-- String functions!
SELECT FirstName
	, LEN(FirstName) AS LengthOfName
	, LEFT(FirstName, 2) AS First2Chars
	, RIGHT(FirstName, 2) AS Last2Chars
	, SUBSTRING(FirstName, 3, 2) AS MiddleChars 
		-- starting at char 3, give me 2 chars
	, REVERSE(FirstName) AS ReverseName
	, UPPER(FirstName)
	, LOWER(FirstName)
FROM Student

-- date functions

SELECT GetDate()

SELECT Birthdate
	, DATEADD(yy, 18, Birthdate) AS WhenCanTheyVote
	, DATEADD(mm, 6, Birthdate) AS FirstHalfBirthday
	, DATEDIFF(yy, Birthdate, GetDate()) AS HowOldAreThey
	, DateName(mm, Birthdate) AS BirthMonth
	, DatePart(mm, Birthdate) AS BirthMonth
	, YEAR(Birthdate)
	, MONTH(Birthdate)
	, DAY(Birthdate)
FROM Student

-- JOIN
SELECT DISTINCT Student.FirstName
	, Student.LastName
	, Student.StudentID
	--, Registration.Mark
FROM Student -- Student is the parent
INNER JOIN Registration -- Registation is the child
	ON Student.StudentID = Registration.StudentID 
		-- how the tables are related

-- how many students do we have?
SELECT COUNT(DISTINCT StudentID) FROM Student -- 17 students
-- how many students have marks?
SELECT COUNT(DISTINCT StudentID) FROM Registration -- 8 students

-- INNER JOIN returns ONLY records that exist in both tables: so we only see 8 tables in the INNER JOIN between Student and Registration

-- OUTER JOIN returns records in BOTH tables, regardless of whether they are in the other table:

SELECT Student.FirstName
	, Student.LastName
	, Student.StudentID
	, Registration.Mark
FROM Student -- Student is the parent
FULL OUTER JOIN Registration -- Registation is the child
	ON Student.StudentID = Registration.StudentID 
		-- how the tables are related

-- how many payment types does the school accept?
SELECT COUNT(DISTINCT PaymentTypeID) AS NumPaymentTypes
FROM PaymentType

-- how many payment types have been used?
SELECT COUNT(DISTINCT PaymentTypeID) AS NumPaymentTypes
FROM Payment

SELECT PaymentType.PaymentTypeID
	, PaymentType.PaymentTypeDescription
	, Payment.Amount
FROM PaymentType
INNER JOIN Payment ON PaymentType.PaymentTypeID = Payment.PaymentTypeID

SELECT PaymentType.PaymentTypeID
	, PaymentType.PaymentTypeDescription
	, Payment.Amount
FROM PaymentType
FULL OUTER JOIN Payment ON PaymentType.PaymentTypeID = Payment.PaymentTypeID

SELECT PaymentType.PaymentTypeID
	, PaymentType.PaymentTypeDescription
	, Payment.Amount
FROM PaymentType
LEFT OUTER JOIN Payment ON PaymentType.PaymentTypeID = Payment.PaymentTypeID

SELECT PaymentType.PaymentTypeID
	, PaymentType.PaymentTypeDescription
	, Payment.Amount
FROM PaymentType
RIGHT OUTER JOIN Payment ON PaymentType.PaymentTypeID = Payment.PaymentTypeID

-- if the parent is first: LEFT JOIN acts like a FULL JOIN (all parent records)
--							RIGHT JOIN acts like an INNER JOIN (only parents with children)

-- if the CHILD is first: opposite.

SELECT PaymentType.PaymentTypeID
	, PaymentType.PaymentTypeDescription
	, SUM(Payment.Amount) AS TotalAmount
FROM PaymentType
LEFT OUTER JOIN Payment ON PaymentType.PaymentTypeID = Payment.PaymentTypeID
GROUP BY PaymentType.PaymentTypeID
	, PaymentType.PaymentTypeDescription

SELECT PaymentType.PaymentTypeID
	, PaymentType.PaymentTypeDescription
	, ISNULL(SUM(Payment.Amount),0) AS TotalAmount -- BONUS CONTENT
FROM PaymentType
LEFT OUTER JOIN Payment ON PaymentType.PaymentTypeID = Payment.PaymentTypeID
GROUP BY PaymentType.PaymentTypeID
	, PaymentType.PaymentTypeDescription


-- Subquery

SELECT *
FROM Staff
WHERE PositionID = (
		SELECT PositionID 
		FROM Position 
		WHERE PositionDescription = 'Dean'
)

SELECT *
FROM Staff
WHERE PositionID IN (
		SELECT PositionID 
		FROM Position 
)

-- how many students have NEVER made a payment?
SELECT *
FROM Student
WHERE StudentID NOT IN (
	SELECT StudentID FROM Payment
)

-- which is the same as:
SELECT Student.StudentID
FROM Student
LEFT OUTER JOIN Payment ON Student.StudentID = Payment.StudentID
WHERE PaymentID IS NULL

-- SOME, ANY, ALL
SELECT *
FROM Registration
WHERE Mark >= ALL ( -- marks greater than or equal to EVERY mark in the table
	SELECT Mark FROM Registration
)

SELECT *
FROM Registration
WHERE Mark > SOME ( -- will return everything except the lowest mark
	SELECT Mark FROM Registration
)