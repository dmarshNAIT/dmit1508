--Stored Procedure Exercise – Parameters
--**Stored Procedure has to be the first statement in a batch so place GO in between each question to execute the previous batch (question) and start another. 

-- NOTE: all parameters are required. Raise an error message if a parameter is not passed to the procedure.
USE IQSchool
GO

--1. Create a stored procedure called “GoodCourses” to select all the course names that have averages  greater than a given value. 
DROP PROCEDURE IF EXISTS GoodCourses
GO

CREATE PROCEDURE GoodCourses (@GoodMark DECIMAL(5,2) = NULL)
AS
-- check if my param is null. if so, RAISERROR
IF @GoodMark IS NULL
	BEGIN
	RAISERROR('Oh no! Missing parameter!', 16, 1)
	END
-- otherwise: SELECT CourseName HAVING Avg > param
ELSE 
	BEGIN
	
	SELECT CourseName
	FROM Course
	INNER JOIN Offering ON Course.CourseId = Offering.CourseId
	INNER JOIN Registration ON Offering.OfferingCode = Registration.OfferingCode
	GROUP BY CourseName, Course.CourseId
	HAVING AVG(Mark) > @GoodMark

	END

RETURN -- marks the end of the SP
GO -- marks the end of the batch

--2. Create a stored procedure called “HonorCoursesForOneTerm” to select all the course names that have average > a given value in a given semester.
-- *can check parameters in one conditional expression and a common message printed if any of them are missing*
DROP PROCEDURE IF EXISTS HonorCoursesForOneTerm
GO

CREATE PROCEDURE HonorCoursesForOneTerm (
					@MinAvg DECIMAL(5,2) = NULL
					, @Semester CHAR(5) = NULL) 
AS
-- if any params are missing, raise an error
IF @MinAvg IS NULL OR @Semester IS NULL
	BEGIN
	PRINT 'Sorry, you are missing parameter(s)'
	END
ELSE
	BEGIN
	-- otherwise, SELECT CourseName matching these 2 filters
	SELECT CourseName
	FROM Registration
	RIGHT JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
	RIGHT JOIN Course ON Offering.CourseId = Course.CourseId
	WHERE Offering.SemesterCode = @Semester
	GROUP BY Course.CourseID, CourseName
	HAVING AVG(Mark) > @MinAvg
	END
RETURN
GO

-- test once w/o params:
EXEC HonorCoursesForOneTerm
-- test once with just 1 param:
EXEC HonorCoursesForOneTerm 80
-- test once with good params:
EXEC HonorCoursesForOneTerm 80, 'A100'


--3. Create a stored procedure called “NotInACourse” that lists the full names of the staff that are not taught a given courseID.

DROP PROCEDURE IF EXISTS NotInACourse
GO

CREATE PROCEDURE NotInACourse (@CourseID CHAR(8) = NULL)
AS

-- check for missing params. raiserror if so
IF @CourseID IS NULL
	BEGIN
	RAISERROR('Course ID is required.', 16, 1)
	END

-- SELECT the full name of staff who haven't taught that course
ELSE 
	BEGIN

	SELECT FirstName, LastName, StaffID
	FROM Staff
	WHERE StaffID NOT IN ( -- where staff aren't in the list of staff who HAVE taught the course
		SELECT StaffID 
		FROM Offering
		WHERE CourseID = @CourseID
	)
	END

RETURN
GO

--4. Create a stored procedure called “LowCourses” to select the course name of the course(s) that have had less than a given number of students in them.

CREATE PROCEDURE LowCourses (@NumStudents INT = NULL) AS

IF @NumStudents IS NULL
	BEGIN
	PRINT 'Missing parameter'
	END
ELSE
	BEGIN

	SELECT CourseName
	FROM Course
	LEFT JOIN Offering on Course.CourseId = Offering.CourseID
	LEFT JOIN Registration ON Offering.OfferingCode = Registration.OfferingCode
	GROUP BY Course.CourseId, CourseName
	HAVING COUNT(Registration.StudentID) < @NumStudents

	END

RETURN
GO

--5. Create a stored procedure called “ListaProvince” to list all the students names that are in a given province.
CREATE PROCEDURE ListAProvince (@Province CHAR(2) = NULL) AS

IF @Province IS NULL
	BEGIN
	PRINT 'Missing parameter'
	END
ELSE
	BEGIN

	SELECT FirstName, LastName
	FROM Student
	WHERE Province = @Province

	END

RETURN
GO

--6. Create a stored procedure called “transcript” to select the transcript for a given studentID. Select the StudentID, full name, course IDs, course names, and marks.
CREATE PROCEDURE Transcript (@StudentID INT = NULL)
AS

IF @StudentID IS NULL
	BEGIN
	PRINT 'Missing parameter'
	END
ELSE
	BEGIN

	SELECT Student.StudentID
		, Student.FirstName + ' ' + Student.LastName AS FullName
		, Course.CourseId
		, Course.CourseName
		, Registration.Mark
	FROM Student
	LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
	LEFT JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
	LEFT JOIN Course ON Offering.CourseId = Course.CourseId
	WHERE Student.StudentID = @StudentID

	END

RETURN 
GO

-- test once without params:
EXEC Transcript
-- test once with good params:
EXEC Transcript 199899200
-- test with a student with NO registrations
EXEC Transcript 198933540

GO

--7. Create a stored procedure called “PaymentTypeCount” to select the count of payments made for a given payment type description. 
CREATE PROCEDURE PaymentTypeCount (@PaymentTypeDesc VARCHAR(40) = NULL)
AS

-- if no param was provided, show an error message
IF @PaymentTypeDesc IS NULL
	BEGIN
	PRINT 'Missing param'
	END
ELSE
	BEGIN
	-- otherwise, SELECT COUNT of payments for that description
	SELECT COUNT(PaymentID) AS NumPayments
	FROM Payment
	RIGHT JOIN PaymentType ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
	WHERE PaymentTypeDescription = @PaymentTypeDesc

	END
RETURN
GO

-- test w/o param:
EXEC PaymentTypeCount

-- test with payment type used at least once:
EXEC PaymentTypeCount 'Cheque'

-- test with unused payment type
EXEC PaymentTypeCount 'Bitcoin'
GO
--8. Create stored procedure called “Class List” to select student Full names that are in a course for a given semesterCode and Coursename.

CREATE PROCEDURE ClassList (@SemesterCode CHAR(5) = NULL, @CourseName VARCHAR(40) = NULL) AS

-- check params aren't missing
IF @SemesterCode IS NULL OR @CourseName IS NULL
	BEGIN
	RAISERROR('Missing parameter(s)', 16, 1)
	END
ELSE
	BEGIN
	SELECT FirstName + ' ' + LastName AS StudentName
	FROM Student
	INNER JOIN Registration ON Student.StudentID = Registration.StudentID
	INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
	INNER JOIN Course ON Offering.CourseID = Course.CourseId
	WHERE SemesterCode = @SemesterCode 
		AND CourseName = @CourseName 
	END

RETURN
GO

