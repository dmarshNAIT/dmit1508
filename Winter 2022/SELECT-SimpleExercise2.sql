--Simple Select Exercise 2
--Use IQSCHOOL Database
USE IQSchool
GO

--1. Select the average Mark from all the Marks in the registration table
SELECT Avg(Mark) AS AverageMark
FROM Registration

--2. Select how many students are there in the Student Table
SELECT COUNT(*) AS NumberOfStudents
FROM Student
-- or
SELECT COUNT(StudentID) AS NumberOfStudents
FROM Student

--3. Select the average payment amount for payment type 5
SELECT Avg(Amount) AS AveragePaymentAmount
FROM Payment
WHERE PaymentTypeID = 5

--4. Select the highest payment amount
SELECT MAX(Amount) AS HighestPaymentAmount
FROM Payment

--5. Select the lowest payment amount
SELECT MIN(Amount) AS LowestPaymentAmount
FROM Payment

--6. Select the total of all the payments that have been made
SELECT SUM(Amount) AS TotalPayments
FROM Payment

--7. How many different payment types does the school accept?
Select COUNT(PaymentTypeID) AS 'Total Number of Types of Payment' from PaymentType
-- or
SELECT COUNT(*) AS NumberofPaymentType
FROM PaymentType

-- if we wanted to know how many different payment types have been used:
SELECT DISTINCT (PAYMENTTYPEID) FROM Payment -- 6 rows
-- or
SELECT COUNT(DISTINCT PaymentTypeID) AS NumberOfPaymentTypes
FROM Payment

--8. How many students are in club 'CSS'?
SELECT COUNT(*) AS NumberOfStudents
FROM Activity 
WHERE ClubId = 'CSS'
