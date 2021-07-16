--Stored Procedure Exercise – Parameters
--**Stored Procedure has to be the first statement in a batch so place GO in between each question to execute the previous batch (question) and start another. NOTE: all parameters are required. Raise an error message if a parameter is not passed to the procedure.
USE IQSchool
GO

--1.	Create a stored procedure called “GoodCourses” to select all the course names that have averages  greater than a given value. 
CREATE PROCEDURE GoodCourses (@AvgThreshold DECIMAL(5,2) = NULL) AS

-- first, check to see if a param was provided:
IF @AvgThreshold IS NULL 
	BEGIN
	PRINT 'Missing parameter!'
	END
ELSE -- this means a parameter WAS provided:
	BEGIN

	SELECT CourseName
	FROM Course
	INNER JOIN Offering ON Course.CourseId = Offering.CourseID
	INNER JOIN Registration ON Registration.OfferingCode = Offering.OfferingCode
	GROUP BY Course.CourseId, CourseName
	HAVING AVG(Mark) > @AvgThreshold -- averages GREATER than a given value

	END

RETURN
GO

--2.	Create a stored procedure called “HonorCoursesForOneTerm” to select all the course names that have average > a given value in a given semester. *can check parameters in one conditional expression and a common message printed if any of them are missing*

CREATE PROCEDURE HonorCoursesForOneTerm (@AvgThrehold DECIMAL(5,2) = NULL
			, @Semester CHAR(5) = NULL) 
AS

-- check params:
IF @AvgThrehold IS NULL OR @Semester IS NULL
	BEGIN
	PRINT 'One or more parameters are missing'
	END
ELSE -- parameters are provided
	BEGIN

	SELECT CourseName
	FROM Course
	INNER JOIN Offering ON Course.CourseId = Offering.CourseID
	INNER JOIN Registration ON Registration.OfferingCode = Offering.OfferingCode
	WHERE SemesterCode = @Semester
	GROUP BY Course.CourseId, CourseName
	HAVING AVG(Mark) > @AvgThreshold -- averages GREATER than a given value

	END


RETURN
GO

--3.	Create a stored procedure called “NotInACourse” that lists the full names of the staff that have not taught a given courseID.

CREATE PROCEDURE NotInACourse (@CourseID CHAR(7) = NULL ) AS

IF @CourseID IS NULL
	BEGIN
	PRINT 'Missing parameter'
	END
ELSE
	BEGIN

	SELECT FirstName, LastName
	FROM Staff
	WHERE StaffID NOT IN (

		-- a list of Staff who HAVE taught this course:
		SELECT StaffID
		FROM Offering
		WHERE CourseID = @CourseID

	)

	END

RETURN 
GO

--4.	Create a stored procedure called “LowCourses” to select the course name of the course(s) that have had less than a given number of students in them.

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

--5.	Create a stored procedure called “ListaProvince” to list all the students names that are in a given province.

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

--6.	Create a stored procedure called “transcript” to select the transcript for a given studentID. Select the StudentID, full name, course IDs, course names, and marks.

CREATE PROCEDURE Transcript (@StudentID INT = NULL) AS

-- check param was provided
IF @StudentID IS NULL -- if not provided, print error message
	BEGIN
	RAISERROR( 'Missing parameter', 16, 1)
	END
ELSE -- if we DO have a parameter
	BEGIN
	SELECT Student.StudentID
		, FirstName + ' ' + LastName AS FullName
		, Course.CourseId
		, CourseName
		, Mark
	FROM Student
	INNER JOIN Registration ON Student.StudentID = Registration.StudentID
	INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
	INNER JOIN Course ON Offering.CourseID = Course.CourseId
	WHERE Student.StudentID = @StudentID
	END

RETURN -- end of the SP
GO -- end of the batch

-- test with NO parameters
EXEC Transcript
-- test with a "good" parameter
EXEC Transcript 199899200
-- test with a "bad" parameter
EXEC Transcript 99999


GO

--7.	Create a stored procedure called “PaymentTypeCount” to select the count of payments made for a given payment type description. 

CREATE PROCEDURE PaymentTypeCount (@PaymentTypeDescription VARCHAR(40) = NULL) AS

IF @PaymentTypeDescription IS NULL
	BEGIN
	PRINT 'Missing parameter'
	END
ELSE
	BEGIN

	SELECT COUNT(DISTINCT PaymentID) AS NumberOfPayments
	FROM Payment
	INNER JOIN PaymentType on Payment.PaymentTypeID = PaymentType.PaymentTypeID
	WHERE PaymentTypeDescription = @PaymentTypeDescription
	GROUP BY Payment.PaymentTypeID

	END

RETURN -- marks the end of the procedure
GO -- marks the end of the batch


--8.	Create stored procedure called “Class List” to select student Full names that are in a course for a given semesterCode and Coursename.

CREATE PROCEDURE ClassList (@Semester CHAR(5) = NULL, @CourseName VARCHAR(40) = NULL) AS

IF @Semester IS NULL OR @CourseName IS NULL
	BEGIN
	PRINT 'Missing parameter'
	END
ELSE
	BEGIN

	SELECT Student.FirstName + ' ' + Student.LastName AS FullName
	FROM Student
	INNER JOIN Registration ON Student.StudentID = Registration.StudentID
	INNER JOIN Offering on Registration.OfferingCode = Offering.OfferingCode
	INNER JOIN Course on Offering.CourseID = Course.CourseId
	WHERE SemesterCode = @Semester
		AND CourseName = @CourseName

	END

RETURN
GO

