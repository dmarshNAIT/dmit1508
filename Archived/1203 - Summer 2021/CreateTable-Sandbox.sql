CREATE TABLE Angel (

	AngelID INT, 
	Age INT

)

---------------------------------------------------------------- Orders example ----------------------------------------------------------------

-- create the Customers table

CREATE TABLE Customers (
	CustomerNumber	INT IDENTITY(1,1)	NOT NULL -- CustomerNumber is an integer, it's a technical key, and it's required
,	LastName		VARCHAR(30)			NOT NULL -- LastName is required
,	FirstName		VARCHAR(30)			NOT NULL -- FirstName is required
,	Phone			CHAR(12)			NULL -- Phone is optional and in the format of 780-123-4567		
)

-- create the Orders table

CREATE TABLE Orders (
	OrderNumber		INT	IDENTITY(1,1)	NOT NULL
,	OrderDate		DATETIME			NOT NULL
,	Subtotal		MONEY				NOT NULL
,	GST				MONEY				NOT NULL
,	Total			MONEY				NOT NULL
,	CustomerNumber	INT					NOT NULL
)

-- create the associative entity table:
CREATE TABLE ItemOnOrder (
	OrderNumber INT NOT NULL,
	ItemNumber INT NOT NULL,
	Quantity INT NOT NULL,
	Price MONEY NOT NULL,
	Amount MONEY NOT NULL,
)

-- create the Items table
CREATE TABLE Items (
	ItemNumber INT IDENTITY(1,1) NOT NULL
	, [Description] VARCHAR(150) NOT NULL
	, CurrentPric MONEY NOT NULL -- typo on purpose!
)

-- oops, typo, must delete the Items table:
DROP TABLE Items

-- now we can recreate the Items table
CREATE TABLE Items (
	ItemNumber INT IDENTITY(1,1) NOT NULL
	, [Description] VARCHAR(150) NOT NULL
	, CurrentPrice MONEY NOT NULL -- without the typo
)

-- verify the table:
EXEC SP_HELP Items