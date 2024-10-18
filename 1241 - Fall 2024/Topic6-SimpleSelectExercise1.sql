--SIMPLE SELECT EXERCISE 1
--USE THE IQSCHOOL DATABASE
USE IQSchool
GO
-- see the following URL for the full solution
-- https://github.com/dmarshNAIT/dmit1508/blob/main/Archived/1232%20-%20Winter%202024/SELECT_SimpleSelectExercise1.sql

--1. Select all the information from the club table
SELECT ClubID, ClubName
FROM Club

--2. Select the FirstNames and LastNames of all the students
SELECT FirstName, LastName
FROM Student

--3. Select all the CourseId and CourseName of all the courses. Use the column aliases of Course ID and Course Name
SELECT CourseID AS 'Course ID'
	, [Course Name] = CourseName
FROM Course
-- 2 different styles, either use AS or use the =
-- 2 different punctuation, either use ' or [] or ""

--4. Select all the course information for courseID 'DMIT1001'
SELECT CourseID, CourseName, CourseHours, MaxStudents, CourseCost
FROM Course
WHERE CourseID = 'DMIT1001'

SELECT CourseID, CourseName, CourseHours, MaxStudents, CourseCost
FROM Course
WHERE CourseID LIKE 'DMIT1001'

SELECT CourseID, CourseName, CourseHours, MaxStudents, CourseCost
FROM Course
WHERE CourseID IN ('DMIT1001')

--5. Select the Staff names who have positionID of 3
--6. select the CourseNames whos CourseHours are less than 96
--7. Select the studentIDs, OfferingCode and mark where the Mark is between 70 and 80
--8. Select the studentIDs, Offering Code and mark where the Mark is between 70 and 80 and the OfferingCode is 1001 or 1009
SELECT StudentID, OfferingCode, Mark
FROM Registration
WHERE Mark BETWEEN 70 AND 80
	AND (OfferingCode = 1001 OR OfferingCode = 1009)

SELECT StudentID, OfferingCode, Mark
FROM Registration
WHERE Mark BETWEEN 70 AND 80
	AND OfferingCode IN (1001, 1009)
	-- where offering code is one of the following values

-- this condition also works:
 --WHERE (Mark >= 70 AND Mark <= 80)

--9. Select the students first and last names who have last names starting with S
--10. Select Coursenames whose CourseID have a 1 as the fifth character
SELECT CourseName
FROM Course
WHERE CourseID LIKE '____1%'

--11. Select the CourseIDs and Coursenames where the CourseName contains the word 'programming'
SELECT CourseID, CourseName
FROM Course
WHERE CourseName LIKE '%programming%'

--12. Select all the ClubNames who start with N or C.
--13. Select Student Names, Street Address and City where the LastName is only 3 letters long.
--14. Select all the StudentID's where the PaymentAmount < 500 OR the PaymentTypeID is 5