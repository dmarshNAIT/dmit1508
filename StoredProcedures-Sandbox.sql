-- variables

-- creating a variable:
DECLARE @FirstName VARCHAR(30)
-- assign a value using a literal:
SET @FirstName = 'Bob'

-- creating multiple variables:
DECLARE @MiddleName VARCHAR(30)
	, @LastName VARCHAR(30)
SELECT @MiddleName = 'J'
	, @LastName = 'Smith'

-- assigning a value from a query:
SELECT @LastName = LastName
	FROM Staff
	WHERE StaffID = 1
PRINT @LastName -- for debugging & testing purposes

-- if/else
DECLARE @Total INT
SET @Total = 75

IF @Total > 100
	BEGIN
	PRINT 'Value is greater than 100'
	END
ELSE
	BEGIN
	PRINT 'Value is NOT greater than 100'
	END

-- if exists
IF EXISTS (SELECT * FROM Staff WHERE StaffID = 5)
	BEGIN
	PRINT 'That staff member exists'
	END
ELSE
	BEGIN
	PRINT 'That staff does NOT exist'
	END