--Stored Procedure Exercise – Parameters
-- Author: Dana Marsh
USE [IQ-School]
GO
-- Work through this exercise: we will review next week

--1.	Create a stored procedure called “GoodCourses” to select all the course names that have averages  greater than a given value. 

 CREATE PROCEDURE GoodCourses (@MinimumAverage DECIMAL(5,2) = NULL)
 AS 

IF @MinimumAverage IS NULL -- I HAD A TYPO HERE
	BEGIN
		RAISERROR('Must provide a minimum average', 16, 1)
	END
ELSE
	BEGIN
		SELECT CourseName --, AVG(Mark) AS AverageMark
		FROM Course
		INNER JOIN Offering ON Course.CourseId = Offering.CourseID
		INNER JOIN Registration ON Registration.OfferingCode = Offering.OfferingCode
		GROUP BY Course.CourseID, CourseName
		HAVING AVG(Mark) > @MinimumAverage
	END
RETURN
GO
-- test
EXEC GoodCourses 80
GO

--2.	Create a stored procedure called “HonorCoursesForOneTerm” to select all the course names that have average > a given value in a given semester. *can check parameters in one conditional expression and a common message printed if any of them are missing*

CREATE PROCEDURE HonorCoursesForOneTerm (@MinimumAverage DECIMAL(5,2) = NULL, @Semester CHAR(5) = NULL)
 AS 

IF @MinimumAverage IS NULL 
	BEGIN
		RAISERROR('Must provide average', 16, 1)
	END
ELSE IF @Semester IS NULL
	BEGIN
		RAISERROR('Must provide semester', 16, 1)
	END
ELSE
	BEGIN
		SELECT CourseName --, AVG(Mark) AS AverageMark
		FROM Course
		INNER JOIN Offering ON Course.CourseId = Offering.CourseID
		INNER JOIN Registration ON Registration.OfferingCode = Offering.OfferingCode
		WHERE SemesterCode = @Semester
		GROUP BY Course.CourseID, CourseName
		HAVING AVG(Mark) > @MinimumAverage
	END
RETURN
GO

EXEC HonorCoursesForOneTerm NULL, 'A100 '
GO

--3.	Create a stored procedure called “NotInACourse” that lists the full names of the staff that are not taught a given courseID.

CREATE PROCEDURE NotInACourse (@CourseID CHAR(7) = NULL)
AS
IF @CourseID IS NULL
	BEGIN
		RAISERROR('Must provide CourseID', 16, 1)
	END
ELSE
	BEGIN
	SELECT FirstName + ' ' + LastName AS FullName
	FROM Staff	
	WHERE StaffID NOT IN (
		SELECT StaffID FROM Offering WHERE CourseID = @CourseID)
	END
RETURN
GO

-- test
EXEC NotInACourse 'DMIT163'
GO

--4.	Create a stored procedure called “LowCourses” to select the course name of the course(s) that have had less than a given number of students in them.

CREATE PROCEDURE LowCourses(@NumStudents INT = NULL)
AS
IF @NumStudents IS NULL
	BEGIN
		RAISERROR('Must provide # of students', 16, 1)
	END
ELSE
	BEGIN
	SELECT CourseName
	FROM Course
	LEFT OUTER JOIN Offering ON Course.CourseId = Offering.CourseID
	LEFT OUTER JOIN Registration ON Registration.OfferingCode = Offering.OfferingCode
	GROUP BY CourseName
	HAVING COUNT(DISTINCT StudentID) < @NumStudents
	END
RETURN
GO

EXEC LowCourses 1
GO

--5.	Create a stored procedure called “ListaProvince” to list all the students names that are in a given province.

CREATE PROCEDURE ListaProvince (@Province CHAR(2) = NULL)
AS
IF @Province IS NULL
	BEGIN
		RAISERROR('Must provide province', 16, 1)
	END
ELSE
	BEGIN
	SELECT FirstName + ' ' + LastName AS FullName
	FROM Student 
	WHERE Province = @Province
	END
RETURN
GO
-- test
EXEC ListaProvince 'AZ'
GO
--6.	Create a stored procedure called “transcript” to select the transcript for a given studentID. Select the StudentID, full name, course IDs, course names, and marks.

CREATE PROCEDURE Transcript (@StudentID INT = NULL)
AS
IF @StudentID IS NULL
	BEGIN
		RAISERROR('Must provide Student ID', 16, 1)
	END
ELSE
	BEGIN
	SELECT Student.StudentID
		, FirstName + ' ' + LastName AS FullName
		, Course.CourseID
		, CourseName
		, Mark
	FROM Student
	INNER JOIN Registration ON Student.StudentID = Registration.StudentID
	INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
	INNER JOIN Course ON Offering.CourseID = Course.CourseId
	WHERE Student.StudentID = @StudentID
	END
RETURN
GO
-- test
EXEC Transcript 199899200
EXEC Transcript 99999999
GO

--7.	Create a stored procedure called “PaymentTypeCount” to select the count of payments made for a given payment type description. 

CREATE PROCEDURE PaymentTypeCount (@PaymentTypeDescription VARCHAR(40) = NULL)
AS
IF @PaymentTypeDescription IS NULL
	BEGIN
		RAISERROR('Must provide description', 16, 1)
	END
ELSE
	BEGIN

	SELECT COUNT(PaymentID) AS PaymentCount
	FROM Payment
	INNER JOIN PaymentType on Payment.PaymentTypeID = PaymentType.PaymentTypeID
	WHERE PaymentTypeDescription = @PaymentTypeDescription

	END
RETURN
GO


--8.	Create stored procedure called “Class List” to select student Full names that are in a course for a given semesterCode and Coursename.

CREATE PROCEDURE ClassList (@SemesterCode CHAR(5) = NULL, @CourseName VARCHAR(40) = NULL)
AS
IF @SemesterCode IS NULL OR @CourseName IS NULL
	BEGIN
		RAISERROR('Must provide semester and course', 16, 1)
	END
ELSE
	BEGIN
	SELECT FirstName + ' ' + LastName AS FullName
	FROM Student
	INNER JOIN Registration ON Student.StudentID = Registration.StudentID
	INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
	INNER JOIN Course ON Offering.CourseID = Course.CourseId
	WHERE SemesterCode = @SemesterCode
		AND CourseName = @CourseName
	END
RETURN
Go
