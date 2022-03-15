USE IQSchool
GO

------------------ variables ----------------------------
-- create a variable:
DECLARE @FirstName VARCHAR(40)
-- give the variable a value
-- "assigning" a value to the variable
SET @FirstName = 'Bob'

-- what if we have multiple variables we want to to assign *at the same time*? We must use SELECT
DECLARE @MiddleName VARCHAR(40)
	, @LastName VARCHAR(40)
SELECT @MiddleName = 'J'
	, @LastName = 'Smith'

-- we can also use the results of a query to assign a value.
SELECT @FirstName = FirstName FROM Staff WHERE StaffID = 1

SELECT @FirstName AS 'slsfdlksdflkjsdf'

PRINT @FirstName -- to debug or test our code

----------------- add flow control ---------------------------
DECLARE @Subtotal MONEY
SET @Subtotal = 80.50

IF @Subtotal > 100
	BEGIN 
		PRINT 'That is a large subtotal!'
	END
ELSE -- this only executes if the condition was FALSE
	BEGIN
		PRINT 'That is a small subtotal.'
	END

-- IF EXISTS:
IF EXISTS (SELECT * FROM Staff WHERE StaffID = 1)
	BEGIN
	PRINT 'That staff exists'
	END

IF EXISTS (SELECT * FROM Staff WHERE StaffID = 1456 AND FirstName = 'Bob')
	BEGIN
	PRINT 'That staff exists'
	END
ELSE
	BEGIN
	PRINT 'That staff does NOT exist'
	END









--- bonus content: how to combine numbers with varchar:
DECLARE @subtotalv2 MONEY
SET @subtotalv2 = 80.50
PRINT '$' + CAST(@subtotalv2 as VARCHAR)

-- do any types of SQL have something like an array?
-- is there something like LET?