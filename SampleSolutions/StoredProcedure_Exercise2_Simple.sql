--Stored Procedure Exercise – Simple
USE IQSchool
GO

--**Stored Procedure has to be the first statement in a batch so place GO in between each question to execute the previous batch (question) and start another. **
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
-- EDIT: using DMIT 1508 instead

CREATE PROCEDURE NotInDMIT221
AS

SELECT FirstName + ' ' + LastName AS FullName
FROM Staff
WHERE Staff.StaffID NOT IN
-- but don't include Staff who have taught DMIT 1508
	(SELECT StaffID
	FROM Offering
	WHERE CourseID = 'DMIT1508')

RETURN -- the end of our SP

GO

EXEC NotInDMIT221

GO

--5. Create a stored procedure called “LowNumbers” to select the course name of the course(s) that have had the lowest number of students in it. Assume all courses have registrations.
CREATE PROCEDURE LowNumbers
AS

-- select course name
SELECT CourseName
FROM Registration
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
INNER JOIN Course ON Offering.CourseId = Course.CourseId
GROUP BY Course.CourseId, Course.CourseName
HAVING COUNT(StudentID) <= ALL
-- filter: only want courses having a count <= ALL the other course counts
	(	SELECT COUNT(StudentID)
		FROM Registration
		INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
		GROUP BY CourseID
	)

RETURN

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
CREATE PROCEDURE StudentPaymentTypes
AS

-- select student names, payment type descriptions
SELECT FirstName + ' ' + LastName AS StudentName
	, PaymentTypeDescription
FROM Student
LEFT JOIN Payment ON Student.StudentID = Payment.StudentID
LEFT JOIN PaymentType ON Payment.PaymentTypeID = PaymentType.PaymentTypeID

RETURN
GO

--9. Modify the procedure from question 8 to return only the student names that have made payments.

ALTER PROCEDURE StudentPaymentTypes
AS

-- select student names, payment type descriptions
SELECT FirstName + ' ' + LastName AS StudentName
	, PaymentTypeDescription
FROM Student
INNER JOIN Payment ON Student.StudentID = Payment.StudentID
INNER JOIN PaymentType ON Payment.PaymentTypeID = PaymentType.PaymentTypeID

RETURN
GO