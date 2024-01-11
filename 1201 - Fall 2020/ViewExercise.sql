--1.	Create a view of staff full names called staff_list.

CREATE VIEW staff_list
AS
SELECT FirstName + ' ' + LastName AS FullName
FROM Staff

SELECT * FROM staff_list

GO

--2.	Create a view of staff IDs, full names, positionIDs and datehired called staff_confidential.

CREATE VIEW staff_confidential
AS
SELECT StaffID
	, FirstName + ' ' + LastName AS FullName
	, PositionID
	, DateHired
FROM Staff

GO

--3.	Create a view of student IDs, full names, courseIds, course names, and grades called student_grades.
CREATE VIEW student_grades
AS
SELECT Student.StudentID
	, FirstName + ' ' + LastName AS FullName
	, Mark
	, Course.CourseID
	, CourseName
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
INNER JOIN Course ON Offering.CourseID = Course.CourseId

GO

--4.	Use the student_grades view to create a grade report for studentID 199899200 that shows the students ID, full name, course names and marks.
SELECT StudentID, FullName, CourseName, Mark
FROM student_grades
WHERE StudentID = 199899200

GO
--5.	Select the same information using the student_grades view for studentID 199912010.
SELECT StudentID, FullName, CourseName, Mark
FROM student_grades
WHERE StudentID = 199912010

GO

--6.	Retrieve the code for the student_grades view from the database.
sp_helptext student_grades