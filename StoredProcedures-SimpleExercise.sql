--Stored Procedure Exercise – Simple
--**Stored Procedure has to be the first statement in a batch so place GO in between each question to execute the previous batch (question) and start another. **
USE IQSchool
GO

--1. Create a stored procedure called “HonorCourses” to select all the course names that have averages >80%. 

CREATE PROCEDURE HonorCourses AS

SELECT CourseName
FROM Course
INNER JOIN Offering ON Course.CourseId = Offering.CourseID
INNER JOIN Registration ON Offering.OfferingCode = Registration.OfferingCode
GROUP BY Course.CourseId, CourseName
HAVING AVG(Mark) > 80

RETURN
GO

--2. Create a stored procedure called “HonorCoursesOneTerm” to select all the course names that have average >80% in semester A100.
CREATE PROCEDURE HonorCoursesOneTerm AS

SELECT CourseName
FROM Course
INNER JOIN Offering ON Course.CourseId = Offering.CourseID
INNER JOIN Registration ON Offering.OfferingCode = Registration.OfferingCode
WHERE SemesterCode = 'A100'
GROUP BY Course.CourseId, CourseName
HAVING AVG(Mark) > 80

RETURN
GO

--3. Oops, made a mistake! For question 2, it should have been for semester A200. Write the code to change the procedure accordingly. 
ALTER PROCEDURE HonorCoursesOneTerm AS

SELECT CourseName
FROM Course
INNER JOIN Offering ON Course.CourseId = Offering.CourseID
INNER JOIN Registration ON Offering.OfferingCode = Registration.OfferingCode
WHERE SemesterCode = 'A200'
GROUP BY Course.CourseId, CourseName
HAVING AVG(Mark) > 80

RETURN
GO

--4. Create a stored procedure called “NotInDMIT221” that lists the full names of the staff that have not taught DMIT221.

-- select staff names
-- where staff name is NOT in a list o staff who HAVE taught DMIT221
CREATE PROCEDURE NotInDMIT221 AS

SELECT FirstName + ' ' + LastName AS FullName
FROM Staff
WHERE StaffID NOT IN (
	SELECT StaffID FROM Offering WHERE CourseID = 'DMIT221'
)

RETURN
GO

--5. Create a stored procedure called “LowNumbers” to select the course name of the course(s) that have had the lowest number of students in it. Assume all courses have registrations.

CREATE PROCEDURE LowNumbers AS

SELECT CourseName
	--, COUNT(StudentID) AS NumberOfStudents
FROM Course
INNER JOIN Offering ON Course.CourseID = Offering.CourseID
INNER JOIN Registration ON Offering.OfferingCode = Registration.OfferingCode
GROUP BY Course.CourseID, CourseName
HAVING COUNT(StudentID) <= ALL (
	SELECT COUNT(StudentID)
	FROM Registration
	INNER JOIN Offering ON Offering.OfferingCode = Registration.OfferingCode
	GROUP BY CourseID
)

RETURN -- end of SP
GO -- end of a batch

EXEC LowNumbers
GO

--6. Create a stored procedure called “Provinces” to list all the students provinces.

CREATE PROCEDURE Provinces AS
SELECT Province FROM Student
RETURN 
GO

--7. OK, question 6 was ridiculously simple and serves no purpose. Lets remove that stored procedure from the database.
DROP PROCEDURE Provinces
GO

--8. Create a stored procedure called StudentPaymentTypes that lists all the student names and their payment type Description. Ensure all the student names are listed.

CREATE PROCEDURE StudentPaymenTypes AS

SELECT FirstName, LastName, PaymentTypeDescription
FROM Student
LEFT JOIN Payment ON Student.StudentID = Payment.StudentID
LEFT JOIN PaymentType ON Payment.PaymentTypeID = PaymentType.PaymentTypeID

RETURN
GO

--9. Modify the procedure from question 8 to return only the student names that have made payments.


ALTER PROCEDURE StudentPaymenTypes AS

SELECT FirstName, LastName, PaymentTypeDescription
FROM Student
INNER JOIN Payment ON Student.StudentID = Payment.StudentID
INNER JOIN PaymentType ON Payment.PaymentTypeID = PaymentType.PaymentTypeID

RETURN
GO
