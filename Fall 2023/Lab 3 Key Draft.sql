Use Lab3
Go
Drop Procedure If Exists AddEmployeeType
Drop Procedure If Exists UpdateService
Drop Procedure If Exists DeletePaymentType
Drop Procedure If Exists OwnersDogs
Drop Procedure If Exists UnusedServicess
Drop Procedure If Exists LookUpOwner
Drop Procedure If Exists UpdateServicePrices
Drop Procedure If Exists AddDogService
Go

-- 1.	Write a stored procedure called AddEmployeeType that accepts a Description as a parameter. Duplicate descriptions are not allowed! If the description being added is already in the EmployeeType table give an appropriate error message. Otherwise, add the new EmployeeType to the EmployeeType table and select the new EmployeeTypeID. (5 Marks)
Create Procedure AddEmployeeType
	(@Description varchar(30) = null)
As
Begin
	If @Description Is Null
		Begin
			RaisError('You must pass in a description',16,1)
		End
	Else
		Begin
			If Exists	(Select	'x'
						 From	EmployeeType
						 Where	Description = @Description)
				Begin
					RaisError('That description already exists in the EmployeeType table',16,1)
				End
			Else
				Begin
					Insert Into EmployeeType
						(Description)
					Values
						(@Description)
					If @@Error != 0
						Begin
							RaisError('Insert Into EmployeeType failed',16,1)
						End
					Else
						Begin
							Select @@Identity "New EmployeeTypeID"
						End
				End
		End
End
Return
Go

-- 2.	Write a stored procedure called UpdateService that accepts ServiceID, Name, Description, And Price as parameters. Give an error message if that service is not in the Service table. Otherwise, update the record for that service. (4 Marks)
Create Procedure UpdateService
	(@ServiceID varchar(20) = null, @Name varchar(80) = null, @Description varchar(200) = null, @Price smallmoney = null)
As
Begin
	If @ServiceID is null or @Name is null or @Description is null or @Price is null
		Begin
			RaisError('You must enter ServiceID, Name, Description, and Price', 16, 1)
		End
	Else
		Begin
			If Not Exists	(Select	'x'
							 From	Service
							 Where	ServiceID = @ServiceID)
				Begin
					RaisError('That ServiceID does not exist in the Service table', 16, 1)
				End
			Else
				Begin
					Update	Service
					Set		Name = @Name,
							Description = @Description,
							Price = @Price
					Where	ServiceID = @ServiceID
					If @@Error != 0 or @@RowCount = 0
						Begin
							RaisError('Update Service failed', 16, 1)
						End
				End
		End
End
Return
Go

-- 3.	Write a stored procedure called DeletePaymentType that accepts a PaymentTypeID as a parameter. If that PaymentType is not in the PaymentType table give an appropriate error message. If there are payments that use that PaymentType give an appropriate error message. If there are no errors delete the record from the PaymentType table. (5 Marks)
Create Procedure DeletePaymentType
	(@PaymentTypeID tinyint = null)
As
Begin
	If @PaymentTypeID Is Null
		Begin
			RaisError('You must pass in a PaymentTypeID',16,1)
		End
	Else
		Begin
			If Not Exists	(Select	'x'
							 From	PaymentType
							 Where	PaymentTypeID = @PaymentTypeID)
				Begin
					RaisError('That PaymentTypeID does not exist in the PaymentType table',16,1)
				End
			Else
				Begin
					If Exists	(Select	'x'
								 From	Payment
								 Where	PaymentTypeID = @PaymentTypeID)
						Begin
							RaisError('That PaymentTypeID is used in the Payment table, and cannot be deleted',16,1)
						End
					Else
						Begin
							Delete From PaymentType
							Where	PaymentTypeID = @PaymentTypeID
							If @@Error != 0 or @@RowCount = 0
								Begin
									RaisError('Delete From PaymentType failed',16,1)
								End
						End
				End
		End
End
Return
Go

-- 4.	Write a stored procedure called OwnersDogs that accepts an OwnerID. If the OwnerID is not a valid OwnerID give an appropriate error message, otherwise return all the Owners full names (formatted as lastname, firstname), Phone, Email, DogID’s and Names. (4 Marks)
Create Procedure OwnersDogs
	(@OwnerID int = null)
As
Begin
	If @OwnerID is Null
		Begin
			RaisError('You must pass in an OwnerID',16,1)
		End
	Else
		Begin
			If Not Exists	(Select	'x'
							 From	Owner
							 Where	OwnerID = @OwnerID)
				Begin
					RaisError('That OwnerID does not exist in the Owner table',16,1)
				End
			Else
				Begin
					Select	O.OwnerID, O.FirstName + ' ' + O.LastName "Owner Name", O.Phone, O.Email, D.DogID, D.Name
					From	Owner O
								Inner Join Dog D
									on O.OwnerID = D.OwnerID 
					Where	O.OwnerID = @OwnerID
				End
		End
