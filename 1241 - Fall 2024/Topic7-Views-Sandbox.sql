-- we have an awesome query. let's save it:

CREATE VIEW StudentGrades
AS

SELECT s.FirstName + ' ' + s.LastName AS FullName
	, c.CourseName
	, reg.Mark
FROM Student AS s
INNER JOIN Registration AS reg	ON s.StudentID = reg.StudentID
INNER JOIN Offering		AS o	ON reg.OfferingCode = o.OfferingCode
INNER JOIN Course		AS c	ON o.CourseId = c.CourseId

GO

-- now, we can SELECT from the view
SELECT * from StudentGrades