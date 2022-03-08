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


-- q2:
		
INSERT INTO Item (ItemDescription, PricePerDay, ItemTypeID)
VALUES ('Canon G2', 25, 1)

INSERT INTO Item (ItemDescription, PricePerDay, ItemTypeID)
VALUES ('100W tungston', 18, 2)

INSERT INTO Item (ItemDescription, PricePerDay, ItemTypeID)
VALUES ('Super flash', 25, 4)
--Insert fails because the ItemTypeId (4) does not have a matching parent record

INSERT INTO Item (ItemDescription, PricePerDay, ItemTypeID)
VALUES ('Canon EOS20D', 30, 1)

INSERT INTO Item (ItemID, ItemDescription, PricePerDay, ItemTypeID)
VALUES (5, 'HP 630', 25, 1)
--ItemId is an identity field and as such is populated by the server not the user: we should not be passing in a value!

INSERT INTO Item (ItemDescription, PricePerDay, ItemTypeID)
VALUES ('Holdomatic', 22, 3)
GO

--q3:

INSERT INTO StaffType (StaffTypeID, StaffTypeDescription)
VALUES (1, 'Videographer')

INSERT INTO StaffType (StaffTypeID, StaffTypeDescription)
VALUES (2, 'Photographer')

INSERT INTO StaffType (StaffTypeID, StaffTypeDescription)
VALUES (1, 'Mixer')
--duplicate primary key value so insert fails

INSERT INTO StaffType (StaffTypeDescription)
VALUES ('Sales')
--Did not provide a value for the StaffTypeID field which is a NOT NULL (required) field

INSERT INTO StaffType (StafftypeID, StaffTypeDescription)
VALUES (3, 'Sales')

GO

--4.  Add the following records into the Staff Table:

--------------- NOTE: I updated the years in the provided data
						
INSERT INTO Staff (StaffID, StaffFirstName, StaffLastName, Phone, Wage, HireDate, StaffTypeID)
VALUES (1, 'Joe', 'Cool', '5551223212', 23, 'Jan 1 2022', 1)
--Check constraint on the table says that the hire date must be greater than or equal to today's date

INSERT INTO Staff (StaffID, StaffFirstName, StaffLastName, Phone, Wage, HireDate, StaffTypeID)
VALUES (1, 'Joe', 'Cool', '5551223212', 23, 'Apr 2 2022', 1)

INSERT INTO Staff (StaffID, StaffFirstName, StaffLastName, Phone, Wage, HireDate, StaffTypeID)
VALUES (2, 'Susan', 'Photo', '5556676612', 15, 'Apr 2 2022', 3)

INSERT INTO Staff (StaffID, StaffFirstName, StaffLastName, Phone, Wage, HireDate, StaffTypeID)
VALUES (3, 'Jason', 'Pic', '3332342123', 23, 'Apr 2 2022', 2)

