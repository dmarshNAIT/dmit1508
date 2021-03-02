--Inner Joins With Aggregates Exercises
USE IQSchool
GO

--1. How many staff are there in each position, including positions with no staff? Select the number and Position Description
SELECT PositionDescription, COUNT(DISTINCT StaffID) AS NumStaff
FROM Position -- Position is the Parent of Staff table
LEFT OUTER JOIN Staff ON Position.PositionID = Staff.PositionID
GROUP BY Position.PositionID, PositionDescription
-- OR: Staff RIGHT JOIN Position
 
--2. Select the average mark for each course. Display the CourseName and the average mark

--3. How many payments were made for each payment type (exclude those with no payments). Display the PaymentTypeDescription and the count
 

--4. Select the average Mark for each student. Display the Student Name and their average mark
 

--5. Select the same data as question 4 but only show the student names and averages that are > 80
 
 
--6.what is the highest, lowest and average payment amount for each payment type Description? (Ignore payment types with no payments)
 

--7. How many students are there in each club? Show the clubName and the count, including empty clubs
 
--8. Which clubs have 3 or more students in them? Display the Club Names.
 
