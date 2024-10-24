--Simple Select Exercise 2
--Use IQSCHOOL Database
USE IQSchool
GO

--1. Select the average mark from all the marks in the registration table
--2. Select how many students are there in the student table
SELECT COUNT(StudentID) AS NumStudents
	, COUNT(*) AS NumStudents
FROM Student

--3. Select the average payment amount for payment type 5
SELECT AVG(Amount) AS AveragePayment
FROM Payment
WHERE PaymentTypeID = 5

--4. Select the highest payment amount
--5. Select the lowest payment amount
--6. Select the total of all the payments that have been made
SELECT SUM(Amount) AS TotalPayments
FROM Payment

--7. How many different payment types does the school accept?
SELECT COUNT(PaymentTypeID) AS NumPaymentTypes
	, COUNT(*) AS NumPaymentTypes
FROM PaymentType

--8. How many students are in club 'CSS'?