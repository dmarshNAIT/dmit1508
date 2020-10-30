--Author: Dana Marsh
--Subquery Exercise
--Use the IQSchool database for this exercise. Each question must use a subquery in its solution.
--**If the questions could also be solved without a subquery, solve it without one as well**

--1. Select the Payment dates and payment amount for all payments that were Cash
SELECT PaymentDate, Amount
FROM Payment
WHERE PaymentTypeID IN (
	SELECT PaymentTypeID	
	FROM PaymentType
	WHERE PaymentTypeDescription = 'Cash'
)

SELECT PaymentDate, Amount
FROM Payment
INNER JOIN PaymentType ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
WHERE PaymentTypeDescription = 'Cash'

--2. Select The Student IDs of all the students that are in the 'Association of Computing Machinery' club
SELECT StudentID
FROM Activity
WHERE ClubID = (
			SELECT ClubID
			FROM Club
			WHERE ClubName = 'Association of Computing Machinery'
)

SELECT StudentID
FROM Activity
INNER JOIN Club on Activity.ClubId = Club.ClubId
WHERE ClubName = 'Association of Computing Machinery'


--3. Select All the staff full names that have taught a course.
SELECT FirstName + ' ' + LastName AS StaffName
FROM Staff
WHERE StaffID IN (
	SELECT StaffID
	FROM Offering
) -- where that staffID exists in the Offering table

SELECT DISTINCT FirstName + ' ' + LastName AS StaffName
FROM Staff
INNER JOIN Offering ON Staff.StaffID = Offering.StaffID


--4. Select All the staff full names that taught DMIT172.


--5. Select All the staff full names that have never taught a course


--6. Select the Payment TypeID(s) that have the highest number of Payments made.


--7. Select the Payment Type Description(s) that have the highest number of Payments made.


--8. What is the total avg mark for the students from Edmonton?


--9. What is the avg mark for each of the students from Edmonton? Display their StudentID and avg(mark)



