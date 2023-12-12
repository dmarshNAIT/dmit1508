--1.	Create a trigger called TR_1 to ensure that the Price in the Service table does not increase by more than 12% at a time. Should this happen, raise an error, and prevent the operation from occurring. (4 marks)

Create Trigger TR_1
on Service
for update
as
if @@rowcount > 0 and update(price)
	Begin
	if exists(Select * from inserted inner join deleted on inserted.ServiceID=deleted.ServiceID where inserted.Price>deleted.Price*1.12)
		Begin
		RaisError('You cannot increase the price by more than 12%',16,1)
		Rollback Transaction
		End
	End
Return

go
--2.	Due to limited capacity, a booking is only allowed to have a maximum of 4 Dog Services! Create a trigger called TR_2 to ensure that a booking does not have more than four Dog Services. If an attempt is made where a booking would have more than 4 Dog Servers, raise an error, and prevent the operation from occurring. (4.5 marks)
Create Trigger TR_2
on DogService
for insert,update
as
if @@ROWCOUNT>0 and update (Bookingid)
	Begin
	if exists (Select * from DogService inner join inserted on DogService.BookingID = inserted.bookingid group by DogService.BookingID having count(*) >4)
		Begin
		RaisError('A booking cannot have more than 4 services',16,1)
		Rollback Transaction
		End
	End
Return
go
--3.	To attract more clientele, Doggy Day Care wants to keep all Service Prices $100 or less! Create a trigger called TR_3 to ensure Service Prices do not go above $100. If an attempt is made to update any Service Price above $100, set that price or prices to $100. (3.5 marks)
Create Trigger TR_3
on service
for update
as
if @@rowcount>0 and update(price)
	Begin
	Update service
	set 
	price = 100 
	where ServiceID in (Select ServiceID from inserted where price >100)
	End
return
go 
--4.	In order to price services appropriately, Doggy Day Care would like to track changes to the prices of their services. Create a trigger called TR_4 to log changes to the price of Services. When the price of one or more services changes, add a record for each service that actually changed prices (prices that were updated to the same price they already were should not be logged) to the LogPriceChanges table. Show the code to create the LogPriceChanges table and the trigger. (4.5 marks) 

Create Trigger TR_4
on service
for Update
as
if @@rowcount>0 and update(price)
	Begin
	Insert into LogPriceChanges (DateAndTime,ServiceID,OldPrice,NewPrice)
	Select getdate(), inserted.serviceid, deleted.price,inserted.price from inserted inner join deleted on inserted.ServiceID = deleted.ServiceID where inserted.Price <> deleted.Price
	End
return

