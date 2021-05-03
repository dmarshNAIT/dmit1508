--Joins Exercise 1
-- Author: Dana Marsh

--1.	Select Student full names and the course IDs they are registered in.
SELECT DISTINCT Student.FirstName, Student.LastName, Offering.CourseID
FROM Student
INNER JOIN Registration AS reg ON Student.StudentID = reg.StudentID
INNER JOIN Offering ON reg.OfferingCode = Offering.OfferingCode

--2.	Select the Staff full names and the Course IDs they teach
SELECT DISTINCT Staff.FirstName + ' ' + Staff.LastName AS StaffName
	, Offering.CourseID
FROM Staff
INNER JOIN Offering ON Staff.StaffID = Offering.StaffID

--3.	Select all the Club IDs and the Student full names that are in them
SELECT Activity.ClubID
	, Student.FirstName + ' ' + Student.LastName AS StudentName
FROM Student
INNER JOIN Activity ON Student.StudentID = Activity.StudentID

--4.	Select the Student full name, courseIDs and marks for studentID 199899200.
SELECT Student.FirstName + ' ' + Student.LastName AS StudentName
	, CourseID
	, Mark
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
WHERE Student.StudentID = 199899200

--5.	Select the Student full name, course names and marks for studentID 199899200.
SELECT Student.FirstName + ' ' + Student.LastName AS StudentName
	, CourseName
	, Mark
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
INNER JOIN Course ON Offering.CourseID = Course.CourseId
WHERE Student.StudentID = 199899200

--6.	Select the CourseID, CourseNames, and the Semesters they have been taught in
SELECT Course.CourseID, CourseName, Semester.SemesterCode, StartDate, EndDate
FROM Course
INNER JOIN Offering ON Course.CourseId = Offering.CourseID
INNER JOIN Semester ON Offering.SemesterCode = Semester.SemesterCode

--7.	What Staff Full Names have taught Networking 1?
SELECT Staff.FirstName + ' ' + Staff.LastName AS StaffName
FROM Staff
INNER JOIN Offering ON Staff.StaffID = Offering.StaffID
INNER JOIN Course ON Offering.CourseID = Course.CourseId
WHERE CourseName = 'Networking 1'

--8.	What is the course list for student ID 199912010 in semestercode A100. Select the Students Full Name and the CourseNames.
SELECT Student.FirstName + ' ' + Student.LastName AS StudentName
	, CourseName
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
INNER JOIN Course ON Offering.CourseID = Course.CourseId
WHERE Student.StudentID = 199912010 AND SemesterCode = 'A100'

--9. What are the Student Names, courseIDs that have Marks >80?
SELECT Student.FirstName, Student.LastName, CourseID
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
WHERE Mark > 80