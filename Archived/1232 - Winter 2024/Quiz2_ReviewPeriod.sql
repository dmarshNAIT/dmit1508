-- Quiz 2 Prep

-- WITHOUT using a JOIN,
-- tell me how many staff are NOT instructors
-- SELECT the # of staff

SELECT COUNT(StaffID) AS NumStaff
FROM Staff
WHERE PositionID <>
-- or PositionID !=
-- or PositionID NOT IN
	-- a list of positions that ARE instructors
	( SELECT PositionID 
		FROM Position 
		WHERE PositionDescription = 'Instructor')

SELECT COUNT(StaffID) AS NumStuff
FROM Staff
WHERE PositionID IN (
	-- a list of all the positions EXCEPT instructor
		SELECT PositionID 
		FROM Position 
		WHERE PositionDescription != 'Instructor'
)

-- how many payment types have never been used?
SELECT COUNT(*) AS NumPaymentTypes
FROM PaymentType
WHERE PaymentTypeID NOT IN
(
	SELECT PaymentTypeID
	FROM Payment
)

-- how many students were born in each month? (months with no births can be left out). SELECT the month NAME and the # of students.
-- bonus challenge: sort the months in chronological order
SELECT DateName(month, Birthdate) AS Month,
	COUNT(*) AS NumStudents,
	COUNT(StudentID) AS NumStudents
FROM Student
GROUP BY DateName(month, Birthdate)

-- and with the bonus challenge:
SELECT DateName(month, Birthdate) AS Month,
	COUNT(*) AS NumStudents
FROM Student
GROUP BY DateName(month, Birthdate), MONTH(Birthdate)
ORDER BY MONTH(Birthdate)

-- list the full names of staff members that have had a student withdraw.
-- make sure we aren't double-listing anyone!
SELECT DISTINCT FirstName + ' ' + LastName AS StaffName
	, CONCAT(FirstName, ' ', LastName) AS StaffNameV2
FROM Staff
INNER JOIN Offering ON Staff.StaffID = Offering.StaffID
INNER JOIN Registration ON Offering.OfferingCode = Registration.OfferingCode
WHERE Registration.WithdrawYN = 'Y'

-- what is the length of the longest last name out of all the students from Edmonton?
SELECT MAX(LEN(LastName)) AS LongestLastNameLength
FROM Student
WHERE City = 'Edmonton'

-- for every student in our database:
-- show me the 2nd character of their postal code
SELECT StudentID
	, PostalCode
	, Substring(PostalCode, 2, 1) AS UrbanRuralIndicator
	-- starting at position 2, get 1 character
	, Substring(PostalCode, 1, 3) AS FSA
	-- starting at position 1, get 3 chars
FROM Student


-- how many students live in each FSA? 
-- SELECT the first 3 chars of the postal code, and the # of students


-- list all the course names that have a number somewhere in the course name



-- CHALLENGE Q: 
-- what is the offering code of the course with the most withdraws?