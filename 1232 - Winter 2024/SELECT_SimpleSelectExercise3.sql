--Simple Select Exercise 3
USE IQSchool
GO

--1. Select the average mark for each offeringCode. Display the OfferingCode and the average mark.
SELECT OfferingCode, AVG(Mark) AS AverageMark
FROM Registration
GROUP BY OfferingCode

--2. How many payments were made for each payment type? Display the Payment typeID and the count.
SELECT PaymentTypeID
	, COUNT(PaymentID) AS [Number Of Payments]
FROM Payment
GROUP BY PaymentTypeID

--3. Select the average Mark for each studentID. Display the StudentId and their average mark
SELECT StudentID, Avg(Mark) As AvgMark
FROM Registration
GROUP BY StudentID

--4. Select the same data as question 3 but only show the studentIDs and averages that are > 80
SELECT StudentID, Avg(Mark) As AvgMark
FROM Registration
GROUP BY StudentID
HAVING Avg(Mark) > 80

--5. How many students are from each city? Display the City and the count.
SELECT City
	, COUNT(*) AS NumStudents -- or COUNT(StudentID)
FROM Student
GROUP BY City

--6. Which cities have 2 or more students from them? (HINT, remember that fields that we use in the where or having do not need to be selected.....)
SELECT City
	--, COUNT(*) -- or COUNT(StudentID)
FROM Student
GROUP BY City
HAVING COUNT(*) >= 2

--7.what is the highest, lowest and average payment amount for each payment type? 
SELECT PaymentTypeID
, Max(Amount) AS Highest
, Min(Amount) AS Lowest
, Avg(Amount) AS Average
FROM Payment
GROUP BY PaymentTypeID

--8. How many students are there in each club? Show the clubID and the count
SELECT ClubID, COUNT(*) AS NumStudents
FROM Activity
GROUP BY ClubID

--9. Which clubs have 3 or more students in them?
SELECT ClubID
FROM Activity
GROUP BY ClubID
HAVING COUNT(*) >= 3