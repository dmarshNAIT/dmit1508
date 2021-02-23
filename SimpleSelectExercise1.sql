--SIMPLE SELECT EXERCISE 1
--USE THE IQSCHOOL DATABASE 
USE IQSchool
GO

--1.  Select all the information from the club table
SELECT ClubId, ClubName
FROM Club

--2. Select the FirstNames and LastNames of all the students
SELECT FirstName, LastName 
FROM Student

--3. Select the CourseId and CourseName of all the courses. Use the column aliases of Course ID and Course Name
SELECT CourseID AS 'Course ID'
	, CourseName AS [Course Name] 
			-- either punctuation is fine, just be consistent
FROM Course

--4. Select all the course information for courseID 'DMIT101'
SELECT CourseId, CourseName, CourseHours, MaxStudents, CourseCost
FROM Course
WHERE CourseId = 'DMIT101'

--5. Select the Staff names who have positionID of 3
SELECT FirstName + ' ' + LastName AS StaffName
FROM Staff
WHERE PositionID = 3

--6. select the CourseNames whose CourseHours are less than 96
SELECT CourseName
FROM Course
WHERE CourseHours < 96

--7. Select the studentIDs, OfferingCode and mark where the Mark is between 70 and 80
SELECT StudentID, OfferingCode, Mark
FROM Registration 
WHERE Mark BETWEEN 70 AND 80
-- OR
-- WHERE Mark >= 70 AND Mark <= 80
-- WHERE Mark <= 80 AND Mark >= 70

--8. Select the studentIDs, Offering Code and mark where the Mark is between 70 and 80 and the OfferingCode is 1001 or 1009
SELECT StudentID, OfferingCode, Mark
FROM Registration 
WHERE Mark BETWEEN 70 AND 80
	AND OfferingCode IN (1001, 1009)

--9. Select the students first and last names who have last names starting with S
SELECT FirstName, LastName
FROM Student
WHERE LastName LIKE 'S%'

--10. Select Coursenames whose CourseID  have a 1 as the fifth character
SELECT CourseName
	--, CourseID -- for testing purposes
FROM Course
WHERE CourseID LIKE '____1%'

--11. Select the CourseIDs and Coursenames where the CourseName contains the word 'programming'
SELECT CourseId, CourseName
FROM Course
WHERE CourseName LIKE '%progamming%'

--12. Select all the ClubNames who start with N or C.
SELECT ClubName
FROM Club
WHERE ClubName LIKE '[NC]%'
--OR
SELECT ClubName
FROM Club
WHERE ClubName LIKE 'N%' OR ClubName LIKE 'C%'

--13. Select Student Names, Street Address and City where the lastName has only 3 letters long.
SELECT FirstName + ' ' + LastName AS FullName
	, StreetAddress
	, City
FROM Student
WHERE LastName LIKE '___'

--14. Select all the StudentIDs where the PaymentAmount < 500 OR the PaymentTypeID is 5
SELECT StudentID
FROM Payment
WHERE Amount < 500 
	OR PaymentTypeID = 5
