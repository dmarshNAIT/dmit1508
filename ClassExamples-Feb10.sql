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