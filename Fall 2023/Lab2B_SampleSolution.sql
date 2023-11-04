USE Lab2B
GO

--a.	Select the first name and last name (as one column) and phone number from Owner with owner id 3. (1 mark)
SELECT firstname + ' ' + lastname AS 'Owner'
	,phone
FROM OWNER
WHERE ownerid = 3

--b.	For all owners, select the owners first name, last name, and the number of dogs they have. (3 marks)
SELECT firstname
	,lastname
	,count(dogid)AS  'DogCount'
FROM OWNER
LEFT OUTER JOIN dog ON OWNER.OwnerID = dog.OwnerID
GROUP BY OWNER.ownerid
	,firstname
	,lastname

--c.	Select the average CostPerHour of the services.(1 mark)
SELECT avg(Price) AS 'Average'
FROM Service

--d.	Create a single list of all the owner and staff first names and last names in descending order by last name.(2 marks)
SELECT firstname
	,lastname
FROM OWNER

UNION ALL

SELECT firstname
	,lastname
FROM Employee
ORDER BY LastName DESC

--e.	Select the paymentTypeID and description for all the payment types that have been used on more than 3 payments.(4 marks)
SELECT paymenttype.paymenttypeid
	,description
FROM PaymentType
INNER JOIN payment ON PaymentType.PaymentTypeID = Payment.PaymentTypeID
GROUP BY paymenttype.PaymentTypeID
	,Description
HAVING count(*) > 3

--f.	Select BookingID, StartDate, EndDate, OwnerID, Full Name(one column), Full Address (one column), sub, GST, total, DogID, Dog Name for Booking ID 4.
SELECT bookingid
	,startdate
	,enddate
	,OWNER.ownerid
	,firstname + ' ' + lastname AS 'Owner'
	,Address + ' ' + city + ' ' + province + ' ' + postalcode
	,subtotal
	,gst
	,total
	,dog.dogid
	,name
FROM booking
INNER JOIN dog ON booking.DogID = dog.DogID
INNER JOIN OWNER ON OWNER.OwnerID = dog.DogID
WHERE booking.BookingID = 4

--g.	Select all the Dog ID’s and Names whose name starts with ‘R’. (2 marks)
SELECT dogid
	,name
FROM dog
WHERE name LIKE 'r%'

--h.	Select the Service ID and Name of the services that have never been used on a Booking.(2 marks)
SELECT serviceid
	,name
FROM service
WHERE serviceid NOT IN (
		SELECT serviceid
		FROM DogService
		)

--i.	How many Employees are there for each Employee Type? Select the EmployeeTypeID, Description and the Count.(3 marks)
SELECT employeetype.EmployeeTypeid
	,description
	,count(employeeid) AS  'Count'
FROM EmployeeType
LEFT OUTER JOIN Employee ON EmployeeType.EmployeeTypeID = Employee.EmployeeTypeID
GROUP BY Employeetype.EmployeeTypeID
	,Description

--Views
--1.	Create a view called EmployeeServices that contains EmployeeID, FirstName, LastName, BookingID, ServiceID, Date of the Service, Description, for all employees that have performed at least one service.
--(2 marks)
GO
DROP VIEW IF EXISTS EmployeeServices
GO
CREATE VIEW EmployeeServices
AS
SELECT Employee.EmployeeID
	,firstname
	,lastname
	,booking.bookingid
	,service.serviceid
	,DATE
	,description
FROM employee
INNER JOIN DogService ON Employee.EmployeeID = DogService.EmployeeID
INNER JOIN booking ON booking.BookingID = DogService.BookingID
INNER JOIN service ON service.ServiceID = DogService.ServiceID

GO

--2.	Using the EmployeeServices view, select the EmployeeID, FirstName, LastName, and the total number of services each employee has performed.
--(2 marks)
SELECT Employeeid
	,firstname
	,lastname
	,count(bookingid) AS 'Count'
FROM EmployeeServices
GROUP BY EmployeeID
	,firstname
	,lastname

--DML:
--1.	Insert the following records in the service table given the following data:
--(1 marks)
INSERT INTO Service (
	ServiceID
	,Name
	,Description
	,Price
	)
VALUES (
	'Obedience10'
	,'Obedience Training'
	,'Basic Obedience Training'
	,(
		SELECT avg(price)
		FROM Service
		)
	)

--2.	Increase the Price of all the services that have the word Grooming in their description by 8%. (2 marks)
UPDATE service
SET price = Price * 1.08
WHERE description LIKE '%grooming%'

--3.	Change the description to Basic Grooming and the Price to 45.00 for the Service with ServiceID Groom01 (2 marks)
UPDATE service
SET Description = 'Basic Grooming'
	,Price = 45
WHERE serviceid = 'Groom01'

--4.	Delete the services that have never been used. (2 marks)
DELETE service
WHERE serviceid NOT IN (
		SELECT serviceid
		FROM dogservice
		)