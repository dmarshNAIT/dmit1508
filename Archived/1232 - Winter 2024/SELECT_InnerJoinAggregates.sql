--Inner Joins with Aggregates Exercises
USE IQSchool
GO

--1. How many staff are there in each position? Select the number and Position Description.
SELECT PositionDescription
	, COUNT(StaffID) AS NumberStaff
FROM Position 
INNER JOIN Staff ON Position.PositionID = Staff.PositionID
-- this means any positions with 0 staff will be left out
GROUP BY Position.PositionID, PositionDescription

--2. Select the average mark for each course. Display the CourseName and the average mark.
SELECT CourseName, AVG(Mark) AS AverageMark
FROM Course
INNER JOIN Offering ON Course.CourseId = Offering.CourseId
INNER JOIN Registration ON Offering.OfferingCode = Registration.OfferingCode
-- this means any course with 0 registrations will be filtered out
GROUP BY Course.CourseId, Course.CourseName

--3. How many payments were made for each payment type? Display the PaymentTypeDescription and the count.
SELECT PaymentTypeDescription
	, COUNT(PaymentID) AS NumberPayments
FROM PaymentType
INNER JOIN Payment ON PaymentType.PaymentTypeID = Payment.PaymentTypeID
-- this means we won't see types with 0 payments
GROUP BY PaymentType.PaymentTypeID, PaymentTypeDescription

--4. Select the average Mark for each student. Display the Student Name and their average mark.
SELECT FirstName + ' ' + LastName AS FullName
	, AVG(Mark) AS AverageMark
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
GROUP BY Student.StudentID, FirstName, LastName

--5. Select the same data as question 4 but only show the student names and averages that are > 80.
SELECT FirstName + ' ' + LastName AS FullName
	, AVG(Mark) AS AverageMark
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
GROUP BY Student.StudentID, FirstName, LastName
HAVING AVG(Mark) > 80

--6.what is the highest, lowest and average payment amount for each payment type Description? 
 SELECT PaymentTypeDescription
	, MAX(Amount) AS HighestPayment
	, MIN(Amount) AS LowestPayment
	, AVG(Amount) AS AveragePayment
 FROM PaymentType AS type 
 LEFT JOIN Payment ON type.PaymentTypeID = Payment.PaymentTypeID
 GROUP BY type.PaymentTypeID, PaymentTypeDescription

--7. How many students are there in each club? Show the clubName and the count.
SELECT ClubName
	, COUNT(StudentID) AS NumberStudents
FROM Activity RIGHT JOIN Club ON Activity.ClubId = Club.ClubId
GROUP BY Club.ClubId, ClubName

--8. Which clubs have 3 or more students in them? Display the Club Names.
SELECT ClubName
	, COUNT(StudentID) AS NumberStudents
FROM Activity RIGHT JOIN Club ON Activity.ClubId = Club.ClubId
GROUP BY Club.ClubId, ClubName
HAVING COUNT(StudentID) >= 3
