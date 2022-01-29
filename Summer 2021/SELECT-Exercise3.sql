--Simple Select Exercise 3
USE IQSchool

--1. Select the average mark for each offeringCode. Display the OfferingCode and the average mark.
SELECT OfferingCode, AVG(Mark) AS AverageMark
FROM Registration
GROUP BY OfferingCode -- for each offeringCode

--2. How many payments were made for each payment type? Display the Payment typeID and the count
SELECT PaymentTypeID
	, COUNT(*) AS NumberOfPayments
	, COUNT(DISTINCT PaymentID) AS NumberOfPaymentsVersion2
FROM Payment
GROUP BY PaymentTypeID

--3. Select the average Mark for each studentID. Display the StudentId and their average mark
SELECT StudentID, AVG(Mark) AS AverageMark
FROM Registration
GROUP BY StudentID -- "for each studentID"

--4. Select the same data as question 3 but only show the studentIDs and averages that are > 80

SELECT StudentID, AVG(Mark) AS AverageMark
FROM Registration
GROUP BY StudentID -- "for each studentID"
HAVING AVG(Mark) > 80

--5. How many students are from each city? Display the City and the count.
SELECT City, COUNT(*) AS NumberOfStudents
FROM Student
GROUP BY City

-- an alternate solution, counting unique identifiers instead of rows:
SELECT City, COUNT(DISTINCT StudentID) AS NumberOfStudents
FROM Student
GROUP BY City

--6. Which cities have 2 or more students from them? (HINT, remember that fields that we use in the where or having do not need to be selected.....)

SELECT City
FROM Student
GROUP BY City
HAVING COUNT(*) >=2

--7.what is the highest, lowest and average payment amount for each payment type? 
SELECT PaymentTypeID
	, MAX(Amount) AS HighestAmount
	, MIN(Amount) AS LowestAmount
	, AVG(Amount) AS AverageAmount
FROM Payment
GROUP BY PaymentTypeID

--8. How many students are there in each club? Show the clubID and the count

SELECT ClubID, COUNT(*) AS NumberOfStudents
FROM Activity
GROUP BY ClubId -- "in each club"

-- or:
SELECT ClubID, COUNT(DISTINCT StudentID) AS NumberOfStudents
FROM Activity
GROUP BY ClubId -- "in each club"

--9. Which clubs have 3 or more students in them?

SELECT ClubID, COUNT(*) AS NumberOfStudents
FROM Activity
GROUP BY ClubId -- "in each club"
HAVING COUNT(*) >= 3

