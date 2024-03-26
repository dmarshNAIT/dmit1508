--Inner Joins with Aggregates Exercises
USE IQSchool
GO

--1. How many staff are there in each position? Select the number and Position Description.
SELECT COUNT(DISTINCT StaffID) AS NumberOfStaff
	, PositionDescription
FROM Staff
RIGHT JOIN Position ON Staff.PositionID = Position.PositionID
-- or Position LEFT JOIN Staff
GROUP BY Position.PositionID, PositionDescription
-- we need to group by PositionID as it uniquely identifies each position

--2. Select the average mark for each course. Display the CourseName and the average mark.
SELECT CourseName, AVG(Mark) AS AverageMark
FROM Course
LEFT JOIN Offering ON Course.CourseId = Offering.CourseID
LEFT JOIN Registration ON Offering.OfferingCode = Registration.OfferingCode
GROUP BY Course.CourseId, CourseName

--3. How many payments were made for each payment type. Display the PaymentTypeDescription and the count.
 SELECT PaymentTypeDescription
	, COUNT(PaymentID) AS NumberPayments
 FROM PaymentType AS type 
 LEFT JOIN Payment ON type.PaymentTypeID = Payment.PaymentTypeID
 GROUP BY type.PaymentTypeID, PaymentTypeDescription

--4. Select the average Mark for each student. Display the Student Name and their average mark.
SELECT FirstName + ' ' + LastName AS FullName
	, AVG(Mark) AS AverageMark
FROM Student
LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
GROUP BY Student.StudentID, FirstName, LastName

--5. Select the same data as question 4 but only show the student names and averages that are > 80.
SELECT FirstName + ' ' + LastName AS FullName
	, AVG(Mark) AS AverageMark
FROM Student
LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
GROUP BY Student.StudentID, FirstName, LastName
HAVING AVG(Mark) > 80

--6.what is the highest, lowest, and average payment amount for each payment type Description? 
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
GROUP BY ClubName, Club.ClubId

--8. Which clubs have 3 or more students in them? Display the Club Names.
SELECT ClubName
FROM Activity RIGHT JOIN Club ON Activity.ClubId = Club.ClubId
GROUP BY ClubName, Club.ClubId
HAVING COUNT(StudentID) >= 3
