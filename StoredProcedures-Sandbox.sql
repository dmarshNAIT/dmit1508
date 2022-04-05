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

-------------------- stored procedures -------------------------
GO -- batch terminator: marks the END of a batch

CREATE PROCEDURE SillyProcedure AS
SELECT DISTINCT FirstName FROM Student
RETURN -- end of the SP

-- execute that procedure:
EXEC SillyProcedure

-- get the definition of an existing SP:
EXEC sp_helptext SillyProcedure

-- what if I want to CHANGE an existing SP?
GO

ALTER PROCEDURE SillyProcedure AS
SELECT DISTINCT FirstName + ' ' + LastName AS FullName FROM Student
RETURN 

-- how to delete an existing sp?
DROP PROCEDURE SillyProcedure
GO

-- create a procedure with parameters

CREATE PROCEDURE LookupStudent (@StudentID INT = NULL) AS -- beginning of the SP

IF @StudentID IS NULL
	BEGIN
		RAISERROR('Missing Student ID, which is a required parameter.', 16, 1)
	END
ELSE
	BEGIN
		SELECT StudentID, FirstName, LastName, Birthdate
		FROM Student
		WHERE StudentID = @StudentID
	END

RETURN -- end o the SP
GO

EXEC LookupStudent 999999999

-- can we execute with a variable as the parameter value?
DECLARE @SomeVariable INT
SET @SomeVariable = 198933540

EXEC LookupStudent @SomeVariable

-- what happens if the parameter is the wrong data type?
EXEC LookupStudent 'Bob'

----------------- global variables -----------------------
INSERT INTO Staff (StaffID, FirstName, LastName, DateHired, DateReleased, PositionID, LoginID)
VALUES (4, 'Bob', 'Smith', GetDate(), NULL, 1, NULL)

PRINT @@error

DELETE FROM Staff WHERE FirstName = 'Dana'
PRINT @@rowcount

USE MemoriesForever
GO

INSERT INTO Item (ItemDescription, PricePerDay, ItemTypeID)
VALUES ('sflsdl', 50, 1)
PRINT @@identity

GO

------------------- transactions ------------------------------

-- first, an example using ROLLBACK:
-- create our checkpoint:
BEGIN TRANSACTION

SELECT * FROM Payment
DELETE FROM Payment
SELECT * FROM Payment

ROLLBACK TRANSACTION -- take us back to what the db looked like at the start
SELECT * FROM Payment

-- now, an example using COMMIT
BEGIN TRANSACTION

SELECT * FROM Payment
DELETE FROM Payment
SELECT * FROM Payment

COMMIT TRANSACTION -- make those changes permanent
SELECT * FROM Payment

-- revisiting global variables
USE Lab3
GO

exec sp_help StaffType

INSERT INTO StaffType (StaffTypeDescription)
VALUES ('Test Description')

SELECT @@identity AS IdentityValue

SELECT * FROM StaffType











--- bonus content: how to combine numbers with varchar:
DECLARE @subtotalv2 MONEY
SET @subtotalv2 = 80.50
PRINT '$' + CAST(@subtotalv2 as VARCHAR)

-- Q: do any types of SQL have something like an array?
-- A: no, we can use temp tables for this.

-- is there something like LET?
--  not to my knowledge.