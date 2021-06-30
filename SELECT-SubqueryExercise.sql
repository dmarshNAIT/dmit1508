--Subquery Exercise
--Use the IQSchool database for this exercise. Each question must use a subquery in its solution.
USE IQSchool

--**If the questions could also be solved without a subquery, solve it without one as well**

--1. Select the Payment dates and payment amount for all payments that were Cash
SELECT PaymentDate, Amount
FROM Payment
WHERE PaymentTypeID = (
	SELECT PaymentTypeID
	FROM PaymentType
	WHERE PaymentTypeDescription = 'Cash'
)

SELECT PaymentDate, Amount
FROM PaymentType
INNER JOIN Payment ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
WHERE PaymentTypeDescription = 'Cash'


--2. Select The Student IDs of all the students that are in the 'Association of Computing Machinery' club

SELECT StudentID
FROM Activity
WHERE ClubId IN (SELECT ClubId FROM Club WHERE ClubName = 'Association of Computing Machinery')

SELECT StudentID
FROM Activity
INNER JOIN Club ON Activity.ClubId = Club.ClubId
WHERE ClubName = 'Association of Computing Machinery'


--3. Select All the staff full names that have taught a course.
SELECT FirstName + ' ' + LastName AS FullName
FROM Staff
WHERE StaffID IN (SELECT StaffID FROM Offering)

SELECT DISTINCT FirstName + ' ' + LastName AS FullName
FROM Staff
INNER JOIN Offering ON Staff.StaffID = Offering.StaffID

--4. Select All the staff full names that taught DMIT172.
SELECT FirstName + ' ' + LastName AS FullName
FROM Staff
WHERE StaffID IN (SELECT StaffID FROM Offering WHERE CourseID = 'DMIT172')

SELECT DISTINCT FirstName + ' ' + LastName AS FullName
FROM Staff
INNER JOIN Offering ON Staff.StaffID = Offering.StaffID
WHERE CourseID = 'DMIT172'

--5. Select All the staff full names that have never taught a course
SELECT FirstName + ' ' + LastName AS StaffName
FROM Staff
WHERE StaffID NOT IN (SELECT StaffID FROM Offering)

SELECT FirstName + ' ' + LastName AS StaffName
FROM Staff
LEFT JOIN Offering on Staff.StaffID = Offering.StaffID
WHERE Offering.StaffID IS NULL


--6. Select the Payment TypeID(s) that have the highest number of Payments made.
SELECT PaymentTypeID
FROM Payment
GROUP BY PaymentTypeID
HAVING COUNT(*) >= ALL (
		SELECT COUNT(*)
		FROM Payment
		GROUP BY PaymentTypeID
)

--7. Select the Payment Type Description(s) that have the highest number of Payments made.
SELECT PaymentTypeDescription
FROM Payment
INNER JOIN PaymentType ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
GROUP BY PaymentType.PaymentTypeID, PaymentTypeDescription
HAVING COUNT(*) >= ALL (
		SELECT COUNT(*)
		FROM Payment
		GROUP BY PaymentTypeID
)

--8. What is the total avg mark for the students from Edmonton?
SELECT Avg(Mark) AS AverageMark
FROM Registration
WHERE StudentID IN ( -- the list of students from Edmonton
	SELECT StudentID FROM Student WHERE City = 'Edmonton'
)

SELECT Avg(Mark) AS AverageMark
FROM Registration
INNER JOIN Student ON Registration.StudentID = Student.StudentID
WHERE City = 'Edmonton'

-- usin an alias for a table
SELECT Reg.StudentID
FROM Registration AS Reg
INNER JOIN Student ON Reg.StudentID = Student.StudentID

--9. What is the avg mark for each of the students from Edmonton? Display their StudentID and avg(mark)
SELECT StudentID, AVG(Mark) AS AverageMark
FROM Registration
WHERE StudentID IN (
	SELECT StudentID FROM Student WHERE City = 'Edmonton'
)
GROUP BY StudentID

SELECT Student.StudentID, AVG(Mark) AS AverageMark
FROM Registration
INNER JOIN Student on Registration.StudentID = Student.StudentID
WHERE City = 'Edmonton'
GROUP BY Student.StudentID


