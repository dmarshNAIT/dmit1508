--Stored Procedure Exercise – Parameters
--**Stored Procedure has to be the first statement in a batch, so place Go in between each question to
--execute the previous batch (question) and start another. NOTE: all parameters are required. Raise an
--error message if a parameter is not passed to the procedure.
USE IQSchool
GO


--1. Create a stored procedure called “GoodCourses” to select all the course names that have
--averages greater than a given value.
--2. Create a stored procedure called “HonorCoursesForOneTerm” to select all the course names
--that have average > a given value in a given semester. *You can check all parameters in one
--conditional expression and a common message printed if any of them are missing*
--3. Create a stored procedure called “NotInACourse” that lists the full names of the staff that have not taught a given CourseID.
DROP PROCEDURE IF EXISTS NotInACourse
GO

CREATE PROCEDURE NotInACourse (@CourseID CHAR(8) = NULL) AS

IF @CourseID IS NULL -- if the parameter is missing
	RAISERROR('Missing CourseID!', 16, 1)
ELSE

	SELECT FirstName + ' ' + LastName AS LastName
	FROM Staff
	WHERE StaffID NOT IN (
		SELECT StaffID 
		FROM Offering
		WHERE CourseID = @CourseID
	)

	--SELECT FirstName, LastName
	--FROM Staff
	--LEFT JOIN Offering ON Staff.StaffID = Offering.StaffID
	--	AND Offering.CourseId = @CourseID
	--WHERE Offering.StaffID IS NULL

RETURN
GO

-- testing time!
EXEC NotInACourse
EXEC NotInACourse 'DMIT1508' 	-- staffID 6 is the only person who has taught 1508


--4. Create a stored procedure called “LowCourses” to select the course name of the course(s) that have had less than a given number of students in them.

--5. Create a stored procedure called “ListaProvince” to list all the student’s names that are in a given province.
DROP PROCEDURE IF EXISTS ListAProvince
GO

CREATE PROCEDURE ListAProvince (@Province CHAR(2) = NULL) AS

IF @Province IS NULL
	RAISERROR('Missing parameter!', 16, 1)
ELSE
	SELECT FirstName, LastName FROM Student WHERE Student.Province = @Province

RETURN -- ends the SP

GO -- ends the batch

-- first, let's test without parameters
EXEC ListAProvince
-- now let's test with a valid parameter
EXEC ListAProvince 'AB'
EXEC ListAProvince 'BC'
EXEC ListAProvince 'NS'

--6. Create a stored procedure called “Transcript” to select the transcript for a given StudentID.
--Select the StudentID, full name, course IDs, course names, and marks.

--7. Create a stored procedure called “PaymentTypeCount” to select the count of payments made for a given payment type description.

GO
DROP PROCEDURE IF EXISTS PaymentTypeCount
GO

CREATE PROCEDURE PaymentTypeCount (@PaymentType VARCHAR(40) = NULL) AS

IF @PaymentType IS NULL
	RAISERROR('Payment Type is required', 16, 1)
ELSE
	SELECT COUNT(PaymentID) AS NumberPayments
	FROM Payment
	RIGHT JOIN PaymentType AS pt ON Payment.PaymentTypeID = pt.PaymentTypeID
	WHERE PaymentTypeDescription = @PaymentType

RETURN
GO

-- TEST!
EXEC PaymentTypeCount
EXEC PaymentTypeCount 'Cash'
EXEC PaymentTypeCount 'Bananas'

--8. Create stored procedure called “Class List” to select student Full names that are in a course for a given SemesterCode and CourseName.