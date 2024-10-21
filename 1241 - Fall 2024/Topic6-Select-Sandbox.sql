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


---------------------------------- October 21: DISTINCT, ORDER BY, Strings, Dates, JOINs ----------------------------------

SELECT FirstName, LastName
FROM Student
ORDER BY LastName DESC, FirstName
-- if not specificed, we order in ASCending order (A-Z, 1-9)
-- we can ORDER BY 1 or more columns

SELECT DISTINCT FirstName, LastName
FROM Student
ORDER BY LastName DESC, FirstName
-- shows us 16 names, because the duplicate Dave Brown was hidden

SELECT DISTINCT FirstName, LastName, StudentID
FROM Student
ORDER BY LastName DESC, FirstName

SELECT COUNT(*) AS NumberOfStudents
	, COUNT(StudentID) AS NumberOfStudentsV2
	, COUNT(DISTINCT FirstName) AS NumberOfUniqueFirstNames
FROM Student

-- String Functions --
SELECT CourseID
	, CourseName
	, LEN(CourseName) AS NumberOfCharacters -- including spaces
	, LEFT(CourseID, 4) AS 'First 4 Characters'
	, RIGHT(CourseID, 4) AS 'Last 4 Characters'
	, REVERSE(CourseName) AS 'Backwards'
	, UPPER(CourseName) AS 'Uppercase Name'
	, LOWER(CourseName) AS 'Lowercase Name'
FROM Course

SELECT PostalCode
	, SUBSTRING(PostalCode, 2, 1) AS 'Second Character'
	-- starting at index 2, grab 1 character
FROM Student

-- Date Functions --
SELECT GetDate() AS 'System Date & Time'

SELECT BirthDate
	, DateAdd(yy, 16, Birthdate) AS 'Eligible for License'
	, DateDiff(dd, Birthdate, GetDate()) AS 'How Many Days Old'
	, DateName(mm, Birthdate) AS 'Name of Month'
	, DatePart(mm, Birthdate) AS 'Number of Month'
	, MONTH(Birthdate) AS 'Shortcut for Number of Month'
FROM Student

-- JOINs --
SELECT FirstName, LastName, Mark
FROM Student
INNER JOIN Registration
	ON Student.StudentID = Registration.StudentID
ORDER BY FirstName, LastName
-- we have 17 students; we see 70 results because some students show up in the Registration table many times

-- what if we need MORE tables?
SELECT FirstName, LastName, Mark, CourseID
FROM Student
INNER JOIN Registration
	ON Student.StudentID = Registration.StudentID
INNER JOIN Offering
	ON Registration.OfferingCode = Offering.OfferingCode
ORDER BY FirstName, LastName

-- what if we want the AVERAGE mark per student?
SELECT FirstName, LastName, AVG(Mark) AS AverageMark
FROM Student
LEFT JOIN Registration
	ON Student.StudentID = Registration.StudentID
-- LEFT JOIN because I want all students, even those without Registration
GROUP BY FirstName, LastName, Student.StudentID
-- GROUP BY everything in the SELECT + something unique
ORDER BY FirstName, LastName