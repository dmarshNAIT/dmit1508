-- Author: Dana Marsh
--INSERT EXERCISE
--Use the Memories Forever database for this exercise.The current solution has the script to create it if you have not competed the create tables exercise.
--If an insert fails write a brief explanation why. Do not just quote the error message genereated by the server!

USE MemoriesForever

--1. Add the following records into the ItemType Table:

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (1, 'Camera')

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (2, 'Lights')

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (3, 'Stand')

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (2, 'Backdrop') -- FAILS bc duplicate PK

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (89899985225, 'Outfit') -- FAILs b/c that # is larger than datatype

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES ('4A', 'Other') -- FAILS bc of datatype mismatch

SELECT * FROM ItemType
EXEC sp_help ItemType	

GO

--2. Add the following records into the Item Table:

INSERT INTO Item (ItemDescription, PricePerDay, ItemTypeID)
VALUES ('Canon G2', 25, 1)

INSERT INTO Item (ItemDescription, PricePerDay, ItemTypeID)
VALUES ('100W tungston', 18, 2)

INSERT INTO Item (ItemDescription, PricePerDay, ItemTypeID)
VALUES ('Super Flash', 35, 4) -- FAILS bc there is no ItemTypeID = 4 in the parent table

INSERT INTO Item (ItemDescription, PricePerDay, ItemTypeID)
VALUES ('Canon EOS20D', 30, 1)

INSERT INTO Item (ItemID, ItemDescription, PricePerDay, ItemTypeID)
VALUES (5, 'HP 630', 25, 1) -- FAILS bc ItemID is identity

INSERT INTO Item (ItemDescription, PricePerDay, ItemTypeID)
VALUES ('Light Holdomatic', 22, 3)

SELECT * FROM Item	

GO

--3.  Add the following records into the StaffType Table:

INSERT INTO StaffType (StaffTypeID, StaffTypeDescription)
VALUES (1, 'Videographer')

INSERT INTO StaffType (StaffTypeID, StaffTypeDescription)
VALUES (2, 'Photographer')

INSERT INTO StaffType (StaffTypeID, StaffTypeDescription)
VALUES (1, 'Mixer') -- FAILS bc duplicate PK

INSERT INTO StaffType (StaffTypeDescription)
VALUES ('Sales') -- FAILs because StaffTypeID cannot be NULL

INSERT INTO StaffType (StaffTypeID, StaffTypeDescription)
VALUES (3, 'Sales')

SELECT * FROM StaffType
EXEC sp_help StaffType

GO

--4.  Add the following records into the Staff Table:

INSERT INTO Staff (StaffID, StaffFirstName, StaffLastName, Phone, Wage, HireDate, StaffTypeID)
VALUES (1, 'Joe', 'Cool', '5551223212', 23, 'Jan 1 2007', 1) -- FAILS b/c HireDate must be today or later

INSERT INTO Staff (StaffID, StaffFirstName, StaffLastName, Phone, Wage, HireDate, StaffTypeID)
VALUES (1, 'Joe', 'Cool', '5551223212', 23, 'Apr 2 2021', 1) 

INSERT INTO Staff (StaffID, StaffFirstName, StaffLastName, Phone, Wage, HireDate, StaffTypeID)
VALUES (2, 'Sue', 'Photo', '5556676612', 15, 'Apr 2 2021', 3)

INSERT INTO Staff (StaffID, StaffFirstName, StaffLastName, Phone, Wage, HireDate, StaffTypeID)
VALUES (3, 'Jason', 'Pic', '3332342123', 23, 'Apr 2 2021', 2)

SELECT * FROM Staff
EXEC sp_help Staff

GO