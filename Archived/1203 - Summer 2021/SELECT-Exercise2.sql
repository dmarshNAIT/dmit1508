--Simple Select Exercise 2
--Use IQSCHOOL Database
USE IQSchool

--1.	Select the average Mark from all the Marks in the registration table
SELECT AVG(Mark) AS AverageMark
FROM Registration

--2.	Select how many students are there in the Student Table
SELECT COUNT(StudentID) AS NumberStudents
FROM Student
-- or:
SELECT COUNT(*) AS NumberStudents
FROM Student

--3.	Select the average payment amount for payment type 5
SELECT AVG(Amount) AS AverageAmount
FROM Payment 
WHERE PaymentTypeID = 5

--4. Select the highest payment amount
SELECT MAX(Amount) AS HighestPaymentAmount
FROM Payment

--5.	 Select the lowest payment amount
SELECT MIN(Amount) AS LowestPaymentAmount
FROM Payment

--6. Select the total of all the payments that have been made
SELECT SUM(Amount) AS TotalPayments
FROM Payment

--7. How many different payment types does the school accept?
SELECT COUNT (PaymentTypeId) AS NumberOfPaymentTypes
FROM PaymentType

SELECT COUNT(*) AS NumberOfPaymentTypes
FROM PaymentType

-- if we wanted to know how many of these types have been used:
SELECT DISTINCT PaymentTypeID -- gets rid of duplicates
FROM Payment

SELECT COUNT(*) AS NumberOfPayments -- # of records in the table
	, COUNT(PaymentTypeID) AS NumberOfPaymentsWithAPaymentTypeID
	, COUNT(DISTINCT PaymentTypeID) AS NumberOfUniquePaymentTypeIDs
FROM Payment

--8. How many students are in club 'CSS'?
SELECT COUNT (*) AS StudentsInClubCSS
FROM Activity
WHERE ClubID LIKE 'CSS'

SELECT COUNT (ClubID) AS StudentsInClubCSS
FROM Activity
WHERE ClubID LIKE 'CSS'
