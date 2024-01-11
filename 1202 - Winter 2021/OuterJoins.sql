--Outer Joins Exercise
USE IQSchool
GO

--1. Select All position descriptions and the staff IDs that are in those positions
SELECT PositionDescription, StaffID
FROM Position -- Position is the Parent of Staff table
LEFT OUTER JOIN Staff ON Position.PositionID = Staff.PositionID

--2. Select the Position Description and the count of how many staff are in those positions. Return the count for ALL positions.
SELECT PositionDescription, COUNT(DISTINCT StaffID) AS NumStaff
FROM Position -- Position is the Parent of Staff table
LEFT OUTER JOIN Staff ON Position.PositionID = Staff.PositionID
GROUP BY Position.PositionID, PositionDescription

--HINT: Count can use either count(*) which means records or a field name. Which gives the correct result in this question?

--3. Select the average mark of ALL the students. Show the student names and averages.
 SELECT Student.FirstName + ' ' + Student.LastName AS FullName
	, AVG(Mark) AS AverageMark
 FROM Student
 LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
 GROUP BY Student.StudentID, FirstName, LastName

--4. Select the highest and lowest mark for each student, including those with no mark. 
 SELECT Student.FirstName + ' ' + Student.LastName AS FullName
	, MAX(Mark) AS HIghestMark
	, MIN(Mark) AS LowestMark
 FROM Student
 LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
 GROUP BY Student.StudentID, FirstName, LastName

--5. How many students are in each club? Display club name and count.
SELECT ClubName, COUNT(DISTINCT Activity.StudentID) AS NumStudents
FROM  Activity
RIGHT JOIN Club on Activity.ClubId = Club.ClubId
GROUP BY Club.ClubId, ClubName



