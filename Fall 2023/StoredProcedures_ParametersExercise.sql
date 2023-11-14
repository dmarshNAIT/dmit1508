--Stored Procedure Exercise – Parameters

--**Stored Procedure has to be the first statement in a batch, so place Go in between each question to execute the previous batch (question) and start another. 

-- NOTE: all parameters are required. Raise an error message if a parameter is not passed to the procedure.



USE IQSchool
GO

--1.	Create a stored procedure called “GoodCourses” to select all the course names that have averages greater than a given value. 

--2.	Create a stored procedure called “HonorCoursesForOneTerm” to select all the course names that have average > a given value in a given semester. *You can check all parameters in one conditional expression and a common message printed if any of them are missing*

--3.	Create a stored procedure called “NotInACourse” that lists the full names of the staff who have not taught a given CourseID.

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

-- test the procedure
-- DMIT 1508 has been taught by Staff #6, and no one else
EXEC NotInACourse 'DMIT1508'
EXEC NotInACourse

--4.	Create a stored procedure called “LowCourses” to select the course name of the course(s) that have had less than a given number of students in them.

--5.	Create a stored procedure called “ListaProvince” to list all the student’s names that are in a given province.

--6.	Create a stored procedure called “Transcript” to select the transcript for a given StudentID. Select the StudentID, full name, course ID’s, course names, and marks.

--7.	Create a stored procedure called “PaymentTypeCount” to select the count of payments made for a given payment type description. 

--8.	Create stored procedure called “Class List” to select student Full names that are in a course for a given SemesterCode and CourseName.


