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

--Additional Info:

---	if the event is a staff being hired:
	---	the id column contains the employee id
	---	the name is in the format ‘FirstName LastName’
---	if the event is a student birthdate:
	---	the id column contains the student id
	---	the name is in the format ‘FirstName LastName’
---	the data is sorted in descending order of id (Student or Staff)
---	the display is limited to the hiring of staff or the birthdates of students in the month of October

SELECT StudentID AS ID
	, 'Student Born:' + FirstName + ' ' + LastName AS [Event:Name]
FROM Student 
WHERE DateName(mm, Birthdate) = 'October'

UNION

-- the unioned queries must have the same # of columns, in the same order, and with similar data types
-- the column names always come from the first query, so it doesn't matter what we name the columns in the 2nd query
SELECT StaffID
	, 'StaffHired:' + FirstName + ' ' + LastName
FROM Staff 
WHERE DateName(mm, DateHired) = 'October'

ORDER BY ID DESC

