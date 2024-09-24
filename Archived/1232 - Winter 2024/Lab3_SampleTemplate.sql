USE Lab3
GO

------------ Submitted by: YOUR NAME HERE

--1. Write a stored procedure called AddSpecialEvent that accepts a Description as a parameter. Duplicate descriptions are not allowed! If the description being added is already in the SpecialEvent table give an appropriate error message. Otherwise, add the new Special Event to the SpecialEvent table and select the new EventID. (5 Marks)





GO

--2. Write a stored procedure called UpdateMenuItem that accepts MenuItemID, ItemName, Description, and Price as parameters. Give an error message if that MenuItem is not in the MenuItem table. Otherwise, update the record for that MenuItem.(4 Marks)




GO

--3. Write a stored procedure called DeleteReservation that accepts a ReservationID as a parameter. If that reservation is not in the Reservation table give an appropriate error message. If there are is already a bill for that reservation give an appropriate error message. If there are no errors delete the record from the Reservation table.(5 Marks)




GO

--4. Write a stored procedure called CustomerReservations that accepts a CustomerID. If the CustomerID is not an existing CustomerID give an appropriate error message, otherwise return all the Customers full names (formatted as lastname, firstname), PhoneNumber, Email, ReservationDates and SpecialEventDescriptions. Do not return any records if the customer does not have any reservations. (4 Marks)




GO

--5. Write a stored procedure called UnusedEvents that returns the SpecialEventID’s and Descriptions of SpecialEvents that have never been used on a reservation. (2 Marks)




GO

--6. Write a stored procedure called LookUpCustomer that accepts any number of leading letters of an customers last name. Select all the customer data for those customers from the Customer table. (3 Marks)





GO

--7. Write a stored procedure called UpdateMenuItemPrices that will accepts a number. Any MenuItem that has been purchased less than that number of times will have their prices reduced by 8%. The reasoning is that MenuItems that are not being purchased, are possibly over priced, and by reducing the price they may be more popular with Customers. (4 Marks)




GO

--8. Write a stored procedure called AddToBill that accepts a BillID, MenuItemID and Quantity as parameters. The procedure will perform the following tasks:
	--1.	If there is no Bill with the provided BillID give an error message “A bill must be created before items can be added to the bill”
	--2.	If the BillID is an existing Bill, add a record to the BillItem. Remember the prices of the MenuItems can be found in the MenuItem table.
	--3.	Update the SubTotal, GST, and Total of the Booking. This procedure will not use Tip in any of the calculations.
	--(10 Marks)






GO
