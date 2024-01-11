--INSERT EXERCISE
--Use the Memories Forever database for this exercise.The current solution has the script to create it if you have not competed the create tables exercise.
USE MemoriesForever
GO
--If an insert fails write a brief explanation why. Do not just quote the error message genereated by the server!

--1. Add the following records into the ItemType Table:

--ItemTypeID	ItemTypeDescription
--1		Camera
--2		Lights
--3 	Stand
--2		Backdrop
--89899985225	Outfit
--4A	Other

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (1, 'Camera')

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (2, 'Lights')

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (3, 'Stand')

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (2, 'backdrop')
--duplicate primary key value so insert fails

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (89899985225, 'outfit')
--ItemTypeId is larger than the int datatype for that field

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES ('4A', 'Other')
	--4A is a string and the ItemTypeID is an integer field
GO


--2. Add the following records into the Item Table:


--ItemID	ItemDescription	PricePerDay	ItemTypeID
--	Canon		G2	25	1
--	100W tungston	18	2
--	Super Flash	25	4
--	Canon EOS20D	30	1
--5	HP 630	25	1
--	Light Holdomatic	22	3
			
INSERT INTO Item (ItemDescription, PricePerDay, ItemTypeID)
VALUES ('Canon G2', 25, 1)

INSERT INTO Item (ItemDescription, PricePerDay, ItemTypeID)
VALUES ('100W tungston', 18, 2)

INSERT INTO Item (ItemDescription, PricePerDay, ItemTypeID)
VALUES ('Super flash', 25, 4)
--Insert fails because the ItemTypeId (4) does not have a matching parent value in the relationship

INSERT INTO Item (ItemDescription, PricePerDay, ItemTypeID)
VALUES ('Canon EOS20D', 30, 1)

INSERT INTO Item (ItemID, ItemDescription, PricePerDay, ItemTypeID)
VALUES (5, 'HP 630', 25, 1)
--ItemId is an identity field and as such is populated by the server not the user.

INSERT INTO Item (ItemDescription, PricePerDay, ItemTypeID)
VALUES ('Holdomatic', 22, 3)
GO

--3.  Add the following records into the StaffType Table:

--StaffTypeID	StaffTypeDescription
--1	Videographer
--2	Photographer
--1	Mixer
-- 	Sales
--3	Sales
	
INSERT INTO StaffType (StaffTypeID, StaffTypeDescription)
VALUES (1, 'Videographer')

INSERT INTO StaffType (StaffTypeID, StaffTypeDescription)
VALUES (2, 'Photographer')

INSERT INTO StaffType (StaffTypeID, StaffTypeDescription)
VALUES (1, 'Mixer')
--duplicate primary key value so insert fails

INSERT INTO StaffType (StaffTypeDescription)
VALUES ('Sales')
--Did not provide a value for the StaffTypeID field which is a not null field

INSERT INTO StaffType (StafftypeID, StaffTypeDescription)
VALUES (3, 'Sales')

GO

--4.  Add the following records into the Staff Table:

--StaffID	StaffFirstName	StaffLastName	Phone	Wage	HireDate	StaffTypeID
--1	Joe	Cool	5551223212	23	Jan 1 2021	1
--1	Joe	Cool	5551223212	23	Apr 2 2021	1
--2	Sue	Photo	5556676612	15	Apr 2 2021	3
--3	Jason	Pic	3332342123	23	Apr 2 2021	2
						
INSERT INTO Staff (StaffID, StaffFirstName, StaffLastName, Phone, Wage, HireDate, StaffTypeID)
VALUES (1, 'Joe', 'Cool', '5551223212', 23, 'Jan 1 2021', 1)
--Check constraint on the table says that the hire date must be greater than or equal to today's date

INSERT INTO Staff (StaffID, StaffFirstName, StaffLastName, Phone, Wage, HireDate, StaffTypeID)
VALUES (1, 'Joe', 'Cool', '5551223212', 23, 'Apr 2 2021', 1)

INSERT INTO Staff (StaffID, StaffFirstName, StaffLastName, Phone, Wage, HireDate, StaffTypeID)
VALUES (2, 'Susan', 'Photo', '5556676612', 15, 'Apr 2 2021', 3)

INSERT INTO Staff (StaffID, StaffFirstName, StaffLastName, Phone, Wage, HireDate, StaffTypeID)
VALUES (3, 'Jason', 'Pic', '3332342123', 23, 'Apr 2 2021', 2)

