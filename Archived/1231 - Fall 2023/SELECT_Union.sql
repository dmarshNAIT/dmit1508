--Union Exercise
--(use the IQSchool database)
USE IQSchool
GO

--1.	Write the code that will produce the ‘It Happened in October’ output.
--The output is shown below:

--ID          Event:Name
------------- -----------------------------------
--200645320   Student Born:Thomas Brown
--200322620   Student Born:Flying Nun
--7           Staff Hired:Hugh Guy
--6           Staff Hired:Sia Latter


SELECT StaffID AS ID												---	the id column contains the employee id
	, 'Staff Hired:' + FirstName + ' ' + LastName AS [Event:Name]	---	the name is in the format ‘FirstName LastName’
FROM Staff
WHERE DATENAME(mm, DateHired) = 'October'							--- hiring of staff in October

UNION ALL

SELECT StudentID													---	the id column contains the student id	
,	'Student Born:' + FirstName + ' ' + LastName					---	the name is in the format ‘FirstName LastName’
FROM Student
WHERE DATENAME(mm, Birthdate) = 'October'							---	birthdates of students in the month of October

ORDER BY ID DESC													---	sorted in descending order of id