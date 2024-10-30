--Inner Joins with Aggregates Exercises
USE IQSchool
GO

--1. How many staff are there in each position? Select the number and Position Description.
--2. Select the average mark for each course. Display the CourseName and the average mark.
SELECT CourseName, AVG(Mark) AS AverageMark
FROM Registration
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
INNER JOIN Course ON Offering.CourseId = Course.CourseId
GROUP BY Course.CourseId, Course.CourseName
-- we have to group by CourseID as that uniquely differentiates courses
-- we have to group by CourseName as we are SELECTing but not aggregating it

--3. How many payments where made for each payment type. Display the
--PaymentTypeDescription and the count.
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
	, MAX(Amount) AS HighestAmount
	, MIN(Amount) AS LowestAmount
	, AVG(Amount) AS AverageAmount
FROM PaymentType
INNER JOIN Payment ON PaymentType.PaymentTypeID = Payment.PaymentTypeID
GROUP BY PaymentType.PaymentTypeID, PaymentTypeDescription


--7. How many students are there in each club? Show the clubName and the count.
SELECT ClubName
	, COUNT(StudentID) AS NumberStudents
FROM Club
INNER JOIN Activity ON Club.ClubId = Activity.ClubId
GROUP BY Club.ClubID, ClubName

--8. Which clubs have 3 or more students in them? Display the Club Names.