--View Exercise
--Use the IQSchool database for this exercise. If an operation fails write a brief explanation why.
USE IQSchool
GO
--Do not just quote the error message genereated by the server!
--1. Create a view of staff full names called staff_list.
--2. Create a view of staff IDs, full names, positionID's and datehired called staff_confidential.
--3. Create a view of student IDs, full names, courseIds, course names, and grades called student_grades.
-- We specifically want ALL students, even those who haven't taken courses.

GO

CREATE VIEW student_grades
AS
SELECT Student.StudentID
	, Student.FirstName + ' ' + Student.LastName AS FullName
	, Course.CourseId
	, Course.CourseName
	, Registration.Mark
FROM Student
LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
LEFT JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
LEFT JOIN Course ON Offering.CourseId = Course.CourseId

GO



--4. Use the student_grades view to create a grade report for studentID 199899200 that shows
--the students ID, full name, course names and marks.
SELECT StudentID, FullName, CourseName, Mark
FROM student_grades
WHERE StudentID  = 199899200


--5. Select the same information using the student_grades view for studentID 199912010.
--6. Using the student_grades view update the mark for studentID 199899200 in course dmit2015 to be 90 and change the coursename to be 'basket weaving 101'.
UPDATE student_grades
SET Mark = 90, 
	CourseName = 'Basket Weaving 101'
WHERE StudentID = 199899200 AND CourseId = 'DMIT2015'
-- not allowed: cannot UPDATE multiple tables at once
-- instead, we'll do each table separately:
UPDATE student_grades
SET Mark = 90
WHERE StudentID = 199899200 AND CourseId = 'DMIT2015'

UPDATE student_grades
SET CourseName = 'Basket Weaving 101'
WHERE StudentID = 199899200 AND CourseId = 'DMIT2015'


--7. Using the student_grades view, update the mark for studentID 199899200 in course
--dmit2015 to be 90.
--8. Using the student_grades view, delete the same record from question 7.
--9. Retrieve the code for the student_grades view from the database.