End
Return
Go

-- 5.	Write a stored procedure called UnusedServicess that returns the ServiceID’s, Names and Descriptions of Services that have never been used. (2 Marks)
Create Procedure UnusedServicess
As
Begin
	Select	ServiceID, Name, Description 
	From	Service 
	Where	ServiceID Not In	(Select	ServiceID
								 From	DogService)

End
Return
Go

-- 6.	Write a stored procedure called LookUpOwner that accepts any number of leading letters of an owner’s last name. Select all the owner data for those owners from the Owner table. (2 Marks)
Create Procedure LookUpOwner
	(@LeadingLetters varchar(50) = null)
As
Begin
	If @LeadingLetters Is Null
		Begin
			RaisError('You must pass in leading letters of an owner last name',16,1)
		End
	Else
		Begin
			If Not Exists	(Select	'x'
							 From	Owner
							 Where	LastName Like @LeadingLetters + '%')			-- Optional
				Begin
					RaisError('No owner exists with those leading letters', 16, 1)	-- Optional
				End
			Else
				Begin
					Select	OwnerID, FirstName, LastName, Phone, Email, Address, City, Province, PostalCode
					From	Owner
					Where	LastName Like @LeadingLetters + '%'
				End
		End

End
Return
Go

-- 7.	Write a stored procedure called UpdateServicePrices that will accept a number. Any service that has been used less than that number of times will have their prices reduced by 10%. The reasoning is that services that are not being used and by reducing the price they may be more popular with Owners. (5 Marks)
Create Procedure UpdateServicePrices
	(@Number int = null)
As
Begin
	If @Number Is Null
		Begin
			RaisError('You must pass in a number',16,1)
		End
	Else
		Begin
			Update	Service
			Set 	Price = Price - (Price * 0.10)
			Where	ServiceID In 	(Select	ServiceID
									 From	DogService
									 Group By ServiceID
									 Having Count(ServiceID) < @Number)
			If @@Error != 0 or @@RowCount = 0
				Begin
					RaisError('Update Service failed', 16, 1)
				End
		End
End
Return
Go

-- 8.	Write a stored procedure called AddDogService that accepts a BookingID, ServiceID, Notes, and EmployeeID as parameters. At the time this service record is added the historical price will be the price of that service from the service table and the date will be the current date. The procedure will perform the following tasks:
-- a.	If there is no Booking with the supplied BookingID give an error message
-- b.	If the BookingID is an existing Booking, add a record to the DogService table
-- c.	Update the SubTotal, GST, and Total of the Order Booking
-- (10 Marks)
Create Procedure AddDogService
	(@BookingID int = null, @ServiceID varchar(20) = null, @Notes varchar(150) = null, @EmployeeID int = null)
As
Begin
	If @BookingID is null or @ServiceID is null or @Notes is null or @EmployeeID is null
		Begin
			RaisError('You must pass in a BookingID, ServiceID, Notes and EmployeeID',16,1)
		End
	Else
		Begin
			If Not Exists	(Select	'x'
							 From	Booking
							 Where	BookingID = @BookingID)
				Begin
					RaisError('That BookingID does not exist in the Booking table',16,1)
				End
			Else
				Begin
					Declare @HistoricalServicePrice smallmoney
					Select	@HistoricalServicePrice = Price
					From	Service
					Where	ServiceID = @ServiceID

					Begin Transaction
					Insert Into DogService
						(BookingID, ServiceID, Date, HistoricalServicePrice, Notes, EmployeeID)
					Values
						(@BookingID, @ServiceID, GetDate(), @HistoricalServicePrice, @Notes, @EmployeeID)
					If @@Error != 0
						Begin
							Rollback Transaction
							RaisError('Insert Into DogService failed', 16, 1)
						End
					Else
						Begin
							Update	Booking
							Set		SubTotal = SubTotal	+ @HistoricalServicePrice,
									GST = GST + @HistoricalServicePrice * 0.05,
									Total = Total + @HistoricalServicePrice * 1.05
							Where	BookingID = @BookingID
							If @@Error != 0 or @@RowCount = 0
								Begin
									Rollback Transaction
									RaisError('Update Booking failed', 16, 1)
								End
							Else
								Begin
									Commit Transaction
								End 
						End
				End
		End
End
Return
Go
