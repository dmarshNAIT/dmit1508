--Subquery Exercise
--Use the IQSchool database for this exercise. Each question must use a subquery in its solution.
--**If the questions could also be solved without a subquery, solve it without one as well**
USE IQSchool
GO


--1. Select the payment dates and payment amount for all payments that were Cash

SELECT PaymentDate, Amount
FROM Payment
WHERE PaymentTypeID IN (SELECT PaymentTypeID FROM PaymentType WHERE PaymentTypeDescription = 'Cash')

SELECT PaymentDate, Amount
FROM Payment
INNER JOIN PaymentType
	ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
WHERE PaymentTypeDescription = 'Cash'

--2. Select the Student ID's of all the students that are in the 'Association of Computing Machinery' club


SELECT StudentID
FROM Student
WHERE StudentID IN 
	(SELECT StudentID
	FROM Activity
	INNER JOIN Club ON Activity.ClubId = Club.ClubId
	WHERE Club.ClubName = 'Association of Computing Machinery')

SELECT Student.StudentID
FROM Student
INNER JOIN Activity		ON Student.StudentID = Activity.StudentID
INNER JOIN Club			ON Activity.ClubId = Club.ClubId
WHERE Club.ClubName = 'Association of Computing Machinery'


--3. Select All the staff full names that have taught a course.

SELECT FirstName + ' ' + LastName AS FullName
FROM Staff
WHERE StaffID IN (SELECT StaffID FROM Offering)

SELECT DISTINCT FirstName + ' ' + LastName AS FullName
FROM Staff
INNER JOIN Offering ON Staff.StaffID = Offering.StaffID

--4. Select All the staff full names that taught ANAP1525.

SELECT CONCAT(FirstName, ' ' , LastName) AS StaffName
FROM Staff
WHERE StaffID IN (
	SELECT StaffID 
	FROM Offering
	WHERE CourseID = 'ANAP1525'
)

SELECT CONCAT(FirstName, ' ' , LastName) AS StaffName
FROM Staff
INNER JOIN Offering ON Staff.StaffID  = Offering.StaffID
WHERE CourseID = 'ANAP1525'

--5. Select All the staff full names that have never taught a course
SELECT FirstName + ' ' + LastName AS FullName
FROM Staff
WHERE StaffID NOT IN (SELECT StaffID FROM Offering)

SELECT DISTINCT FirstName + ' ' + LastName AS FullName
FROM Staff
LEFT JOIN Offering ON Staff.StaffID = Offering.StaffID
WHERE Offering.StaffID IS NULL -- where there is no matching record in Offering table

--6. Select the Payment TypeID(s) that have the highest number of Payments made.
SELECT PaymentTypeID
--, COUNT(*) AS NumberPayments -- uncommenting this line makes it a bit easier to test
FROM Payment
GROUP BY PaymentTypeID
HAVING COUNT(*) >= ALL (SELECT COUNT(*) AS NumberPayments
				FROM Payment
				GROUP BY PaymentTypeID)

--7. Select the Payment Type Description(s) that have the highest number of Payments made.
SELECT PaymentTypeDescription
--, COUNT(*) AS NumberPayments -- uncommenting this line makes it a bit easier to test
FROM Payment 
INNER JOIN PaymentType ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
GROUP BY Payment.PaymentTypeID, PaymentTypeDescription
HAVING COUNT(*) >= ALL (SELECT COUNT(*) AS NumberPayments
				FROM Payment
				GROUP BY PaymentTypeID)

--8. What is the total avg mark for the students from Edmonton?
SELECT Avg(Mark) AS AverageMark
FROM Registration
WHERE StudentID IN (SELECT DISTINCT StudentID FROM Student WHERE City = 'Edmonton')

SELECT Avg(Mark) AS AverageMark
FROM Registration
INNER JOIN Student ON Student.StudentID = Registration.StudentID
WHERE City = 'Edmonton'

--9. What is the avg mark for each of the students from Edmonton? Display their StudentID and avg(mark)
SELECT StudentID
	, Avg(Mark) AS AverageMark
FROM Registration
WHERE StudentID IN (SELECT DISTINCT StudentID FROM Student WHERE City = 'Edmonton')
GROUP BY StudentID

SELECT Student.StudentID
	, Avg(Mark) AS AverageMark
FROM Registration
INNER JOIN Student ON Student.StudentID = Registration.StudentID
WHERE City = 'Edmonton'
GROUP BY Student.StudentID



