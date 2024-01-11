USE Lab2B
GO

-- remove any old versions of tables
DROP TABLE IF EXISTS DogService
DROP TABLE IF EXISTS Employee
DROP TABLE IF EXISTS EmployeeType
DROP TABLE IF EXISTS Service
DROP TABLE IF EXISTS Payment
DROP TABLE IF EXISTS PaymentType
DROP TABLE IF EXISTS Booking
DROP TABLE IF EXISTS Dog
DROP TABLE IF EXISTS Owner
	
-- create new tables
CREATE TABLE Owner (
	OwnerID INT NOT NULL identity(1, 1) CONSTRAINT pk_Owner PRIMARY KEY
	,FirstName VARCHAR(30) NOT NULL
	,LastName VARCHAR(30) NOT NULL
	,Phone CHAR(13) NOT NULL CONSTRAINT ck_Owner_Phone CHECK (Phone LIKE '([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
	,Email VARCHAR(40) NOT NULL
	,Address VARCHAR(30) NOT NULL
	,City VARCHAR(30) NOT NULL
	,Province CHAR(2) NOT NULL CONSTRAINT ck_Owner_Province CHECK (Province LIKE '[a-z][a-z]') CONSTRAINT df_Province DEFAULT 'AB'
	,PostalCode CHAR(7) NOT NULL CONSTRAINT ck_Owner_PostalCode CHECK (PostalCode LIKE '[a-z][0-9][a-z] [0-9][a-z][0-9]')
	)

CREATE TABLE Dog (
	DogID INT NOT NULL identity(1, 1) CONSTRAINT pk_Dog PRIMARY KEY
	,Name VARCHAR(30) NOT NULL
	,Breed VARCHAR(30) NOT NULL
	,DOB DATE NOT NULL
	,Color VARCHAR(20) NOT NULL
	,OwnerID INT NOT NULL CONSTRAINT fk_DogToOwner REFERENCES OWNER (OwnerID)
	)

CREATE TABLE Booking (
	BookingID INT NOT NULL identity(1, 1) CONSTRAINT pk_Booking PRIMARY KEY
	,StartDate DATE NOT NULL
	,EndDate DATE NOT NULL
	,Days TINYINT NOT NULL
	,BoardingTotal SMALLMONEY NOT NULL
	,ServicesTotal SMALLMONEY NOT NULL
	,SubTotal SMALLMONEY NOT NULL CONSTRAINT ck_Booking_SubTotal CHECK (SubTotal >= 0)
	,GST SMALLMONEY NOT NULL
	,Total SMALLMONEY NOT NULL
	,DogID INT NOT NULL CONSTRAINT fk_BookingToDog REFERENCES Dog(DogID)
	,CONSTRAINT ck_Booking_EndDate_StartDate CHECK (EndDate > StartDate)
	)

CREATE TABLE PaymentType (
	PaymentTypeID TINYINT NOT NULL identity(1, 1) CONSTRAINT pk_PaymentType PRIMARY KEY
	,Description VARCHAR(20) NOT NULL
	)

CREATE TABLE Payment (
	PaymentID INT NOT NULL identity(1, 1) CONSTRAINT pk_Payment PRIMARY KEY
	,BookingID INT NOT NULL CONSTRAINT fk_PaymentToBooking REFERENCES Booking(BookingID)
	,Amount SMALLMONEY NOT NULL
	,DATE DATE NOT NULL
	,PaymentTypeID TINYINT NOT NULL CONSTRAINT fk_PaymentToPaymentType REFERENCES PaymentType(PaymentTypeID)
	)

CREATE TABLE Service (
	ServiceID VARCHAR(20) NOT NULL CONSTRAINT pk_Service PRIMARY KEY
	,Name VARCHAR(80) NOT NULL
	,Description VARCHAR(200) NOT NULL
	,Price SMALLMONEY NOT NULL
	)

CREATE TABLE EmployeeType (
	EmployeeTypeID TINYINT NOT NULL identity(1, 1) CONSTRAINT pk_EmployeeType PRIMARY KEY
	,Description VARCHAR(30) NOT NULL
	)

CREATE TABLE Employee (
	EmployeeID INT NOT NULL identity(1, 1) CONSTRAINT pk_Employee PRIMARY KEY
	,FirstName VARCHAR(20) NOT NULL
	,LastName VARCHAR(20) NOT NULL
	,EmployeeTypeID TINYINT NOT NULL REFERENCES EmployeeType(EmployeeTypeID)
	)

CREATE TABLE DogService (
	BookingID INT NOT NULL
	,ServiceID VARCHAR(20) NOT NULL CONSTRAINT fk_DogServiceToService REFERENCES Service(ServiceID)
	,DATE DATE NOT NULL
	,HistoricalServicePrice SMALLMONEY NOT NULL
	,Notes VARCHAR(150) NULL
	,EmployeeID INT NULL CONSTRAINT fk_DogServiceToEmployee REFERENCES Employee(EmployeeID)
	,CONSTRAINT pk_DogService PRIMARY KEY (
		BookingID
		,ServiceID
		)
	)
GO

-- run alter statements:
ALTER TABLE Employee ADD Email VARCHAR(50) NULL CONSTRAINT ck_Employee_Email CHECK (Email LIKE '%@%')
GO

ALTER TABLE Dog ADD Dangerous CHAR(1) NOT NULL 
	CONSTRAINT ck_Dog_Dangerous CHECK (Dangerous = 'N' OR Dangerous = 'Y') 
	CONSTRAINT df_Dangerous DEFAULT 'N'
GO

-- add indexes on each FK
CREATE NONCLUSTERED INDEX IX_Dog_OwnerID ON Dog (OwnerID)

CREATE NONCLUSTERED INDEX IX_Booking_DogID ON Booking (DogID)

CREATE NONCLUSTERED INDEX IX_Payment_BookingID ON Payment (BookingID)

CREATE NONCLUSTERED INDEX IX_Payment_PaymentTypeID ON Payment (PaymentTypeID)

CREATE NONCLUSTERED INDEX IX_DogService_BookingID ON DogService (BookingID)

CREATE NONCLUSTERED INDEX IX_DogService_ServiceID ON DogService (ServiceID)

CREATE NONCLUSTERED INDEX IX_DogService_EmployeeID ON DogService (EmployeeID)

CREATE NONCLUSTERED INDEX IX_Employee_EmployeeTypeID ON Employee (EmployeeTypeID)

-- insert data:
--Owner
INSERT INTO OWNER (FirstName, LastName, Phone, Email, Address, City, Province, PostalCode)
VALUES 
('James', 'Bond', '(777)555-1234', 'james.bond@example.com', 'MI6 Headquarters', 'London', 'AB', 'T8E 1G6'), 
('Indiana', 'Jones', '(221)555-5678', 'indiana.jones@example.com', '123 Artifact Street', 'New York', 'AB', 'T8D 1G1'), 
('Luke', 'Skywalker', '(231)555-9876', 'luke.skywalker@example.com', '123 Tatooine Way', 'Mos Eisley', 'AB', 'T8A 1G6'), 
('Hermione', 'Granger', '(231)555-4321', 'hermione.granger@example.com', '4 Privet Drive', 'London', 'AB', 'T8E 5G6'), 
('Tony', 'Stark', '(231)555-8765', 'tony.stark@example.com', '10880 Malibu Point', 'Malibu', 'AB', 'T8E 1S6'), 
('Ellen', 'Ripley', '(231)555-3456', 'ellen.ripley@example.com', 'Nostromo Spaceship', 'Outer Space', 'AB', 'T1E 1G6'), 
('Harry', 'Potter', '(231)555-7890', 'harry.potter@example.com', '4 Privet Drive', 'London', 'AB', 'T8E 1J6'),
('Leia', 'Organa', '(231)555-6543', 'leia.organa@example.com', '456 Rebel Base', 'Alderaan', 'AB', 'T8C 1H6'),
('Darth', 'Vader', '(231)555-2345', 'darth.vader@example.com', '789 Death Star', 'Galactic Empire', 'AB', 'T8E 1G6'),
('Marty', 'McFly', '(231)555-8765', 'marty.mcfly@example.com', '1640 Riverside Drive', 'Hill Valley', 'AB', 'T8E 1G6'),
('Katniss', 'Everdeen', '(231)555-9870', 'katniss.everdeen@example.com', '12 District Lane', 'Panem', 'AB', 'T8E 1G6'),
('Jack', 'Dawson', '(231)555-3456', 'jack.dawson@example.com', '101 Titanic Avenue', 'Southampton', 'AB', 'T8E 1G6'),
('Sherlock', 'Holmes', '(231)555-5678', 'sherlock.holmes@example.com', '221B Baker Street', 'London', 'AB', 'T8E 1G6'),
('Frodo', 'Baggins', '(231)555-2345', 'frodo.baggins@example.com', '1 Bag End', 'Hobbiton', 'AB', 'T8E 1G6'),
('Wonder', 'Woman', '(231)555-7890', 'wonder.woman@example.com', 'Themyscira Island', 'Themyscira', 'AB', 'T8E 1G6'),
('Homer', 'Simpson', '(231)555-7811', 'Homer.Simpson@example.com', '111 Street', 'Springfield', 'AB', 'T8E 1G2')

--Dog
INSERT INTO Dog (Name, Breed, DOB, Color, OwnerID)
VALUES ('Scooby-Doo', 'Great Dane', '2000-03-15', 'Brown', 1),
('Lassie', 'Rough Collie', '2005-07-10', 'Tricolor', 2),
('Goofy', 'Mixed Breed', '1998-11-25', 'Black', 3),
('Clifford', 'Big Red Dog', '2012-02-03', 'Red', 4),
('Einstein', 'Sheepdog', '2010-09-18', 'White and Black', 5),
('Snoopy', 'Beagle', '2002-06-30', 'White and Black', 6),
('Toto', 'Cairn Terrier', '2007-04-12', 'Brown', 7),
('Astro', 'Great Dane', '2015-09-22', 'Blue', 8),
('Buddy', 'Golden Retriever', '2018-11-08', 'Golden', 9),
('Lady', 'Cocker Spaniel', '2014-03-05', 'Blonde', 10),
('Max', 'German Shepherd', '2019-08-15', 'Black and Tan', 11),
('Rex', 'Border Collie', '2017-05-20', 'Black and White', 12),
('Bolt', 'White Shepherd', '2016-02-10', 'White', 13),
('Beethoven', 'St. Bernard', '2014-11-30', 'Brown and White', 14),
('Cujo', 'Saint Bernard', '2020-04-18', 'Brown and Black', 15),
('Balto', 'Siberian Husky', '2018-10-12', 'Gray and White', 1),
('Benji', 'Mixed Breed', '2015-07-08', 'Brown and White', 2),
('Marley', 'Labrador Retriever', '2019-03-25', 'Yellow', 3	),
('Hachi', 'Akita', '2017-01-15', 'Red and White', 4),
('Spike', 'Bulldog', '2016-11-02', 'Brown', 5)

--EmployeeType
INSERT INTO EmployeeType (Description)
VALUES ('Booking'),
('Dog Handler'),
('Groomer'),
('Trainer'),
('Front Desk Staff'),
('Caretaker'),
('Playgroup Leader')

--Employee
INSERT INTO Employee (FirstName, LastName, EmployeeTypeID)
VALUES ('Clark', 'Kent', 1),
('Diana', 'Prince', 2),
('Bruce', 'Wayne', 3),
('Tony', 'Stark', 4),
('Peter', 'Parker', 5),
('Barry', 'Allen', 1),
('Natasha', 'Romanoff', 2),
('Arthur', 'Curry', 3),
('Jean', 'Grey', 4),
('Wade', 'Wilson', 5),
('Carol', 'Danvers', 1),
('Matt', 'Murdock', 2),
('Steve', 'Rogers', 3),
('Hal', 'Jordan', 4),
('Ororo', 'Munroe', 5)

--Service
INSERT INTO Service (ServiceID, Name, Description, Price)
VALUES ('GROOM01', 'Grooming Package', 'Full grooming including bath, haircut, nail trim, and brushing.', 50.00),
('PLAY02', 'Playtime and Exercise', 'Supervised playtime and exercise in designated play areas.', 20.00),
('TRAIN03', 'Basic Training Session', 'Training session focusing on basic commands and behavior.', 30.00),
('SPA04', 'Spa Treatment', 'Relaxing spa session including massage, aromatherapy, and nail trim.', 40.00),
('FEED05', 'Feeding Service', 'Feeding and providing special dietary needs for dogs.', 10.00),
('WALK06', 'Outdoor Walks', 'Guided outdoor walks around our facility for exercise and fresh air.', 15.00),
('MED07', 'Medication Administration', 'Administering prescribed medications to dogs as needed.', 10.00),
('BATH08', 'Bath and Brush', 'Bath, brush, and blow-dry to keep your dog clean and fresh.', 25.00),
('TRAIN09', 'Advanced Training Session', 'Training session focusing on more advanced commands and skills.', 40.00),
('PLAY01', 'Playgroup Socialization', 'Structured playgroups for dogs to socialize and interact.', 18.00	),
('NAIL11', 'Nail Trimming', 'Trimming and filing your dog''s nails to keep them comfortable.', 12.00),
('BOARD12', 'Boarding', 'Overnight boarding with comfortable sleeping arrangements.', 40.00),
('POOL13', 'Pool Playtime', 'Supervised pool playtime for dogs that love water.', 25.00),
('SPA14', 'Deluxe Spa Package', 'Complete spa treatment with massage, bath, nail trim, and more.', 60.00),
('FEED15', 'Premium Feeding Service', 'Providing specialized premium diet and feeding plans.', 15.00),
('BOARDING', 'Overnight', 'Overnight accomdations at the day care', 25)

--Booking
INSERT INTO Booking (StartDate, EndDate, Days, BoardingTotal, ServicesTotal, SubTotal, GST, Total, DogID)
VALUES ('Jan 1 2022', 'jan 3, 2022', 2, 50.00, 65.00, 115.00, 5.75, 120.75, 1),
('Jan 2 2022', 'jan 4, 2022', 2, 50.00, 40.00, 90.00, 4.5, 94.5, 2),
('Jan 5 2022', 'jan 10, 2022', 6, 125.00, 42.00, 167.00, 8.35, 175.35, 3),
('Jan 11 2022', 'jan 15, 2022', 4, 100.00, 65.00, 165.00, 8.25, 173.25, 4),
('Jan 22 2022', 'jan 24, 2022', 2, 50.00, 70.00, 130.00, 6.50, 136.5, 5),
('Jan 23 2022', 'jan 25, 2022', 2, 50.00, 25.00, 75.00, 3.75, 78.75, 6),
('Jan 25 2022', 'jan 27, 2022', 2, 50.00, 43.00, 93.00, 4.65, 97.65, 7),
('Jan 26 2022', 'jan 28, 2022', 2, 50.00, 60.00, 110.00, 5.50, 115.50, 8),
('Jan 26 2022', 'jan 29, 2022', 3, 75.00, 40.00, 115.00, 5.75, 12.75, 9),
('Jan 28 2022', 'jan 29, 2022', 1, 25.00, 70.00, 95.00, 4.75, 99.75, 10)

--DogService
-- Insert DogService records for BookingID 1
INSERT INTO DogService (BookingID, ServiceID, DATE, HistoricalServicePrice, Notes, EmployeeID)
VALUES (1, 'GROOM01', 'Jan 2 2022', 50.00, 'Went well. No issues', 3),
(1, 'FEED15', 'Jan 2 2022', 15.00, NULL, 5),
(1, 'BOARDING', 'Jan 1 2022', 25, 'Needs exta attention. Gets nervous', NULL)

-- Insert DogService records for BookingID 2
INSERT INTO DogService (BookingID, ServiceID, DATE, HistoricalServicePrice, Notes, EmployeeID)
VALUES (2, 'PLAY02', 'Jan 2 2022', 20.00, 'One-hour playtime session in the play area.', 6),
(2, 'PLAY01', 'Jan 4 2022', 18.00, NULL, 2),
(2, 'BOARDING', 'Jan 2 2022', 25, 'On a diet', NULL)

-- Insert DogService records for BookingID 3
INSERT INTO DogService (BookingID, ServiceID, DATE, HistoricalServicePrice, Notes, EmployeeID)
VALUES (3, 'TRAIN03', 'Jan 5 2022', 30.00, 'Improving!', 8),
(3, 'NAIL11', 'Jan 6 2022', 12.00, 'Cut one nail too close....', 3),
(3, 'BOARDING', 'Jan 5 2022', 25, 'Like other dogs', NULL)

-- Insert DogService records for BookingID 4
INSERT INTO DogService (BookingID, ServiceID, DATE, HistoricalServicePrice, Notes, EmployeeID)
VALUES (4, 'SPA04', 'Jan 1 2022', 40.00, 'Adjusted well', 5),
(4, 'POOL13', 'Jan 1 2022', 25.00, 'Loved the water!', 6),
(4, 'BOARDING', 'Jan 1 2022', 25, 'Does not like other dogs', NULL)

-- Insert DogService records for BookingID 5
INSERT INTO DogService (BookingID, ServiceID, DATE, HistoricalServicePrice, Notes, EmployeeID)
VALUES (5, 'FEED05', 'Jan 22 2022', 10.00, 'Ate lots!', 2),
(5, 'SPA14', 'Jan 23 2022', 60.00, NULL, 8),
(5, 'BOARDING', 'Jan 22 2022', 25, 'Sleeps lots', NULL)

-- Insert DogService records for BookingID 6
INSERT INTO DogService (BookingID, ServiceID, DATE, HistoricalServicePrice, Notes, EmployeeID)
VALUES (6, 'WALK06', 'Jan 23 2022', 15.00, 'Walked for 30 minutes', 9),
(6, 'MED07', 'Jan 24 2022', 10.00, 'No Issue', 4),
(6, 'BOARDING', 'Jan 23 2022', 25, 'Remember to feed 3 times a day', NULL)

-- Insert DogService records for BookingID 7
INSERT INTO DogService (BookingID, ServiceID, DATE, HistoricalServicePrice, Notes, EmployeeID)
VALUES (7, 'BATH08', 'Jan 25 2022', 25.00, 'Did not like the dryer', 7),
(7, 'PLAY01', 'Jan 26 2022', 18.00, 'played well with other dogs', 1),
(7, 'BOARDING', 'Jan 25 2022', 25, 'Friendly', NULL)

-- Insert DogService records for BookingID 8
INSERT INTO DogService (BookingID, ServiceID, DATE, HistoricalServicePrice, Notes, EmployeeID)
VALUES (8, 'TRAIN09', 'Jan 26 2022', 40.00, 'Fast learner!', 10),
(8, 'PLAY02', 'Jan 27 2022', 20.00, NULL, 3),
(8, 'BOARDING', 'Jan 26 2022', 25, 'Can be aggresive', NULL)

-- Insert DogService records for BookingID 9
INSERT INTO DogService (BookingID, ServiceID, DATE, HistoricalServicePrice, Notes, EmployeeID)
VALUES (9, 'POOL13', 'Jan 26 2022', 25.00, NULL, 6),
(9, 'FEED15', 'Jan 27 2022', 15.00, NULL, 5),
(9, 'BOARDING', 'Jan 26 2022', 25, 'Barks a lot', NULL)

-- Insert DogService records for BookingID 10
INSERT INTO DogService (BookingID, ServiceID, DATE, HistoricalServicePrice, Notes, EmployeeID)
VALUES (10, 'TRAIN03', '2021-09-03', 30.00, 'Still aggressive', 8),
(10, 'SPA04', '2021-09-05', 40.00, NULL, 5),
(10, 'BOARDING', 'Jan 28 2022', 25, 'Has trouble sleeping', NULL)

--PaymentType		 
INSERT INTO PaymentType (Description)
VALUES ('Cash'),
('Visa'),
('MasterCard'),
('Debit')

--Payment
INSERT INTO Payment (BookingID, Amount, DATE, PaymentTypeID)
VALUES (1, 100, 'Jan 1 2020', 1),
(1, 50, 'Jan 1 2020', 1),
(2, 60, 'Jan 1 2020', 1),
(1, 40, 'Jan 1 2020', 1),
(3, 70, 'Jan 1 2020', 1),
(4, 20, 'Jan 1 2020', 1),
(5, 20, 'Jan 1 2020', 1),
(6, 30, 'Jan 1 2020', 1)
