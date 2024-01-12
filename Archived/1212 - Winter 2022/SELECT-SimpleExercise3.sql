--Simple Select Exercise 3
USE IQSchool
GO

--1. Select the average mark for each offeringCode. Display the OfferingCode and the average mark.
SELECT OfferingCode
,	AVG(Mark) AS AverageMark
FROM Registration
GROUP BY OfferingCode -- "for each offeringCode"

--2. How many payments were made for each payment type? Display the Payment typeID and the count
SELECT PaymentTypeID
	, COUNT(*) AS NumberOfPayments
FROM Payment
GROUP BY PaymentTypeID -- "for each payment type"
-- or
SELECT PaymentTypeID
	, COUNT(PaymentID) AS NumberOfPayments
FROM Payment
GROUP BY PaymentTypeID

--3. Select the average Mark for each studentID. Display the StudentId and their average mark
SELECT StudentID
,	AVG(Mark) AS AverageMark
FROM Registration
GROUP BY StudentID -- "for each StudentID"

--4. Select the same data as question 3 but only show the studentIDs and averages that are > 80
SELECT StudentID
,	AVG(Mark) AS AverageMark
FROM Registration
GROUP BY StudentID -- "for each StudentID"
HAVING AVG(Mark) > 80 -- filter results of an aggregate function

--5. How many students are from each city? Display the City and the count.
SELECT City
	, COUNT(*) AS NumberOfStudents
FROM Student
GROUP BY City -- "from each city"
-- or
SELECT City
	, COUNT(StudentID) AS NumberOfStudents
FROM Student
GROUP BY City -- "from each city"

--6. Which cities have 2 or more students from them? (HINT, remember that fields that we use in the where or having do not need to be selected.....)
SELECT City
FROM Student
GROUP BY City -- "from each city"
HAVING COUNT(*) >= 2

--7.what is the highest, lowest, and average payment amount for each payment type? 
SELECT PaymentTypeID
	, MAX(Amount) AS HighestPayment
	, MIN(Amount) AS LowestPayment
	, AVG(Amount) AS AveragePayment
FROM Payment
GROUP BY PaymentTypeID -- for each payment type

--8. How many students are there in each club? Show the clubID and the count
SELECT ClubID
	, COUNT(*) AS NumberOfStudents
FROM Activity
GROUP BY ClubID -- "in each club"
-- or
SELECT ClubID
	, COUNT(StudentID) AS NumberOfStudents
FROM Activity
GROUP BY ClubID -- "in each club"

--9. Which clubs have 3 or more students in them?
SELECT ClubID
FROM Activity
GROUP BY ClubID -- "in each club"
HAVING COUNT(*) >= 3 