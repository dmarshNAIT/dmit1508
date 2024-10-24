--Delete Exercise

--Use the Memories Forever database for this exercise.The script to create the tables is on Moodle if you have not competed the create tables exercise. Data is inserted into the tables when completing the Insert Exercise, and data is updated when completing the Update Exercise.
USE MemoriesForever
GO

--If a delete fails write a brief explanation why. Do not just quote the error message genereated by the server!

--1.	Delete the Staff with StaffID 8
DELETE FROM Staff
WHERE StaffID = 8
-- 0 rows affected: there is no staff 8

--2.	Delete StaffTypeId 1
DELETE FROM StaffType
WHERE StaffTypeID = 1
-- didn't work because it has a child record

--3.	Delete all the staff whose wage is less $21.66
DELETE FROM Staff
WHERE Wage < 21.66

--4.	Try and Delete StaffTypeID 1 again. Why did it work this time?
DELETE FROM StaffType
WHERE StaffTypeID = 1
-- now it works because we deleted the child record!

--5.	Delete ItemID 5
DELETE FROM Item
WHERE ItemID = 5
