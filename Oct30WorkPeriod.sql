-- how I could get a list of the students who are NOT registered?
SELECT FirstName, LastName
FROM Student
LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
WHERE Registration.StudentID IS NULL

SELECT FirstName, LastName
FROM Student
WHERE StudentID NOT IN (SELECT StudentID FROM Registration)

-- the name of the student with the highest average mark
SELECT Student.FirstName
	, Student.LastName
FROM Student
LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
GROUP BY FirstName, LastName, Student.StudentID
HAVING AVG(Mark) >= ALL (
	SELECT AVG(Registration.Mark) AS AverageMark
	FROM Registration
	GROUP BY StudentID
)

-- views
GO
-- unions
CREATE VIEW allthethings
AS

SELECT FirstName, LastName FROM Student
UNION ALL
SELECT FirstName, LastName FROM Staff

GO

SELECT * FROM allthethings