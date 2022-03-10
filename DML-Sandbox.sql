USE MemoriesForever
GO

SELECT * FROM itemType

-- let's just delete Camera record
DELETE FROM itemType
WHERE ItemTypeID = 5

-- delete all the records whose type ID is LESS THAN 3
DELETE FROM ItemType
WHERE ItemTypeID < 3

-- delete records with "a" in the description
DELETE FROM ItemType
WHERE ItemTypeDescription LIKE '%a%'

-- adding to an existing value
-- e.g. I want to add $5 to each student's balance owing
USE IQSchool
GO

UPDATE Student
SET BalanceOwing = BalanceOwing + 5