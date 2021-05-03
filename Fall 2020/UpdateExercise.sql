--UPDATE EXERCISE
-- Author: Dana Marsh

USE MemoriesForever

--1. Update the following records in the ItemType Table:

UPDATE ItemType
SET ItemTypeID = 5
WHERE ItemTypeID = 1 -- FAILs because it has related child record(s)

UPDATE ItemType
SET ItemTypeDescription = 'Bright Lights'
WHERE ItemTypeID = 2

SELECT * FROM ItemType
SELECT * FROM Item

GO
--2. Update the following records in the Item Table:

UPDATE Item
SET PricePerDay = 30
	, ItemDescription = 'Canon G3'
WHERE ItemID = 1

UPDATE Item
SET ItemTypeID = 5
WHERE ItemID = 4 -- FAILs because there is no matching record in the parent table

UPDATE Item
SET PricePerDay = 30
WHERE ItemID = 4

GO

--3.  Update the following records in the Staff Table:
SELECT * FROM Staff

UPDATE Staff
SET Wage = 19
WHERE StaffID = 1

UPDATE Staff
SET StaffLastName = 'Pic'
	, Wage = 23
WHERE StaffID = 2

UPDATE Staff
SET Wage = 80
WHERE StaffID = 12 -- no rows affected because there is no StaffID = 12
 

