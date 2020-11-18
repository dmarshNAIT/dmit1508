--Stored Procedure Exercise – Parameters
-- Author: Dana Marsh
USE [IQ-School]

-- Work through this exercise today (Wednesday) - we will review at END OF CLASS (or if we run out of time, next week)

--1.	Create a stored procedure called “GoodCourses” to select all the course names that have averages  greater than a given value. 

 CREATE PROCEDURE GoodCourses (@MinimumAverage DECIMAL(5,2) = NULL)
 AS 

IF @MinimumAverage IS NULL -- I HAD A TYPO HERE
	BEGIN
		RAISERROR('Must provide a minimum average', 16, 1)
	END
ELSE
	BEGIN
		SELECT CourseName, AVG(Mark) AS AverageMark
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


--2.	Create a stored procedure called “HonorCoursesForOneTerm” to select all the course names that have average > a given value in a given semester. *can check parameters in one conditional expression and a common message printed if any of them are missing*

-- check parameters : IF @FirstParameter IS NULL OR @SecondParameter IS NULL

GO

-- test

--3.	Create a stored procedure called “NotInACourse” that lists the full names of the staff that are not taught a given courseID.

-- check parameters 

GO
-- test

--4.	Create a stored procedure called “LowCourses” to select the course name of the course(s) that have had less than a given number of students in them.

-- check parameters 

GO
-- test

--5.	Create a stored procedure called “ListaProvince” to list all the students names that are in a given province.

-- check parameters 

GO
-- test

--6.	Create a stored procedure called “transcript” to select the transcript for a given studentID. Select the StudentID, full name, course ID’s, course names, and marks.

-- check parameters 

GO
-- test

--7.	Create a stored procedure called “PaymentTypeCount” to select the count of payments made for a given payment type description. 

-- check parameters 

GO
-- test

--8.	Create stored procedure called “Class List” to select student Full names that are in a course for a given semesterCode and Coursename.


-- check parameters 

GO
-- test

