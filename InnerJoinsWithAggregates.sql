-- Inner Joins With Aggregates Exercises
-- Author: Dana Marsh

--1. How many staff are there in each position? Select the number and Position Description
SELECT PositionDescription, COUNT(*) AS NumStaff
FROM Staff
INNER JOIN Position ON Staff.PositionID = Position.PositionID
GROUP BY Position.PositionID, PositionDescription
 
--2. Select the average mark for each course. Display the CourseName and the average mark
SELECT CourseName, AVG(Mark) AS AverageMark
FROM Registration
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
INNER JOIN Course ON Offering.CourseID = Course.CourseId
GROUP BY Course.CourseID, CourseName

--3. How many payments were made for each payment type. Display the PaymentTypeDescription and the count
SELECT PaymentTypeDescription, COUNT(*) AS NumPayments
FROM Payment
INNER JOIN PaymentType ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
GROUP BY Payment.PaymentTypeID, PaymentTypeDescription

--4. Select the average Mark for each student. Display the Student Name and their average mark
SELECT Student.FirstName + ' ' + Student.LastName AS StudentName
	, AVG(Mark) AS AverageMark
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
GROUP BY Student.StudentID, FirstName, LastName

--5. Select the same data as question 4 but only show the student names and averages that are > 80
SELECT Student.FirstName + ' ' + Student.LastName AS StudentName
	, AVG(Mark) AS AverageMark
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
GROUP BY Student.StudentID, FirstName, LastName
HAVING AVG(Mark) > 80
 
--6.what is the highest, lowest and average payment amount for each payment type Description? 
 
 SELECT PaymentTypeDescription
        ,    MAX(Amount) AS HighestAmount        ,    MIN(Amount) AS LowestAmount
		,    AVG(Amount) AS AverageAmount
 FROM Payment
 INNER JOIN PaymentType ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
 GROUP BY Payment.PaymentTypeID, PaymentTypeDescription

--7. How many students are there in each club? Show the clubName and the count
 SELECT ClubName, COUNT(*) AS NumStudents
 FROM Club
 INNER JOIN Activity ON Club.ClubId = Activity.ClubId
 GROUP BY Club.ClubId, ClubName

--8. Which clubs have 3 or more students in them? Display the Club Names.
 SELECT ClubName 
 FROM Club
 INNER JOIN Activity ON Club.ClubId = Activity.ClubId
 GROUP BY Club.ClubId, ClubName
 HAVING COUNT(*) >= 3


