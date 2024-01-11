-- Lab 3
-- Dana Marsh
USE Lab3
GO
------------------------------------------ Q1 ------------------------------------------
--Write a stored procedure called AddEmployeeType that accepts a Description as a parameter. Duplicate descriptions are not allowed! If the description being added is already in the EmployeeType table give an appropriate error message. Otherwise, add the new EmployeeType to the EmployeeType table and select the new EmployeeTypeID. (5 Marks)

-- create AddEmployeeType (@Description)
CREATE PROCEDURE AddEmployeeType (@Description VARCHAR(30) = NULL)
AS

-- check that the param is not null. (if NULL, error)
IF @Description IS NULL
	BEGIN
	RAISERROR('Missing required parameter', 16, 1)
	END
ELSE
	BEGIN

	-- check if that description has already been used. (if so, error)
	IF EXISTS (SELECT * FROM EmployeeType WHERE Description = @Description)
		BEGIN
		RAISERROR('That description has already been used', 16, 1)
		END
	ELSE
		BEGIN
		-- INSERT into EmployeeType
		INSERT INTO EmployeeType (Description)
		VALUES (@Description)

		-- check that it worked
		IF @@ERROR != 0 -- something went wrong
			BEGIN
			RAISERROR('Could not add EmployeeType', 16, 1)
			END
		ELSE -- it worked!
			BEGIN
			-- SELECT the new EmployeeTypeID
			SELECT @@IDENTITY AS 'EmployeeTypeID'
			END
		END
	END
RETURN

-- TESTING:
-- test with no params
EXEC AddEmployeeType
-- test with duplicate Desc
EXEC AddEmployeeType 'Groomer'
-- test with a good desc
EXEC AddEmployeeType 'Puffy Tail Maker'

SELECT * FROM EmployeeType
GO

------------------------------------------ Q8 ------------------------------------------
--Write a stored procedure called AddDogService that accepts a BookingID, ServiceID, notes, and EmployeeID as parameters. The procedure will perform the following tasks:
--1. If there is no Booking with the supplied BookingID give an error message
--2. If the BookingID is an existing Booking, add a record to the DogServiceTable. Date will be today’s date, and HistoricalServicePrice will be the price of that service from the service table.
--3. Update the SubTotal, GST, and Total of the Booking.

--------------- STEP 0: pseudo-code
-- check that params were provided

	-- (STEP 1) check to see if the Booking is valid 

	-- BEGIN TRANSACTION

	-- (STEP 2) INSERT a record to DogService
		-- date = today's date
		-- historicalServicePrice = comes from Service table
	-- check if it worked. if not, RAISERROR & ROLLBACK

	-- (STEP 3) UPDATE Booking table
		-- subtotal = subtotal + cost of the new service
		-- GST = 5% of the subtotal
		-- Total = subtotal + GST
	-- check if it worked. if not, RAISERROR & ROLLBACK

	-- if they both work: COMMIT TRANSACTION

CREATE PROCEDURE AddDogService (@BookingID INT = NULL, 
								@ServiceID VARCHAR(20) = NULL, 
								@Notes VARCHAR(150) = NULL,
								@EmployeeID INT = NULL)
AS

-- check that params were provided
IF (@BookingID IS NULL OR @ServiceID IS NULL OR @Notes IS NULL OR @EmployeeID IS NULL)
	BEGIN
	RAISERROR('Missing required parameter(s)', 16, 1)
	END
ELSE
	BEGIN
	-- (STEP 1) check to see if the Booking is valid 
	IF NOT EXISTS( SELECT * FROM Booking WHERE BookingID = @BookingID)
		BEGIN
		RAISERROR('That is not a valid Booking ID', 16, 1)
		END
	ELSE
		BEGIN
		BEGIN TRANSACTION

		DECLARE @HistoricalServicePrice SMALLMONEY
		SELECT @HistoricalServicePrice = Price FROM Service WHERE ServiceID = @ServiceID

		-- (STEP 2) INSERT a record to DogService
			-- date = today's date
			-- historicalServicePrice = comes from Service table
		INSERT INTO DogService (BookingID, ServiceID, Date, HistoricalServicePrice, Notes, EmployeeID)
		VALUES (@BookingID, @ServiceID, GetDate(), @HistoricalServicePrice, @Notes, @EmployeeID)

		-- check if it worked. if not, RAISERROR & ROLLBACK
		IF @@ERROR != 0
			BEGIN
			RAISERROR('Could not add service', 16, 1)
			END
		ELSE
			BEGIN
			-- (STEP 3) UPDATE Booking table
				-- subtotal = subtotal + cost of the new service
				-- GST = 5% of the subtotal
				-- Total = subtotal + GST
			UPDATE Booking
			SET Subtotal = Subtotal + @HistoricalServicePrice,
				GST = 0.05 * (Subtotal + @HistoricalServicePrice),
				Total = 1.05 * (Subtotal + @HistoricalServicePrice)
			WHERE BookingID = @BookingID

			-- check if it worked. if not, RAISERROR & ROLLBACK
			IF @@ERROR != 0
				BEGIN
				RAISERROR('Could not add service', 16, 1)
				END
			ELSE -- it worked!!
				BEGIN
				COMMIT TRANSACTION
				END
			END
		END
	END
RETURN