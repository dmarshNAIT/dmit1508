--Inner Join Exercise
USE IQSchool
GO

--1.	Select Student full names and the course IDs they are registered in.
SELECT FirstName + ' ' + LastName AS FullName
, CourseID
FROM Student
INNER JOIN Registration AS reg ON Student.StudentID = reg.StudentID
INNER JOIN Offering ON reg.OfferingCode = Offering.OfferingCode
-- using the alias of "reg" is optional: helps cut down on what we have to type


--2.	Select the Staff full names and the Course IDs they teach
SELECT FirstName + ' ' + LastName AS FullName
	, CourseID
FROM Staff
INNER JOIN Offering ON Staff.StaffID = Offering.StaffID

--3.	Select all the Club IDs and the Student full names that are in them
SELECT ClubID
,	FirstName + ' ' + LastName AS FullName
FROM Student
INNER JOIN Activity ON Student.StudentID = Activity.StudentID
ORDER BY ClubId -- sort our results (the Q didn't ask for this, bonus!)

-- or we can flip the order of the tables, because INNER JOIN is symmetrical:
SELECT ClubID
,	FirstName + ' ' + LastName AS FullName
FROM Activity
INNER JOIN Student ON Activity.StudentID = Student.StudentID
ORDER BY ClubId 

-- what if we did a LEFT JOIN?
SELECT ClubID
,	FirstName + ' ' + LastName AS FullName
FROM Student
LEFT JOIN Activity ON Student.StudentID = Activity.StudentID
ORDER BY ClubId 
-- this shows us all students, even those who aren't in clubs

--4.	Select the Student full name, courseIDs and marks for studentID 199899200.
SELECT Student.FirstName + ' ' + Student.LastName AS StudentName
	, Offering.CourseID
	, Registration.Mark
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID 
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
WHERE Student.StudentID = 199899200

--5.	Select the Student full name, course names and marks for studentID 199899200.
SELECT FirstName + ' ' + LastName AS FullName
	, CourseName
	, Mark
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
INNER JOIN Course ON Offering.CourseID = Course.CourseId
WHERE Student.StudentID = 199899200

--6.	Select the CourseID, CourseNames, and the Semesters they have been taught in
SELECT Course.CourseID -- using the Parent table's value for CourseID
	, CourseName
	, SemesterCode
FROM Course
INNER JOIN Offering ON Course.CourseId = Offering.CourseId

--7.	What Staff Full Names have taught IT System Administration?
SELECT DISTINCT FirstName + ' ' + LastName AS FullName 
	-- DISTINCT removes any duplicate staff names
FROM Staff
INNER JOIN Offering ON Staff.StaffID = Offering.StaffID
INNER JOIN Course ON Offering.CourseId = Course.CourseId 
WHERE CourseName = 'IT System Administration'

--8.	What is the course list for student ID 199912010 in semestercode A100. Select the Students Full Name and the CourseNames.
SELECT FirstName + ' ' + LastName AS Name, CourseName
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
INNER JOIN Course ON Offering.CourseID = Course.CourseId
WHERE Student.StudentID = 199912010
	AND SemesterCode = 'A100'

--9.	What are the Student Names, courseIDs that have Marks > 80?
SELECT FirstName + ' ' + LastName AS StudentName
, CourseId
FROM Student AS s
INNER JOIN Registration AS r ON s.StudentID = r.StudentID
INNER JOIN Offering AS o ON r.OfferingCode = o.OfferingCode
WHERE Mark > 80
-- the "AS" aliases are not required. 
-- These let us be lazy and type short names.