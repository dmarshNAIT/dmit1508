--Union Exercise (using the IQSchool database)

--1.	Write a script that will produce the ‘It Happened in October’ display.
--The output of the display is shown below

--CREATE VIEW ItHappenedInOctober
--AS
SELECT  StudentID AS ID
	, 'Student Born:' + FirstName + ' ' + LastName AS 'Event:Name'
FROM Student
WHERE DATENAME(MONTH, Birthdate) = 'October'
-- or: WHERE MONTH(Birthdate) = 10
UNION ALL
SELECT StaffID
	, 'Staff Hired:' + FirstName + ' ' + LastName
FROM Staff
WHERE DATENAME(MONTH, DateHired) = 'October'
ORDER BY ID DESC

--SELECT * FROM ItHappenedInOctober ORDER BY ID DESC