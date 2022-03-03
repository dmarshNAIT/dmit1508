--Outer Joins Exercise
USE IQSchool
GO

--1. Select All position descriptions and the staff IDs that are in those positions
SELECT PositionDescription, StaffID
FROM Position LEFT JOIN Staff ON Position.PositionID = Staff.PositionID

--2. Select the Position Description and the count of how many staff are in those positions. Return the count for ALL positions.
--HINT: Count can use either count(*) which means records or a field name. Which gives the correct result in this question?

-- we want to see Position records, whether or not they have matching child (Staff) records
-- that means we want an OUTER JOIN
-- Position = parent, Staff = child

SELECT PositionDescription
	, COUNT(StaffID) AS NumberStaff
FROM Position LEFT OUTER JOIN Staff ON Position.PositionID = Staff.PositionID
GROUP BY PositionDescription, Position.PositionID
-- 1 dean, 4 instructors, no assistant dean

SELECT PositionDescription
	, COUNT(StaffID) AS NumberStaff
FROM Staff RIGHT JOIN Position ON Position.PositionID = Staff.PositionID
GROUP BY PositionDescription, Position.PositionID
-- 1 dean, 4 instructors, no assistant dean

--3. Select the average mark of ALL the students. Show the student names and averages.
SELECT FirstName + ' ' + LastName AS FullName
	, AVG(Mark) AS AverageMark
FROM Student
LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
GROUP BY Student.StudentID, FirstName, LastName

--4. Select the highest and lowest mark for each and every student. 
SELECT FirstName + ' ' + LastName AS FullName
	, MAX(Mark) AS HighestMark
	, MIN(Mark) AS LowestMark
FROM Student
LEFT JOIN Registration ON Student.StudentID = Registration.StudentID
GROUP BY Student.StudentID, FirstName, LastName

--5. How many students are in each club (even the empty ones)? Display club name and count.
SELECT ClubName
	, COUNT(StudentID) AS NumberStudents
FROM Activity RIGHT JOIN Club ON Activity.ClubId = Club.ClubId
GROUP BY ClubName, Club.ClubId

-- BONUS CONTENT: what if we only want the top 2 clubs?
SELECT TOP 2 ClubName
	, COUNT(StudentID) AS NumberStudents
FROM Activity RIGHT JOIN Club ON Activity.ClubId = Club.ClubId
GROUP BY ClubName, Club.ClubId
ORDER BY COUNT(StudentID) DESC

-- what if we wanted to see the names of the students in each club?
SELECT ClubName, FirstName
FROM Club
LEFT JOIN Activity ON Club.ClubId = Activity.ClubId
LEFT JOIN Student ON Activity.StudentID = Student.StudentID
ORDER BY ClubName
