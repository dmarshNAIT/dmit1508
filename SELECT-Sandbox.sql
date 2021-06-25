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

-- a dangerous but useful shortcut to get ALL the columns without explicitly listing them:
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
-- of the 85 combined rows, there are 24 unique values.

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

-- grouping data to get the average mark PER student:
SELECT 
	StudentID
,	AVG(Mark) AS AverageMark
FROM Registration
GROUP BY StudentID

-- what were the total Payments per student?
SELECT StudentID, SUM(Amount) AS TotalPayments
FROM Payment
GROUP BY StudentID

-- string functions:
SELECT FirstName
	, LEN(FirstName) AS Length
	, LEFT(FirstName, 2) AS First2Chars
	, RIGHT(FirstName, 2) AS Last2Chars
	, SUBSTRING(FirstName, 2, 3) AS OtherChars -- starting at position 2, return 3 chars
	, REVERSE(FirstName) AS Reversed
	, UPPER(FirstName) AS Uppercase
	, LOWER(FirstName) AS Lowercase
FROM Student
-- WHERE LEN(FirstName) = 3

SELECT '      apple     ' AS TestData

SELECT RTRIM(LTRIM('      apple     ')) AS TestDataWithoutWhiteSpace

SELECT TRIM('      apple     ') AS TestDataWithoutWhiteSpaceVersion2

-- date functions
SELECT BirthDate
	, YEAR(BirthDate) AS YearBorn
	, MONTH(Birthdate) AS MonthBorn
	, DAY(Birthdate) AS DayBorn
	, DATEPART(qq, Birthdate) AS QuarterBorn
	, DATEPART(wk, Birthdate) AS WeekBorn
	, DATEPART(dw, Birthdate) AS DayOfWeekBorn
	, DATENAME(dw, Birthdate) AS DayOfWeekBorn
FROM Student

SELECT GetDate() AS CurrentDate
	, DATENAME(mm, GetDate()) AS CurrentMonth

SELECT BirthDate
	, DATEDIFF(dd, BirthDate, GetDate()) AS DaysOld
	, DATEADD(yy, 16, Birthdate) AS SixteenthBirthday
FROM Student


-- JOINs
SELECT FirstName, LastName, Mark
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID

-- how many students are in the Student table?
SELECT DISTINCT StudentID FROM Student -- 17 students

-- how many students are in the Registration table?
SELECT DISTINCT StudentID FROM Registration -- 8 students

-- query the number of students who have marks using a JOIN
SELECT DISTINCT Student.StudentID
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
-- also 8 records: the 8 children & their parents

SELECT DISTINCT Student.StudentID
FROM Student 
LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
-- this is parents whether or not they have children: 17 records

-- LEFT JOINs mean we can have NULL values in the child records:
SELECT FirstName, LastName, Mark
FROM Student
LEFT JOIN Registration ON Student.StudentID = Registration.StudentID

SELECT FirstName, LastName, Mark
FROM Student
RIGHT JOIN Registration ON Student.StudentID = Registration.StudentID -- same results as INNER, so we should use INNER JOIN instead