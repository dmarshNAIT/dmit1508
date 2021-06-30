--Union Exercise (using the IQSchool database)
USE IQSchool

--1.	Write a script that will produce the ‘It Happened in October’ display.
--The output of the display is shown below

--It Happened in October
 
--ID          Event:Name
------------- -----------------------------------
--200645320   Student Born:Thomas Brown
--200322620   Student Born:Flying Nun
--7           Staff Hired:Hugh Guy
--6           Staff Hired:Sia Latter

--Additional Info:

---	if the event is an staff  being hired:
	---	the id column contains the employee id
	---	the name is in the format ‘FirstName LastName’
---	if the event is a Student birthdate:
	---	the id column contains the Student id
	---	the name is in the format ‘FirstName LastName’
---	the data is sorted in descending order of id (Student or staff)
---	the display is limited to the hiring of staff or the birthdates of students in the month of October

SELECT StudentID AS ID
	, 'Student Born: ' + FirstName + ' ' +  LastName AS 'Event: Name'
FROM Student
WHERE Birthdate LIKE 'Oct%'

UNION

SELECT StaffID
	, 'Staff Hired: ' + FirstName + ' ' +  LastName
FROM Staff
WHERE DateHired LIKE 'Oct%'

ORDER BY ID DESC

