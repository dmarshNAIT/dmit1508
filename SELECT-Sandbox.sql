-- tell SQL which db to run this script in
USE IQSchool
GO

-- select the name & city of each student
SELECT FirstName, LastName, City
FROM Student

-- select the course names & their cost
SELECT CourseName, CourseCost
FROM Course

-- we can combine fields together!
SELECT FirstName + LastName
	, FirstName + ' ' + LastName AS FullName
	, FullName = FirstName + ' ' + LastName
FROM Student

-- a dangerous but useful shortcut to see ALL the columns
SELECT *
FROM Student
-- we will never use this in a final query, but it's great to quickly see the contents of a table, or to use as a starting point

-- select just the students in Edmonton
SELECT FirstName, LastName, City
FROM Student
WHERE City = 'Edmonton'

-- select just the students in Edmonton & Calgary
SELECT FirstName, LastName, City
FROM Student
WHERE City = 'Edmonton'
	OR City = 'Calgary'
-- OR
SELECT FirstName, LastName, City
FROM Student
WHERE City IN ('Edmonton',  'Calgary')

-- all students EXCEPT students in Edmonton
SELECT FirstName, LastName, City
FROM Student
WHERE City != 'Edmonton'
-- or 
SELECT FirstName, LastName, City
FROM Student
WHERE City <> 'Edmonton'

-- all students whose name starts with D
SELECT FirstName, LastName, City
FROM Student
WHERE FirstName LIKE 'D%'

--------------------------- Aggregate functions ---------------------------
SELECT AVG(Amount) AS AveragePaymentAmount
,	SUM(Amount) AS TotalPayments
,	MIN(Amount) AS SmallestPaymentAmount
,	MAX(Amount) AS LargestPaymentAmount
FROM Payment

-- a few different ways to COUNT records:
SELECT COUNT(*) AS NumberOfRowsInQuery
	, COUNT(StaffID) AS NumberOfRowsWithStaffID
	, COUNT(DateReleased) AS NumberOfRowsWithDateReleased
FROM Staff

-- adding the DISTINCT keyword, which removes duplicates
SELECT FirstName FROM Student ORDER BY FirstName -- 17 rows
SELECT DISTINCT FirstName FROM Student ORDER BY FirstName -- 14 rows, because duplicates were removed

-- combining DISTINCT with COUNT:
SELECT COUNT(*) AS NumberOfRowsInQuery
,	COUNT(FirstName) AS NumberOfStudentsWithFirstName
,	COUNT(DISTINCT FirstName) AS NumberOfUniqueFirstNames
FROM Student

-- what if I don't want to aggregate the ENTIRE table? 
SELECT StudentID, Avg(AMOUNT) AS AveragePayment
FROM Payment
GROUP BY StudentID -- for each student

-- we can also filter by our aggregate values, using HAVING:
SELECT StudentID, Avg(AMOUNT) AS AveragePayment
FROM Payment
GROUP BY StudentID
HAVING Avg(AMOUNT) > 1000

--------------------------- UNION ---------------------------
SELECT FirstName, LastName
FROM Student -- 17 students
UNION
SELECT FirstName, LastName
FROM Staff -- 10 staff
-- plain old UNION gives me 25 records. why? because UNION gets rid of duplicates

SELECT FirstName, LastName
FROM Student -- 17 students
UNION ALL -- allows duplicate values
SELECT FirstName, LastName
FROM Staff -- 10 staff
-- UNION ALL gives me 27 rows, because we see the duplicate names.
ORDER BY FirstName

-- when using UNION: we must have the same # of columns, with similar datatypes, in the same order
-- the names of the column come from the *first* query in the UNION

