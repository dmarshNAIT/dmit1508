--Stored Procedure Exercise – Simple
USE IQSchool
GO
--**Create or Alter Procedure has to be the first statement in a batch so place Go in between each question to execute the previous batch (question) and start another. **

--1. Create a stored procedure called “HonorCourses” to select all the course names that have averages >80%.
DROP PROCEDURE IF EXISTS HonorCourses
GO

CREATE PROCEDURE HonorCourses AS

SELECT CourseName
FROM Course
INNER JOIN Offering ON Course.CourseId = Offering.CourseId
INNER JOIN Registration ON Offering.OfferingCode = Registration.OfferingCode
GROUP BY CourseName, Course.CourseId
HAVING AVG(Mark) > 80

RETURN -- this is the end of the SP
GO -- this is the end of the batch

-- how to execute this SP:
EXEC HonorCourses
-- how to see the definition of this SP:
EXEC sp_helptext HonorCourses

GO

--2. Create a stored procedure called “HonorCoursesOneTerm” to select all the course names that
--have average >80% in semester A100.
--3. Oops, made a mistake! For question 2, it should have been for semester A200. Write the code to
--change the procedure accordingly.

--4. Create a stored procedure called “NotInCOMP1017” that lists the full names of the staff that
--have not taught COMP1017.
-- EDIT: use DMIT 1508 instead

CREATE PROCEDURE NotInDMIT1508 AS

SELECT FirstName + ' ' + LastName AS FullName
FROM Staff
-- where the staff isn't in the list of DMIT 1508 instructors
WHERE StaffID NOT IN (
	SELECT StaffID
	FROM Offering
	WHERE CourseID = 'DMIT1508'
)

-- Staff ID 6 has taught this course, but no one else
-- 10 staff members at this school
-- that means I should see 9 staff members if I did this correctly

RETURN



--5. Create a stored procedure called “LowNumbers” to select the course name of the course(s) that
--have had the lowest number of students in it. Assume all courses have registrations.

CREATE PROCEDURE LowNumbers AS

-- see the course names that have a student count less than or equal to the count of all the other courses

SELECT Course.CourseName
FROM Offering
INNER JOIN Registration ON Offering.OfferingCode = Registration.OfferingCode
INNER JOIN Course ON Offering.CourseId = Course.CourseId
GROUP BY Course.CourseID, Course.CourseName
HAVING COUNT(StudentID) <= ALL (
-- the outer query gives me the count of ALL the courses, 
-- we add the HAVING to filter out everything except the ones whose count is the smallest
-- we do this by comparing it to ALL the other counts
	SELECT COUNT(StudentID)
	FROM Offering
	INNER JOIN Registration ON Offering.OfferingCode = Registration.OfferingCode
	GROUP BY CourseID
)

RETURN -- end of the SP
GO -- end of the batch

-- let's run this
EXEC LowNumbers

GO

--6. Create a stored procedure called “Provinces” to list all the student’s provinces.

CREATE PROCEDURE Provinces AS

SELECT Province
FROM Student

RETURN

GO
--7. OK, question 6 was ridiculously simple and serves no purpose. Remove that stored procedure
--from the database.

DROP PROCEDURE Provinces
GO

--8. Create a stored procedure called “StudentPaymentTypes” that lists all the student names and
--their payment type Description. Ensure all the student names are listed.
--9. Modify the procedure from question 8 to return only the student names that have made
--payments.