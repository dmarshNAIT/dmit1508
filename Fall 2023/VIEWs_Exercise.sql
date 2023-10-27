--View Exercise

--Use the IQSchool database for this exercise.  If an operation fails write a brief explanation why. Do not just quote the error message genereated by the server!
USE IQSchool
GO

--1.	Create a view of staff full names called staff_list.
DROP VIEW IF EXISTS staff_list
GO

CREATE VIEW staff_list
AS
SELECT FirstName + ' ' + LastName AS FullName
FROM Staff

GO

--2.	Create a view of staff IDs, full names, positionIDs and datehired called staff_confidential.
DROP VIEW IF EXISTS staff_confidential
GO

CREATE VIEW staff_confidential
AS
SELECT StaffID
,	FirstName + ' ' + LastName AS FullName
,	PositionID
,	DateHired
FROM Staff

GO

--3.	Create a view of student IDs, full names, courseIds, course names, and grades called student_grades.
DROP VIEW IF EXISTS student_grades
GO

CREATE VIEW student_grades
AS
SELECT Student.StudentID, FirstName + ' ' + LastName AS FullName, Course.CourseID, CourseName, Mark
FROM Student
LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
LEFT JOIN Offering ON Offering.OfferingCode = Registration.OfferingCode
LEFT JOIN Course ON Course.CourseId = Offering.CourseId
GO

--4.	Use the student_grades view to create a grade report for studentID 199899200 that shows the students ID, full name, course names and marks.
SELECT StudentID, FullName, CourseName, Mark
FROM  student_grades
WHERE StudentID = 199899200

--5.	Select the same information using the student_grades view for studentID 199912010.
SELECT StudentID, FullName, CourseName, Mark
FROM  student_grades
WHERE StudentID = 199912010

--6.	Using the student_grades view update the mark for studentID 199899200 in course dmit2015 to be 90 and change the coursename to be 'basket weaving 101'.
UPDATE student_grades
SET Mark = 90, CourseName = 'Basket Weaving 101'
WHERE StudentID = 199899200 AND CourseId = 'DMIT2015'
-- this fails. Mark is in the Registration table and CourseName is in the Course table; we cannot UPDATE 2 separate tables in a single statement.

--7.	Using the student_grades view, update the mark for studentID 199899200 in course dmit2015 to be 90.
UPDATE student_grades
SET Mark = 90
WHERE StudentID = 199899200 AND CourseId = 'DMIT2015'

--8.	Using the student_grades view, delete the same record from question 7.
DELETE FROM student_grades
WHERE StudentID = 199899200 AND CourseId = 'DMIT2015'
-- this doesn't work because we cannot delete info from multiple tables in one command

--9.	Retrieve the code for the student_grades view from the database.
EXEC sp_helptext student_grades