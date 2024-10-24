--Insert Exercise
--Use the Memories Forever database for this exercise. The script to create the tables is on Moodle if you have not competed the create tables exercise.
USE MemoriesForever
GO

--If an insert fails write a brief explanation why. Do not just quote the error message generated by the server!

--1. Add the following records into the ItemType Table:

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (1, 'Camera')

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (2, 'Lights')

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (3, 'Stand')

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (2, 'Backdrop') -- fails: PK is not unique

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (89899985225, 'Outfit') -- fails: this # is too big to be an INT

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES ('4A', 'Other') -- fails: '4A' is not numeric


--2. Add the following records into the Item Table:

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
VALUES ('Light Holdomatic', 22, 3)
			

--3. Add the following records into the StaffType Table:

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
	
	

--4. Add the following records into the Staff Table:


INSERT INTO Staff (StaffID, StaffFirstName, StaffLastName, Phone, Wage, HireDate, StaffTypeID)
VALUES (1, 'Joe', 'Cool', '5551223212', 23, 'Jan 1 2023', 1)
--Check constraint on the table says that the hire date must be greater than or equal to today's date

INSERT INTO Staff (StaffID, StaffFirstName, StaffLastName, Phone, Wage, HireDate, StaffTypeID)
VALUES (1, 'Joe', 'Cool', '5551223212', 23, 'Mar 2 2024', 1)

INSERT INTO Staff (StaffID, StaffFirstName, StaffLastName, Phone, Wage, HireDate, StaffTypeID)
VALUES (2, 'Susan', 'Photo', '5556676612', 15, 'Feb 25 2024', 3)

INSERT INTO Staff (StaffID, StaffFirstName, StaffLastName, Phone, Wage, HireDate, StaffTypeID)
VALUES (3, 'Jason', 'Pic', '3332342123', 23, 'Jun 19 2024', 2)

