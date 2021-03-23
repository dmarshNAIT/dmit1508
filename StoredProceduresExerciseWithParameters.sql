--Stored Procedure Exercise – Parameters
USE IQSchool
GO

--**Stored Procedure has to be the first statement in a batch so place GO in between each question to execute the previous batch (question) and start another. NOTE: all parameters are required. Raise an error message if a parameter is not passed to the procedure.


--1.	Create a stored procedure called “GoodCourses” to select all the course names that have averages  greater than a given value. 
CREATE PROCEDURE GoodCourses (@AvgThreshold DECIMAL(5,2) = NULL) AS

-- check if params are null:
IF @AvgThreshold IS NULL
	BEGIN
	RAISERROR('Missing parameter', 16, 1)
	END
ELSE
	BEGIN

	SELECT CourseName
	FROM Course
	INNER JOIN Offering ON Course.CourseId = Offering.CourseID
	INNER JOIN Registration ON Registration.OfferingCode = Offering.OfferingCode
	GROUP BY Course.CourseId, CourseName
	HAVING AVG(Mark) > @AvgThreshold -- averages GREATER than a given value

	END

RETURN -- end of the procedure
GO -- end of the batch

EXEC GoodCourses 100
EXEC GoodCourses 80
EXEC GoodCourses

GO

--2.	Create a stored procedure called “HonorCoursesForOneTerm” to select all the course names that have average > a given value in a given semester. *can check parameters in one conditional expression and a common message printed if any of them are missing*

--3.	Create a stored procedure called “NotInACourse” that lists the full names of the staff that have not taught a given courseID.

CREATE PROCEDURE NotInACourse (@CourseID __ ) AS



RETURN 
GO

--4.	Create a stored procedure called “LowCourses” to select the course name of the course(s) that have had less than a given number of students in them.

--5.	Create a stored procedure called “ListaProvince” to list all the students names that are in a given province.

--6.	Create a stored procedure called “transcript” to select the transcript for a given studentID. Select the StudentID, full name, course IDs, course names, and marks.

--7.	Create a stored procedure called “PaymentTypeCount” to select the count of payments made for a given payment type description. 

--8.	Create stored procedure called “Class List” to select student Full names that are in a course for a given semesterCode and Coursename.


