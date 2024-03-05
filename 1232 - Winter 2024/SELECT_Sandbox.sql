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

------------ Feb 26 class ------------
SELECT OfferingCode
,	Avg(Mark) AS AverageMark
FROM Registration
GROUP BY OfferingCode -- 'for each offering code'
HAVING Avg(Mark) < 60

SELECT FirstName 
FROM Student
ORDER BY FirstName

SELECT DISTINCT FirstName 
FROM Student
ORDER BY FirstName
-- distinct removes duplicates

SELECT FirstName, LastName 
FROM Student 
ORDER BY LastName

SELECT DISTINCT FirstName, LastName 
FROM Student 
ORDER BY LastName

SELECT COUNT(StudentID) AS [# of Payments with a Student ID]
	, COUNT(DISTINCT StudentID) AS [# of unique Student IDs]
FROM Payment

SELECT COUNT(*) AS [# of students]
	, COUNT(FirstName) AS [# of students with a first name]
	, COUNT(DISTINCT FirstName) AS [# of unique first names]
FROM Student

-- which names are repeated?
SELECT FirstName
FROM Student
GROUP BY FirstName
HAVING COUNT(*) > 1
-- Dana TO DO: are there any bonus content ways to do this?

SELECT FirstName
	, LEN(FirstName) AS [# of characters]
	, LEFT(FirstName, 2) AS [First 2 chars]
	, RIGHT(FirstName, 2) AS [Last 2 chars]
	, SUBSTRING(FirstName, 2, 3) AS [3 chars starting at position 2]
	, REVERSE(FirstName) AS [Backwards]
FROM Student

SELECT Birthdate
	, DateAdd(yy, 16, Birthdate) -- add 16 years
	, DateAdd(dd, -100, GetDate()) -- subtract 100 days
	, DateDiff(mm, Birthdate, GetDate()) -- diff in months
	, DateDiff(mm, GetDate(), Birthdate) -- diff in months
	, DateName(dw, GetDate()) -- name of the day of the week
	, DatePart(dw, GetDate()) -- # of the day of the week
	, Month(GetDate()) -- # of the current month
FROM Student

-- how many students do we have in this db?
SELECT COUNT(*) FROM Student -- 17 students

-- how many students have registered for a course?
SELECT COUNT(DISTINCT StudentID) 
FROM Registration -- 8 students

-- how many courses has each student registered in?
SELECT FirstName, LastName, Student.StudentID, COUNT(OfferingCode)
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
GROUP BY FirstName, LastName, Student.StudentID
-- parents who have children

-- same thing but different JOIN type:
SELECT FirstName, LastName, Student.StudentID, COUNT(OfferingCode)
FROM Student
LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
GROUP BY FirstName, LastName, Student.StudentID
-- all parents, even if they don't have children

------------ Feb 28 class ------------

-- how many payments were made of each type?
SELECT PaymentTypeID
	, COUNT(*) AS NumberOfRows
	-- or:
	, COUNT(PaymentID) AS NumberOfPayments
FROM Payment
GROUP BY PaymentTypeID

-- now, show me just the payment types used < 5x 
SELECT PaymentTypeID
	, COUNT(*) AS NumberOfRows
FROM Payment
GROUP BY PaymentTypeID
HAVING COUNT(*) < 5

-- now, show me the DESCRIPTION of the payments, and how many times each was used
SELECT PaymentTypeDescription
	, COUNT(*) AS WrongWayToCount -- # of rows, but one is NULL
	, COUNT(PaymentID) AS NumberOfPayments
FROM PaymentType AS pt -- this gives our table a nickname
LEFT JOIN Payment AS p
	ON pt.PaymentTypeID = p.PaymentTypeID
GROUP BY pt.PaymentTypeID, PaymentTypeDescription
-- we need to GROUP BY type ID bc that is what makes types unique
-- we need to GROUP BY Desc bc it's in our SELECT statement

-- let's look at the raw data
SELECT PaymentTypeDescription
	, PaymentDate
FROM PaymentType AS pt -- this gives our table a nickname
LEFT JOIN Payment AS p
	ON pt.PaymentTypeID = p.PaymentTypeID

-- there are 17 students in our DB, but only 8 in the registration table.
-- can we write a query to get a list of the students who are NOT in the registration table?
SELECT DISTINCT Student.StudentID, Registration.StudentID
FROM Student
LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
WHERE Registration.StudentID IS NULL

-- another way to solve this question:
-- get a list of students
-- where the student ID is NOT IN the registration table

-- list of students in reg table:
SELECT DISTINCT StudentID FROM Registration

-- now let's combine that:
SELECT DISTINCT StudentID 
FROM Student
WHERE StudentID NOT IN (
			SELECT DISTINCT StudentID 
			FROM Registration
		)

-- using a subquery, which city has the most students in it?
SELECT City, COUNT(*) AS NumStudents
FROM Student
GROUP BY City
HAVING COUNT(*) >= ALL(
		SELECT COUNT(*)
		FROM Student
		GROUP BY City)

-- using a subquery, which students have an average mark higher than at least one classmate?
SELECT FirstName + ' ' + LastName AS FullName
	, AVG(Mark) AS AverageMark
FROM Student
LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
GROUP BY Student.StudentID, FirstName, LastName
HAVING AVG(Mark) > ANY ( -- SOME can be used instead of ANY
	SELECT Avg(Mark)
	FROM Registration
	GROUP BY StudentID)

-- now, something that ISN'T a subquery:
-- let's get a list of all the students and all the staff
SELECT FirstName + ' ' + LastName  AS Name
FROM Student -- 17 students
UNION -- this gets rid of duplicates
SELECT FirstName + ' ' + LastName  AS Name
FROM Staff -- 10 students

SELECT FirstName + ' ' + LastName  AS Name
FROM Student -- 17 students
UNION ALL -- this leaves in the duplicates
SELECT FirstName + ' ' + LastName  AS Name
FROM Staff -- 10 students
ORDER BY Name

GO -- marks the end of the batch

------------ Mar 4 class ------------
-- for every course, I want to see:
	-- the course name
	-- the # of times it's been offered
	-- how many DISTINCT students have taken it
	-- the average mark


CREATE VIEW vw_CourseList AS

SELECT CourseName
	, COUNT(Offering.OfferingCode) AS NumberOfOfferings
	, COUNT(DISTINCT Registration.StudentID) AS NumberOfDistinctStudents
	, AVG(Registration.Mark) AS AverageMark
FROM Course
LEFT JOIN Offering ON Course.CourseId = Offering.CourseId
LEFT JOIN Registration ON Offering.OfferingCode = Registration.OfferingCode
GROUP BY CourseName, Course.CourseID

GO -- marks the end of a batch

-- after a view exists, we can view its definition:
SP_HELPTEXT vw_CourseList
-- we can view its contents:
SELECT * FROM vw_CourseList