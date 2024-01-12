--Inner Joins With Aggregates Exercises
USE IQSchool
GO

--1. How many staff are there in each position, including positions with no staff? Select the number and Position Description
SELECT PositionDescription, COUNT(DISTINCT StaffID) AS NumStaff
FROM Position -- Position is the Parent of Staff table
LEFT OUTER JOIN Staff ON Position.PositionID = Staff.PositionID
GROUP BY Position.PositionID, PositionDescription
-- OR: Staff RIGHT JOIN Position
 
--2. Select the average mark for each course. Display the CourseName and the average mark

-- if we only want courses with marks:
SELECT CourseName
	, AVG(Mark) AS AverageMark
FROM Course
INNER JOIN Offering on Course.CourseId = Offering.CourseID
INNER JOIN Registration ON Offering.OfferingCode = Registration.OfferingCode
GROUP BY Course.CourseId , CourseName

-- if we want all courses, even those WITHOUT marks:
SELECT CourseName
	, AVG(Mark) AS AverageMark
FROM Course
LEFT JOIN Offering on Course.CourseId = Offering.CourseID
LEFT JOIN Registration ON Offering.OfferingCode = Registration.OfferingCode
GROUP BY Course.CourseId , CourseName

--3. How many payments were made for each payment type (exclude those with no payments). Display the PaymentTypeDescription and the count
 
SELECT PaymentTypeDescription
	, COUNT(*) AS NumPayments
	-- OR
	, COUNT(DISTINCT PaymentID) AS NumPayments
FROM PaymentType
INNER JOIN Payment ON PaymentType.PaymentTypeID = Payment.PaymentTypeID -- or RIGHT JOIN
GROUP BY PaymentType.PaymentTypeID, PaymentTypeDescription

--4. Select the average Mark for each student. Display the Student Name and their average mark
 SELECT Student.FirstName + ' ' + Student.LastName AS FullName
	, AVG(Mark) AS AverageMark
 FROM Student
 INNER JOIN Registration ON Student.StudentID = Registration.StudentID
 GROUP BY Student.StudentID, FirstName, LastName

--5. Select the same data as question 4 but only show the student names and averages that are > 80
 SELECT Student.FirstName + ' ' + Student.LastName AS FullName
	, AVG(Mark) AS AverageMark
 FROM Student
 INNER JOIN Registration ON Student.StudentID = Registration.StudentID
 GROUP BY Student.StudentID, FirstName, LastName 
 HAVING AVG(Mark) > 80

--6.what is the highest, lowest and average payment amount for each payment type Description? (Ignore payment types with no payments)
 SELECT PaymentTypeDescription
	, MAX(Amount) AS HighestAmount
	, MIN(Amount) AS LowestAmount
	, AVG(Amount) AS AverageAmount
FROM PaymentType
INNER JOIN Payment ON PaymentType.PaymentTypeID = Payment.PaymentTypeID
GROUP BY PaymentType.PaymentTypeID, PaymentTypeDescription

--7. How many students are there in each club? Show the clubName and the count, including empty clubs
SELECT ClubName, COUNT(DISTINCT Activity.StudentID) AS NumStudents
FROM Activity
RIGHT JOIN Club on Activity.ClubId = Club.ClubId
GROUP BY Club.ClubId, ClubName
 
--8. Which clubs have 3 or more students in them? Display the Club Names.
SELECT ClubName
FROM Student
RIGHT JOIN Activity ON Student.StudentID = Activity.StudentID
RIGHT JOIN Club on Activity.ClubId = Club.ClubId
GROUP BY Club.ClubId, ClubName
HAVING COUNT(DISTINCT Activity.StudentID) >= 3
