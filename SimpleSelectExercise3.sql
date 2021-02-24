--Simple Select Exercise 3
USE IQSchool
GO

--1. Select the average mark for each offeringCode. Display the OfferingCode and the average mark.
SELECT OfferingCode
	, AVG(Mark) AS AverageMark
FROM Registration
GROUP BY OfferingCode


--2. How many payments were made for each payment type. Display the Payment typeID and the count
SELECT PaymentTypeID
	, COUNT(DISTINCT PaymentID) AS NumberPayments
	-- OR COUNT(*)
FROM Payment
GROUP BY PaymentTypeID

--3. Select the average Mark for each studentID. Display the StudentId and their average mark
SELECT StudentID
	, AVG(Mark) AS AverageMark
FROM Registration
GROUP BY StudentID -- "for each StudentID"

--4. Select the same data as question 3 but only show the studentIDs and averages that are > 80
SELECT StudentID
	, AVG(Mark) AS AverageMark
FROM Registration
GROUP BY StudentID 
HAVING AVG(Mark) > 80 -- HAVING is a filter for aggregate functions

--5. How many students are from each city? Display the City and the count.
--6. Which cities have 2 or more students from them? (HINT, remember that fields that we use in the where or having do not need to be selected.....)

--7.what is the highest, lowest and average payment amount for each payment type? 
--8. How many students are there in each club? Show the clubID and the count
--9. Which clubs have 3 or more students in them?

