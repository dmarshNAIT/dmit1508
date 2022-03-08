USE MemoriesForever
GO
-- q1:
INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (1, 'Camera')

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (2, 'Lights')

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (3, 'Stand')

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (2, 'Backdrop')
-- fails because the PK is not unique

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (89899985225, 'Outfit')
-- ItemTypeID was too big for an int to hold, so this failed

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES ('4A', 'Other')
-- 4A is a string, and ItemTypeID expects a numeric field

-- view contents of table:
SELECT * FROM ItemType