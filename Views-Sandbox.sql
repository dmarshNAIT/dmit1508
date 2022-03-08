USE IQSchool
GO

-- creating a view:
CREATE VIEW StudentView
AS
SELECT FirstName + ' ' + LastName AS FullName
	, CourseName
	, Mark
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
INNER JOIN Course ON Offering.CourseID = Course.CourseId

GO

-- now, we can select from the view just like we select from a table:
SELECT * FROM StudentView

GO
-- if we need to modify the view, we just change the word CREATE to ALTER, make adjustments, then re-run:
ALTER VIEW StudentView
AS
SELECT FirstName + ' ' + LastName AS FullName
	, Course.CourseID -- this is new!
	, CourseName
	, Mark
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
INNER JOIN Course ON Offering.CourseID = Course.CourseId

GO
-- to see the definition of an existing view:
exec sp_helptext StudentView

-- and to delete a view:
DROP VIEW StudentView