--Stored Procedure Exercise – Simple
--**Stored Procedure has to be the first statement in a batch so place GO in between each question to execute the previous batch (question) and start another. **
USE IQSchool
GO

--1.	Create a stored procedure called “HonorCourses” to select all the course names that have averages >80%. 
CREATE PROCEDURE HonorCourses AS

SELECT CourseName 
FROM Course
INNER JOIN Offering ON Course.CourseId = Offering.CourseID
INNER JOIN Registration ON Registration.OfferingCode = Offering.OfferingCode
GROUP BY Course.CourseId, CourseName
HAVING AVG(Mark) > 80

RETURN -- end of the sp
GO -- end of the batch

-- running this sp:
EXEC HonorCourses
GO

--2.	Create a stored procedure called “HonorCoursesOneTerm” to select all the course names that have average >80% in semester A100.

CREATE PROCEDURE HonorCoursesOneTerm AS

SELECT CourseName 
FROM Course
INNER JOIN Offering ON Course.CourseId = Offering.CourseID
INNER JOIN Registration ON Registration.OfferingCode = Offering.OfferingCode
WHERE SemesterCode = 'A100'
GROUP BY Course.CourseId, CourseName
HAVING AVG(Mark) > 80

RETURN -- end of the sp
GO -- end of the batch

--3.	Oops, made a mistake! For question 2, it should have been for semester A200. Write the code to change the procedure accordingly. 
ALTER PROCEDURE HonorCoursesOneTerm AS

SELECT CourseName 
FROM Course
INNER JOIN Offering ON Course.CourseId = Offering.CourseID
INNER JOIN Registration ON Registration.OfferingCode = Offering.OfferingCode
WHERE SemesterCode = 'A200'
GROUP BY Course.CourseId, CourseName
HAVING AVG(Mark) > 80

RETURN -- end of the sp
GO -- end of the batch


--4.	Create a stored procedure called “NotInDMIT221” that lists the full names of the staff that have not taught DMIT221.

CREATE PROCEDURE NotInDMIT221 AS

SELECT FirstName + ' ' + LastName AS FullName
FROM Staff
WHERE StaffID NOT IN (
	SELECT StaffID FROM Offering WHERE CourseID = 'DMIT221'
)

RETURN -- end of the SP
GO -- end of the batch

-- an alternate way to do the query is:

SELECT FirstName + ' ' + LastName AS FullName
FROM Staff
LEFT JOIN Offering ON Staff.StaffID = Offering.StaffID
	AND CourseID = 'DMIT221' -- bonus content!
WHERE Offering.StaffID IS NULL 

GO


--5.	Create a stored procedure called “LowNumbers” to select the course name of the course(s) that have had the lowest number of students in it. Assume all courses have registrations.



CREATE PROCEDURE LowNumbers AS

SELECT CourseName
	--, COUNT(*) AS NumberStudentRegistrations
FROM Course
INNER JOIN Offering ON Course.CourseId = Offering.CourseID
INNER JOIN Registration ON Offering.OfferingCode = Registration.OfferingCode
GROUP BY Course.CourseId, CourseName
HAVING COUNT(*) <= ALL (
	-- number of students per Course
	SELECT COUNT(*)
	FROM Registration
	INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
	GROUP  BY CourseID
)

RETURN
GO


--6.	Create a stored procedure called “Provinces” to list all the students provinces.

CREATE PROCEDURE Provinces
AS
SELECT DISTINCT Province
FROM Student

RETURN
GO

--7.	OK, question 6 was ridiculously simple and serves no purpose. Lets remove that stored procedure from the database.


DROP PROCEDURE Provinces
GO


--8.	Create a stored procedure called StudentPaymentTypes that lists all the student names and their payment type Description. Ensure all the student names are listed.

CREATE PROCEDURE StudentPaymentTypes
AS
SELECT DISTINCT FirstName + ' ' + LastName AS Student
	, PaymentTypeDescription
FROM Student
LEFT JOIN Payment ON Student.StudentID = Payment.StudentID
LEFT JOIN PaymentType ON PaymentType.PaymentTypeID = Payment.PaymentTypeID

RETURN
GO


--9.	Modify the procedure from question 8 to return only the student names that have made payments.
ALTER PROCEDURE StudentPaymentTypes
AS
SELECT DISTINCT FirstName + ' ' + LastName AS Student
FROM Student
INNER JOIN Payment ON Student.StudentID = Payment.StudentID
INNER JOIN PaymentType ON PaymentType.PaymentTypeID = Payment.PaymentTypeID

RETURN
GO
