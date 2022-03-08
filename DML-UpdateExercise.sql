USE MemoriesForever
GO

-- q1
-- update item type 1 to be item type 5
UPDATE ItemType
SET ItemTypeID = 5
WHERE ItemTypeID = 1

SELECT * FROM itemType