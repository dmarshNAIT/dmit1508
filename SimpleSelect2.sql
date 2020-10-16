-- Author: Dana Marsh
--Simple Select Exercise 2
--Use IQSCHOOL Database
USE [IQ-School]

--1.	Select the average Mark from all the Marks in the registration table
SELECT AVG(Mark) AS AverageMark
FROM Registration

--2.	Select how many students are there in the Student Table
SELECT COUNT(*) AS NumberStudents
FROM Student

--3.	Select the average payment amount for payment type 5
SELECT AVG(Amount) AS AverageAmount
FROM Payment
WHERE PaymentTypeID = 5

--4. Select the highest payment amount
SELECT MAX(Amount) AS HighestAmount
FROM Payment

--5.	 Select the lowest payment amount
SELECT MIN(Amount) AS LowestAmount
FROM Payment

--6. Select the total of all the payments that have been made
SELECT SUM(Amount) AS TotalAmount
FROM Payment

--7. How many different payment types does the school accept?
SELECT COUNT(*) AS NumOfPaymentType
FROM PaymentType

SELECT COUNT(DISTINCT PaymentTypeDescription) AS NumOfPaymentType
FROM PaymentType

SELECT COUNT(DISTINCT PaymentTypeId) AS NumOfPaymentTypeFROM Payment -- if we know all payment types have been used

--8. How many students are in club 'CSS'?
SELECT COUNT(*) AS NumberStudents
FROM Activity
WHERE ClubId = 'CSS'

--SELECT COUNT(StudentID) AS NumberStudents
--FROM Activity
--WHERE ClubId = 'CSS'


