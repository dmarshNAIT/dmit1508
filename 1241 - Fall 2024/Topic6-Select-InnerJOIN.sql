--Inner Join Exercise
USE IQSchool
GO

--1. Select Student full names and the course IDs they are registered in.
--2. Select the Staff full names and the Course IDs they teach

--3. Select all the Club IDs and the Student full names that are in them
SELECT ClubId
	, FirstName + ' ' + LastName AS FullName
FROM Student
INNER JOIN Activity ON Student.StudentID = Activity.StudentID
-- bonus
ORDER BY ClubId


--4. Select the Student full name, courseID's and marks for studentID 199899200.


--5. Select the Student full name, course names and marks for studentID 199899200.
SELECT *
FROM Student AS s
INNER JOIN Registration AS reg	ON s.StudentID = reg.StudentID
INNER JOIN Offering		AS o	ON reg.OfferingCode = o.OfferingCode
INNER JOIN Course		AS c	ON o.CourseId = c.CourseId



--6. Select the CourseID, CourseNames, and the Semesters they have been taught in
--7. What Staff Full Names have taught IT System Administration?
--8. What is the course list for student ID 199912010 in semestercode A100. Select the
--Students Full Name and the CourseNames.
--9. What are the Student Names, courseIDs that have Marks > 80?