--Joins Exercise 1

--1.	Select Student full names and the course IDs they are registered in.
SELECT DISTINCT Student.FirstName + ' ' + Student.LastName AS StudentName
	, Offering.CourseID -- TableName.ColumnName
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID 
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode

--2.	Select the Staff full names and the Course IDs they teach
SELECT DISTINCT Staff.FirstName + ' ' + Staff.LastName AS StaffName
	, Offering.CourseID
FROM Staff
INNER JOIN Offering ON Staff.StaffID = Offering.StaffID

--3.	Select all the Club IDs and the Student full names that are in them
SELECT Activity.ClubId
	, Student.FirstName + ' ' + Student.LastName AS StudentName
FROM Student
INNER JOIN Activity on Student.StudentID = Activity.StudentID
ORDER BY Activity.ClubId

--4.	Select the Student full name, courseIDs, and marks for studentID 199899200.
SELECT Student.FirstName + ' ' + Student.LastName AS StudentName
	, Offering.CourseID
	, Registration.Mark
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID 
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
WHERE Student.StudentID = 199899200

--5.	Select the Student full name, course names and marks for studentID 199899200.
SELECT Student.FirstName + ' ' + Student.LastName AS StudentName
	, Course.CourseName
	, Registration.Mark
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID 
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
INNER JOIN Course ON Offering.CourseID = Course.CourseId
WHERE Student.StudentID = 199899200

--6.	Select the CourseID, CourseNames, and the Semesters they have been taught in
SELECT Course.CourseId
	, Course.CourseName
	, Offering.SemesterCode
FROM Course
INNER JOIN Offering ON Course.CourseId = Offering.CourseID

--7.	What Staff Full Names have taught Networking 1?
SELECT DISTINCT Staff.FirstName + ' ' + Staff.LastName AS StaffName
FROM Staff
INNER JOIN Offering ON Staff.StaffID = Offering.StaffID
INNER JOIN Course ON Offering.CourseID = Course.CourseID
WHERE Course.CourseName = 'Networking 1'

--8.	What is the course list for student ID 199912010 in semestercode A100. Select the Students Full Name and the CourseNames.
SELECT Student.FirstName + ' ' + Student.LastName AS StudentFullName
	, Course.CourseName
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
INNER JOIN Course on Offering.CourseID = Course.CourseId
WHERE Student.StudentID = 199912010
	AND Offering.SemesterCode = 'A100'

--9. What are the Student Names, courseIDs that have Marks >80?
SELECT Student.FirstName + ' ' + Student.LastName AS StudentFullName
	, Offering.CourseID
FROM Student 
INNER JOIN Registration ON Student.StudentID = Registration.StudentID 
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
WHERE Registration.Mark > 80
