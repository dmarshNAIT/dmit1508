--Simple Select Exercise 2
--Use IQSCHOOL Database
USE IQSchool
GO

--1.	Select the average Mark from all the Marks in the registration table
SELECT AVG(Mark) AS AverageMark
FROM Registration

--2.	Select how many students are there in the Student Table
SELECT COUNT(*) as NumberOfStudents
FROM Student

--3.	Select the average payment amount for payment type 5
SELECT AVG(Amount) AS AveragePayment
FROM Payment
WHERE PaymentTypeID = 5

--4. Select the highest payment amount
SELECT MAX(Amount) AS HighestPayment
FROM Payment

--5.	 Select the lowest payment amount
SELECT MIN(Amount) AS LowestPayment
FROM Payment

--6. Select the total of all the payments that have been made
SELECT SUM(Amount) AS TotalPayments
FROM Payment

--7. How many different payment types does the school accept?
SELECT COUNT(*) AS NumPaymentTypes
FROM PaymentType

SELECT COUNT(DISTINCT PaymentTypeID) AS NumPaymentTypes
FROM PaymentType

SELECT COUNT(DISTINCT PaymentTypeID) AS NumPaymentTypes
FROM Payment -- this works as long as we've used all the payment types

SELECT * FROM Payment
SELECT * FROM PaymentType

--8. How many students are in club 'CSS'?
SELECT COUNT(*) AS NumStudents
FROM Activity
WHERE ClubID = 'CSS'