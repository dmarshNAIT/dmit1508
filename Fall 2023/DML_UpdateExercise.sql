--Update Exercise
--Use the Memories Forever database for this exercise.The script to create the tables is on Moodle if you have not competed the create tables exercise. Data is inserted into the tables when completing the Insert Exercise.
USE MemoriesForever
GO
--If an update fails write a brief explanation why. Do not just quote the error message genereated by the server!

--1. Update the following records in the ItemType Table:
UPDATE ItemType
SET ItemTypeID = 5
WHERE ItemTypeID = 1
--Fails: Changing the Primary key value causes a related recorded in Item to lose its parent record in ItemType. 
--Updating the primary key value is not recomended!!!!

UPDATE ItemType
SET ItemTypeDescription = 'Bright Lights'
WHERE ItemTypeID = 2
GO

--2. Update the following records in the Item Table:

--•	ItemID 1 is now $30/day and called a Canon G3
--•	ItemID 4 is now ItemTypeID 5
--•	ItemID 4 is now $30/day

UPDATE Item
SET PricePerDay = 30, ItemDescription = 'Canon G3'
WHERE ItemID = 1

UPDATE Item
SET ItemTypeID = 5
WHERE ItemID = 4
--Fails: There is no ItemTypeId 5. Foreign Key values must have a matching value in the parent table.

UPDATE Item
SET PricePerDay = 30
WHERE ItemID = 4
GO


--3. Update the following records in the Staff Table:

--•	StaffID 1 should have a wage of $19.00
--•	StaffID 2 got married to StaffID 3! Update StaffID 2 with the following changes:
--StaffLastName: Pic
--Wage: $23.00
--•	Update StaffID 12 to have a wage of 80 (note the message displayed)

UPDATE Staff
SET Wage = 19
WHERE StaffID = 1

UPDATE Staff
SET StaffLastName = 'Pic', Wage = 23
WHERE StaffID = 2

UPDATE Staff
SET Wage = 80
WHERE StaffID = 12
-- 0 rows affected: because there is no StaffID 12. No records matched our filter.