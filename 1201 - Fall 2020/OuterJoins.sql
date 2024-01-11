--Outer Joins Exercise
--Author: Dana Marsh
--1. Select All position descriptions and the staff IDs that are in those positions
SELECT PositionDescription, StaffID
FROM Position
LEFT JOIN Staff ON Position.PositionID = Staff.PositionID

--2. Select the Position Description and the count of how many staff are in those positions. Return the count for ALL positions.
--HINT: Count can use either count(*) which means records or a field name. Which gives the correct result in this question?
SELECT PositionDescription, COUNT(DISTINCT StaffID) AS NumStaff
FROM Position
LEFT JOIN Staff ON Position.PositionID = Staff.PositionID
GROUP BY Position.PositionID, PositionDescription

--3. Select the average mark of ALL the students. Show the student names and averages.
SELECT Student.FirstName, Student.LastName, AVG(Mark) AS AvgMark
FROM Student
LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
GROUP BY Student.StudentID, Student.FirstName, Student.LastName

--4. Select the highest and lowest mark for each student. 
SELECT Student.FirstName
	, Student.LastName
	, MAX(Mark) AS HighestMark
	, MIN(Mark) AS LowestMark
FROM Student
LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
GROUP BY Student.StudentID, Student.FirstName, Student.LastName

--5. How many students are in each club? Display club name and count.
SELECT ClubName, COUNT(DISTINCT StudentID) AS NumStudents
FROM Activity
RIGHT JOIN Club on Activity.ClubID = Club.ClubID
GROUP BY Club.ClubId, ClubName