--------------------------- DATE functions ---------------------------
SELECT GetDate() AS CurrentDateTime
	, DATEADD(yy, 16, GetDate()) AS DateEligibleToDrive -- add 16 years to today's date
	, DATEADD(yy, -16, GetDate()) AS SixteenYearsAgo -- subtract 16 years from today's date
	, YEAR(GetDate()) AS CurrentYear -- extract the year part of the date
	, MONTH(GetDate()) AS CurrentMonth -- extract the month part of the date
	, DAY(GetDate()) AS CurrentDay -- extract the day part of the date

SELECT Birthdate
	, DATEADD(yy, 16, Birthdate) AS DateEligibleToDrive -- add 16 years to birthday
	, DATEDIFF(yy, Birthdate, GetDate()) AS Age -- difference in years between birthday and today
	, DATENAME(dw, Birthdate) AS DayOfWeekBorn -- name of the day of the week
	, DATENAME(mm, Birthdate) AS MonthBorn -- name of the month
	, DATEPART(mm, Birthdate) AS MonthBorn -- # of the month
FROM Student

--------------------------- String functions ---------------------------
SELECT FirstName
	, LEN(FirstName) AS Length
	, LEFT(FirstName, 2) AS First2Letters
	, RIGHT(FirstName, 2) AS Last2Letters
	, SUBSTRING(FirstName, 2, 3) AS LettersInMiddle -- starting at char 2, select 3 chars
	, REVERSE(FirstName) AS ReversedName
	, UPPER(FirstName) AS Uppercase
	, LOWER(FirstName) AS Lowercase
FROM Student

SELECT '      apple     ' AS TestData
SELECT RTRIM(LTRIM('      apple     ')) AS TestDataNoSpaces

--------------------------- JOINs ---------------------------

SELECT FirstName, LastName, Mark
FROM Student 
INNER JOIN Registration ON Student.StudentID = Registration.StudentID

SELECT COUNT(*) FROM Student -- 17 students
SELECT COUNT(*) FROM Registration -- 70 records

SELECT COUNT(DISTINCT StudentID) FROM Registration -- 8 students in the registration table

-- INNER JOINs only return records that exist in BOTH tables
-- INNER JOINs only return parent records that have child records

-- what if I want to see all the parent records, even those without child records?
-- LEFT OUTER JOIN will be used if the parent table is on the LEFT; it's the first table
-- RIGHT OUTER JOIN if the parent table is on the RIGHT; it's the 2nd table

SELECT FirstName, LastName, Mark
FROM Student 
LEFT JOIN Registration ON Student.StudentID = Registration.StudentID

-- what if I want data from more than 2 tables?
SELECT FirstName, LastName, Mark, CourseName
FROM Student 
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
INNER JOIN Course ON Offering.CourseID = Course.CourseId

-- do we have any students that do NOT have payments?
-- how many students do we have in the student table?
SELECT COUNT(DISTINCT StudentID) AS StudentCount FROM Student -- 17
-- how many students do we have in the payments table?
SELECT COUNT(DISTINCT StudentID) AS StudentCount FROM Payment -- 7

-- let's join these 2 tables using an INNER JOIN
SELECT Student.StudentID, FirstName, LastName, SUM(Amount) AS TotalPayments
FROM Student
INNER JOIN Payment ON Student.StudentID = Payment.StudentID
GROUP BY Student.StudentID, FirstName, LastName

-- what if it's an OUTER JOIN?
SELECT Student.StudentID, FirstName, LastName, SUM(Amount) AS TotalPayments
FROM Student
LEFT JOIN Payment ON Student.StudentID = Payment.StudentID
GROUP BY Student.StudentID, FirstName, LastName
-- OR:
SELECT Student.StudentID, FirstName, LastName, SUM(Amount) AS TotalPayments
FROM Payment
RIGHT JOIN Student ON Student.StudentID = Payment.StudentID
GROUP BY Student.StudentID, FirstName, LastName

-- what if the tables we want data from aren't directly connected?
SELECT FirstName, LastName, CourseName
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
INNER JOIN Course ON Offering.CourseID = Course.CourseId