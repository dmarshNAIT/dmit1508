--Subquery Exercise
--Use the IQSchool database for this exercise. Each question must use a subquery in its solution.
USE IQSchool
GO

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
FROM Payment
INNER JOIN PaymentType ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
WHERE PaymentTypeDescription = 'Cash'


--2. Select The Student IDs of all the students that are in the 'Association of Computing Machinery' club


--3. Select All the staff full names that have taught a course.


--4. Select All the staff full names that taught DMIT172.


--5. Select All the staff full names that have never taught a course
-- outer query: Select staff names from Staff WHERE StaffID is NOT in the inner query
-- inner query: getting a list of staff IDs from Offering table

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
-- DO THIS ONE

--8. What is the total avg mark for the students from Edmonton?


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

