--Outer Joins Exercise
USE IQSchool
GO

--1. Select All position descriptions and the staff ID's that are in those positions
SELECT PositionDescription, StaffID
FROM Position 
LEFT JOIN Staff ON Position.PositionID = Staff.PositionID

--2. Select the Position Description and the count of how many staff are in those positions. Returnt the count for ALL positions.
--HINT: Count can use either count(*) which means records or a field name. Which gives the correct result in this question?
SELECT PositionDescription
	, COUNT(StaffID) AS NumberStaff
FROM Position 
LEFT JOIN Staff ON Position.PositionID = Staff.PositionID
GROUP BY PositionDescription, Position.PositionID

--3. Select the average mark of ALL the students. Show the student names and averages.
SELECT FirstName + ' ' + LastName AS FullName
	, AVG(Mark) AS AverageMark
FROM Student
LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
GROUP BY Student.StudentID, FirstName, LastName

--4. Select the highest and lowest mark for each student. 
SELECT FirstName + ' ' + LastName AS FullName
	, MAX(Mark) AS HighestMark
	, MIN(Mark) AS LowestMark
FROM Student
LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
GROUP BY Student.StudentID, FirstName, LastName

--5. How many students are in each club? Display the club name and count.
SELECT ClubName
	, COUNT(StudentID) AS NumberStudents
FROM Activity 
RIGHT JOIN Club ON Activity.ClubId = Club.ClubId
GROUP BY ClubName, Club.ClubId
