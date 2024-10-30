--Outer Joins Exercise
USE IQSchool
GO

--1. Select All position descriptions and the staff IDs that are in those positions
SELECT PositionDescription, StaffID
FROM Position 
LEFT JOIN Staff ON Position.PositionID = Staff.PositionID

SELECT PositionDescription, StaffID
FROM Staff 
RIGHT JOIN Position ON Position.PositionID = Staff.PositionID

--2. Select the Position Description and the count of how many staff are in those positions.
--Return the count for ALL positions.
--HINT: Count can use either count(*) which means records or a field name. Which gives the correct result in this question?
SELECT PositionDescription, COUNT(StaffID) AS NumberStaff
FROM Position 
LEFT JOIN Staff ON Position.PositionID = Staff.PositionID
GROUP BY Position.PositionID, PositionDescription
-- we need to GROUP BY the thing that uniquely identifies positions: PositionID
-- we need to GROUP BY anything in our SELECT that isn't aggregated: PositionDescription

--3. Select the average mark of ALL the students. Show the student names and averages.
SELECT FirstName + ' ' + LastName AS FullName
	, AVG(Mark) AS AverageMark
FROM Student
LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
GROUP BY FirstName, LastName, Student.StudentID

--4. Select the highest and lowest mark for each student.
SELECT FirstName + ' ' + LastName AS FullName
	, MAX(Mark) AS HighestMark
	, MIN(Mark) AS LowestMark
FROM Student
LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
GROUP BY FirstName, LastName, Student.StudentID

--5. How many students are in each club? Display the club name and count.
SELECT ClubName, COUNT(StudentID) AS NumberOfStudents
FROM Club
LEFT JOIN Activity ON Club.ClubId = Activity.ClubId
GROUP BY Club.ClubId, ClubName