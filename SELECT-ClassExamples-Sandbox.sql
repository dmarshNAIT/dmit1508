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