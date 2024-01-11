--Simple Select Exercise 2
--Use IQSCHOOL Database
USE IQSchool
GO

--1.	Select the average mark from all the marks in the registration table
SELECT AVG(Mark) AS AverageMark
FROM Registration

--2.	Select how many students are there in the student table
SELECT COUNT(*) AS NumStudents
FROM Student

SELECT COUNT(DISTINCT StudentID)  AS NumStudents
FROM Student

--3.	Select the average payment amount for payment type 5
SELECT AVG(Amount) AS AverageAmount
FROM Payment
WHERE PaymentTypeID = 5

--4.	Select the highest payment amount
SELECT MAX(Amount) AS HighestPayment
FROM Payment

--5.	Select the lowest payment amount
SELECT MIN(Amount) AS LowestPayment
FROM Payment

--6.	Select the total of all the payments that have been made
SELECT SUM(Amount) AS 'Total Payments'
FROM Payment

--7.	How many different payment types does the school accept?
SELECT COUNT(*) AS 'Number of Rows'
FROM PaymentType

SELECT COUNT(PaymentTypeID) AS 'Number of Rows with a value for Payment Type ID'
FROM PaymentType

--8.	How many students are in club 'CSS'?
SELECT COUNT(*) AS 'Number of Students'
FROM Activity
WHERE ClubId = 'CSS'