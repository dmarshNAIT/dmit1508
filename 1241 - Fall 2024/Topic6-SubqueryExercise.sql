--Subquery Exercise
--Use the IQSchool database for this exercise. Each question must use a subquery in its solution.
--**If the questions could also be solved without a subquery, solve it without one as well**
USE IQSchool
GO

--1. Select the payment dates and payment amount for all payments that were Cash
--2. Select the Student IDs of all the students that are in the 'Association of Computing Machinery' club
SELECT StudentID
FROM Activity
WHERE ClubId IN (
	SELECT ClubID
	FROM Club	
	WHERE ClubName = 'Association of Computing Machinery'
)


-- could also solve with a plain old JOIN


--3. Select All the staff full names that have taught a course.
--4. Select All the staff full names that taught ANAP1525.
--5. Select All the staff full names that have never taught a course
SELECT FirstName + ' ' + LastName AS FullName
	--, Staff.StaffID
	--, Offering.StaffID
FROM Offering
RIGHT JOIN Staff ON Offering.StaffID = Staff.StaffID
WHERE Offering.StaffID IS NULL -- = will not work , because NULL has no value

SELECT FirstName + ' ' + LastName AS FullName
FROM Staff
WHERE StaffID NOT IN (SELECT StaffID FROM Offering)

--6. Select the Payment TypeID(s) that have the highest number of Payments made.
--7. Select the Payment Type Description(s) that have the highest number of Payments made.
--8. What is the total avg mark for the students from Edmonton?
--9. What is the avg mark for each of the students from Edmonton? Display their StudentID and avg(mark)