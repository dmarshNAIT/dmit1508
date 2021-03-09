--View Exercise

--Use the School158 database for this exercise.  If an operation fails write a brief explanation why. Do not just quote the error message genereated by the server!
USE IQSchool
GO

--1.	Create a view of staff full names called staff_list.
CREATE VIEW staff_list
AS
SELECT FirstName + ' ' + LastName AS FullName
FROM Staff

GO

--2.	Create a view of staff IDs, full names, positionID's and datehired called staff_confidential.
CREATE VIEW staff_confidential
AS
SELECT StaffID
	, FirstName + ' ' + LastName AS FullName
	, PositionID
	, DateHired
FROM Staff

GO

--3.	Create a view of student IDs, full names, courseId's, course names, and grades called student_grades.
CREATE VIEW student_grades
AS

SELECT Student.StudentID
	, FirstName + ' ' + LastName AS FullName
	, Course.CourseID
	, CourseName
	, Mark
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
INNER JOIN Course on Offering.CourseID = Course.CourseId

GO


--4.	Use the student_grades view to create a grade report for studentID 199899200 that shows the students ID, full name, course names and marks.
SELECT StudentID, FullName, CourseName, Mark
FROM student_grades
WHERE StudentID = 199899200

--5.	Select the same information using the student_grades view for studentID 199912010.
SELECT StudentID, FullName, CourseName, Mark
FROM student_grades
WHERE StudentID = 199912010

--6.	Using the student_grades view  update the mark for studentID 199899200 in course dmit152 to be 90  and change the coursename to be 'basket weaving 101'.
UPDATE student_grades
SET Mark = 90
	, CourseName = 'Basket Weaving 101'
WHERE StudentID = 199899200
	AND CourseId = 'DMIT152'

--7.	Using the student_grades view, update the  mark for studentID 199899200 in course dmit152 to be 90.
UPDATE student_grades
SET Mark = 90
WHERE StudentID = 199899200
	AND CourseId = 'DMIT152'

--8.	Using the student_grades view, delete the same record from question 7.
DELETE FROM student_grades
WHERE StudentID = 199899200
	AND CourseId = 'DMIT152'

--9.	Retrieve the code for the student_grades view from the database.
EXEC sp_helptext student_grades




