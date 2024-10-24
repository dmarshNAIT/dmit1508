--Simple Select Exercise 3
USE IQSchool
GO

--1. Select the average mark for each OfferingCode. Display the OfferingCode and the average mark.
--2. How many payments were made for each payment type. Display the Payment TypeID and
--the count.
--3. Select the average Mark for each StudentId. Display the StudentId and their average mark.
SELECT StudentID, AVG(Mark) AS AverageMark
FROM Registration
GROUP BY StudentID

--4. Select the same data as question 3 but only show the StudentIds and averages that are > 80.
SELECT StudentID, AVG(Mark) AS AverageMark
FROM Registration
GROUP BY StudentID
HAVING AVG(Mark) > 80

--5. How many students are from each city? Display the City and the count.
SELECT City, COUNT(StudentID) AS NumberOfStudents
FROM Student
GROUP BY City

--6. Which cities have 2 or more students from them? (HINT, remember that fields that we use in the where or having do not need to be selected.....)
SELECT City
FROM Student
GROUP BY City
HAVING COUNT(StudentID) >= 2

--7.What is the highest, lowest, and average payment amount for each payment type?
--8. How many students are there in each club? Show the ClubID and the count.
--9. Which clubs have 3 or more students in them?