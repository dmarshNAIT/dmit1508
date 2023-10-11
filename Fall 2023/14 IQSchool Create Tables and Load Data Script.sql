/* IQSchool Table Creation and Load Data Script */

Use IQSchool
Go

Drop Table If Exists Payment
Drop Table If Exists PaymentType
Drop Table If Exists Registration
Drop Table If Exists Offering
Drop Table If Exists Semester
Drop Table If Exists Activity
Drop Table If Exists Staff
Drop Table If Exists Course
Drop Table If Exists Student
Drop Table If Exists Club
Drop Table If Exists Position
go

Create Table Position
(
	PositionID			tinyint			Not Null
										Constraint PK_Position_PositionID
											Primary Key clustered,
	PositionDescription	varchar(50)		Not Null
)


Create Table Club
(
	ClubId				varchar(10)		Not Null
										Constraint PK_Club_ClubId
											Primary Key clustered,
	ClubName			varchar(50)		Not Null
)


Create Table Student
(
	StudentID			int				Not Null
										Constraint PK_Student_StudentID
											Primary Key clustered,
	FirstName			varchar(25)		Not Null,
	LastName			varchar(35)		Not Null,
	Gender				char(1)			Not Null,
	StreetAddress		varchar(35)		Null,
	City				varchar(30)		Null,
	Province			char(2)			Null 
										Constraint DF_Student_Province_AB
											Default 'AB'
										Constraint CK_Student_Province_ZZ
											Check (Province like '[A-Z][A-Z]'),
	PostalCode			char(6)			Null
										Constraint CK_Student_PostalCode_Canadian_Style_Z9Z9Z9
											check(PostalCode like '[A-Z][0-9][A-Z][0-9][A-Z][0-9]'),
	Birthdate			smalldatetime	Not Null,
	BalanceOwing		decimal(7,2)	Null
										Constraint DF_Student_BalanceOwing_Zero
											Default 0
										Constraint CK_Student_BalanceOwing_GreaterEqualZero
											Check (BalanceOwing >= 0)
)


Create Table Course
(
	CourseId			char(8)			Not Null
										Constraint PK_Course_CourseId
											Primary Key clustered,
	CourseName			varchar(40)		Not Null,	
	CourseHours 		smallint		Not Null
										Constraint CK_Course_CourseHours_GreaterThanZero
											Check (CourseHours > 0),
	MaxStudents			int				Null
										Constraint DF_Course_MaxStudents_Zero
											Default 0
										Constraint CK_Course_MaxStudents_GreaterEqualZero
											Check (MaxStudents >= 0),
	CourseCost			decimal(6,2)	Not Null
										Constraint DF_Course_CourseCost_Zero
											Default 0
										Constraint CK_Course_CourseCost_GreaterEqualZero
											Check (CourseCost >= 0)
)


Create Table Staff
(
	StaffID				smallint		Not Null
										Constraint PK_Staff_StaffID
											Primary Key clustered,
	FirstName			varchar(25)		Not Null,
	LastName			varchar(35)		Not Null,
	DateHired			smalldatetime	Not Null
										Constraint DF_Staff_DateHired_GetDate
											Default GetDate(),
	DateReleased		smalldatetime	Null,
	PositionID			tinyint			Not Null
										Constraint FK_Staff_PositionID_To_Position_PositionID
											References Position(PositionID),
	LoginID				varchar(30)		Null,
	Constraint CK_Staff_DateReleased_GreaterThan_DateHired
		Check (DateReleased > DateHired)
)


Create Table Activity
(
	StudentID			int				Not Null
										Constraint FK_Activity_StudentID_To_Student_StudentID
											References Student (StudentID), 
	ClubId				varchar(10) 	Not Null
										Constraint FK_Activity_ClubId_To_Club_ClubId
											References Club (ClubId),
	Constraint PK_Activity_StudentID_ClubId
		Primary Key clustered (StudentID, ClubId)
)


Create Table Semester
(
	SemesterCode		char(5)			Not Null
										Constraint PK_Semester_SemesterCode
											Primary Key clustered,
	StartDate			datetime		Not Null,
	EndDate				datetime		Not Null
)


Create Table Offering
(
	OfferingCode		int				Not Null
										Constraint PK_Offering_OfferingCode
											Primary Key clustered,
	StaffID				smallint		Not Null
										Constraint fk_Offering_StaffID_To_Staff_StaffID
											References Staff(StaffID),
	CourseId			char(8)			Not Null
										Constraint fk_Offering_CourseId_To_Course_CourseId
											References Course(CourseId),
	SemesterCode		char(5)			Not Null
										Constraint fk_Offering_SemesterCode_To_Semester_SemesterCode
											References Semester(SemesterCode)
)


Create Table Registration
(
	OfferingCode		int				Not Null
										Constraint fk_Registration_OfferingCode_To_Offering_OfferingCode
											References Offering(OfferingCode),
	StudentID			int				Constraint fk_Registration_StudentID_To_Student_StudentID
											References Student(StudentID),
	Mark				decimal(5,2)	Null
										Constraint CK_Registration_Mark_0_To_100
											Check (Mark between 0 and 100),
	WithdrawYN			char(1)			Null
										Constraint DF_Registration_WithdrawYN_N
											Default 'N'
										Constraint CK_Registration_WithdrawYN_YN
											Check (WithdrawYN in ('Y','N')),
	Constraint PK_Registration_OfferingCode_StudentID
		Primary Key clustered (OfferingCode, StudentID)
)


Create Table PaymentType
(
	PaymentTypeID			tinyint		Not Null
										Constraint PK_PaymentType_PaymentTypeID
											Primary Key clustered,
	PaymentTypeDescription	varchar(40) Null
)


Create Table Payment
(
	PaymentID			int				Not Null
										Constraint PK_Payment_PaymentID
											Primary Key clustered,
	PaymentDate			datetime		Not Null
										Constraint DF_Payment_PaymentDate_GetDate
											Default GetDate()
										Constraint CK_Payment_PaymentDate_GreaterEqual_GetDate
											Check (PaymentDate >= GetDate()),
	Amount				decimal(6,2)	Not Null
										Constraint DF_Payment_Amount_Zero
											Default 0
										Constraint CK_Payment_Amount_GreaterEqualZero
											Check (Amount >= 0),
	PaymentTypeID		tinyint			Not Null
										Constraint FK_Payment_PaymentTypeID_To_PaymentType_PaymentTypeID
											References PaymentType (PaymentTypeID),
	StudentID			int				Not Null
										Constraint FK_Payment_StudentID_To_Student_StudentID
											References Student (StudentID)
)
go

/*Data Inserts */

-- Position
Insert into Position
	(PositionID, PositionDescription)
Values
	(1, 'Dean'),
	(7, 'Assistant Dean'),
	(2, 'Program Chair'),
	(3, 'Assistant Program Chair'),
	(4, 'Instructor'),
	(5, 'Office Administrator'),
	(6, 'Technical Support Staff')

-- Staff
Insert into Staff
	(StaffID, FirstName, LastName, DateHired, DateReleased, PositionID, LoginID)
Values
	( 4, 'Nolan',  'Itall',      'Aug 12, 2006', Null, 4, Null),
	(10, 'Chip',   'Andale',     'Jul 14, 2020', Null, 6, Null),
	( 2, 'Robert', 'Smith',      'Jun 12, 2003', Null, 3, Null),
	( 3, 'Tess',   'Agonor',     'Apr 25, 2005', 'May 22, 2023', 4, Null),
	( 9, 'Nic',    'Bustamante', 'Jun 15, 2020', Null, 2, Null),
	( 6, 'Sia',    'Latter',     'Oct 30, 2009', Null, 4, Null),
	( 7, 'Hugh',   'Guy',        'Oct 10, 2011', Null, 1, Null),
	( 5, 'Jerry',  'Kan',        'Aug 15, 2008', Null, 4, Null),
	( 1, 'Donna',  'Bookem',     'Apr 17, 2001', Null, 5, Null),
	( 8, 'Cher',   'Power',      'May 30, 2013', Null, 3, Null)

-- Student
Insert into Student
	(StudentID, FirstName, LastName, Gender, StreetAddress, City, Province, PostalCode, Birthdate, BalanceOwing)
Values
	(199966250, 'Dennis', 'Kent', 'M', '11044 -83 ST.', 'Edmonton', 'AB', 'T3O1J1', 'Apr 29, 1993', 0.00),
	(200011730, 'Jay ', 'Smith', 'M', 'Box 761', 'Red Deer', 'AB', 'T6J7V3', 'May 06, 1997', 0.00),
	(200494470, 'Minnie', 'Ono', 'F', '12003 -103 ST.', 'Edmonton', 'AB', 'T2W7P7', 'Dec 10, 1984', 22695.00),
	(198933540, 'Winnie', 'Woo', 'F', '200 - 3 St. S.W', 'Calgary', 'AB', 'T9A1N1', 'Nov 04, 1992', 0.00),
	(200322620, 'Flying', 'Nun', 'F', 'Fantasy Land', 'Edmonton', 'AB', 'T9T4Z4', 'Oct 22, 1976', 0.00),
	(200312345, 'Mary', 'Jane', 'F', '11044 -83 Ave.', 'Edmonton', 'AB', 'T3Q9N5', 'Dec 11, 1983', 29299.00),
	(199912010, 'Dave', 'Brown', 'M', '11206-106 St.', 'Edmonton', 'AB', 'T4J7H2', 'Jan 02, 1990', 36195.00),
	(200688700, 'Robbie', 'Chan', 'F', 'Box 561', 'Athabasca', 'AB', 'T4Z4B1', 'Mar 30, 1982', 0.00),
	(200495500, 'Robert', 'Smith', 'M', 'Box 333', 'Leduc', 'AB', 'T6P3Z3', 'Mar 20, 1990', 6345.00),
	(200494476, 'Joe', 'Cool', 'M', '12003 -103 ST.', 'Edmonton', 'AB', 'T2G6L7', 'Dec 10, 1989', 0.00),
	(199899200, 'Ivy', 'Kent', 'F', '11044 -83 ST.', 'Edmonton', 'AB', 'T4N9A7', 'Dec 11, 1993', 21972.00),
	(200578400, 'Andy', 'Kowaski', 'M', '172 Downing St.', 'Woolerton', 'SK', 'S7Y0Q3', 'Nov 07, 1990', 19849.00),
	(200122100, 'Peter', 'Codd', 'M', '172 Downers Grove', 'Victoria', 'BC', 'V6E4R2', 'May 07, 1995', 19849.00),
	(200645320, 'Thomas', 'Brown', 'M', '11206 Empire Building', 'Edmonton', 'AB', 'T4S6S2', 'Oct 02, 1991', 0.00),
	(200522220, 'Joe', 'Petroni', 'M', '11206 Imperial Building', 'Calgary', 'AB', 'T3Q5A7', 'Aug 03, 1979', 0.00),
	(200978500, 'Dave', 'Brown', 'M', '433 Crazy St.', 'Edmonton', 'AB', 'T9E1D3', 'Jan 20, 1986', 1350.00),
	(200978400, 'Peter', 'Pan', 'M', '182 Downing St.', 'Tisdale', 'SK', 'S1K9H3', 'Nov 07, 2000', 0.00)

-- Club
Insert into Club
	(ClubId, ClubName)
Values
	('CSS',    'Computer System Society'),
	('NASA',   'NAIT Staff Association'),
	('CIPS',   'Computer Info Processing Society'),
	('CHESS',  'NAIT Chess Club'),
	('ACM',    'Association of Computing Machinery'),
	('NAITSA', 'NAIT Student Association'),
	('DBTG',   'DataBase Task Group'),
	('NASA1',  'NAIT Support Staff Association')

-- Activity
Insert into Activity
	(StudentID, ClubId)
Values
	(199912010, 'CSS'),
	(199912010, 'ACM'),
	(199912010, 'NASA'),
	(200312345, 'CSS'),
	(199899200, 'CSS'),
	(200495500, 'CHESS'),
	(200495500, 'CSS'),
	(200322620, 'CSS'),
	(200495500, 'ACM'),
	(200322620, 'ACM')

-- Course
Insert into Course
	(CourseId, CourseName, CourseHours, MaxStudents, CourseCost)
Values
	('COMP1017', 'Web Design 1', 64, 4, 450),
	('DMIT2028', 'Systems Analysis & Design II', 96, 3, 675),
	('DMIT2504', 'Android Development', 96, 4, 675),
	('CPSC1012', 'Programming Fundamentals', 96, 5, 675),
	('DMIT1001', 'Communications in IT and New Media', 64, 4, 450),
	('DMIT1518', 'IT System Administration', 64, 4, 450),
	('DMIT2003', 'Quality Assurance and Software Testing', 64, 4, 450),
	('DMIT2015', 'Enterprise Application Development', 96, 5, 675),
	('PHYS2446', 'Math & Physics', 80, 5, 600),
	('DMIT2023', 'Microsoft Windows Server', 64, 5, 450),
	('ANAP1525', 'Systems Analysis & Design 1', 96, 5, 675),
	('DMIT1508', 'Database Fundamentals', 96, 3, 675),
	('DMIT1514', 'Game Programming Essentials', 96, 4, 675),
	('DMIT2027', 'DMIT2027 Project Management', 64, 2, 450),
	('DMIT2515', 'Securing MS Active Directory', 64, 5, 450),
	('DMIT2590', 'Capstone Project', 192, 5, 1575)

-- Semester
Insert into Semester
	(SemesterCode, StartDate,EndDate)
Values
	('A100', 'Jan 1 2018', 'April 30 2018'), 
	('A200', 'Jan 1 2019', 'April 30 2019'), 
	('A300', 'Jan 1 2020', 'April 30 2020'), 
	('A400', 'Jan 1 2021', 'April 30 2021'), 
	('A500', 'Jan 1 2022', 'April 30 2022'), 
	('A600', 'Jan 1 2023', 'April 30 2023')


-- Offering
Insert into Offering (OfferingCode, StaffID, CourseId, SemesterCode)
Values
	(1000, 6, 'DMIT1514', 'A100'), 
	(1001, 6, 'DMIT1508', 'A200'), 
	(1002, 6, 'CPSC1012', 'A300'), 
	(1003, 5, 'DMIT1001', 'A400'), 
	(1004, 5, 'DMIT1001', 'A500'), 
	(1005, 5, 'ANAP1525', 'A600'), 
	(1006, 5, 'DMIT2015', 'A100'), 
	(1007, 5, 'PHYS2446', 'A200'), 
	(1008, 5, 'DMIT2515', 'A300'), 
	(1009, 4, 'DMIT2028', 'A400'), 
	(1010, 4, 'DMIT2515', 'A500'), 
	(1011, 4, 'DMIT2504', 'A600'), 
	(1012, 4, 'DMIT2003', 'A100'), 
	(1013, 4, 'DMIT1518', 'A200'), 
	(1014, 4, 'DMIT2590', 'A300')

-- Registration
Insert into Registration
	(OfferingCode, StudentID,  Mark,  WithdrawYN)
Values
	(1000, 200978500, 80, 'N'), 
	(1001, 200978500, 80, 'N'), 
	(1000, 199912010, 80, 'N'), 
	(1001, 199912010, 83, 'N'), 
	(1002, 199912010, 98, 'N'), 
	(1003, 199912010, 98, 'N'), 
	(1004, 199912010, 85, 'N'), 
	(1005, 199912010, 88, 'N'), 
	(1006, 199912010, 88, 'N'), 
	(1007, 199912010, 85, 'N'), 
	(1008, 199912010, 80, 'N'), 
	(1009, 199912010, 78, 'N'), 
	(1010, 199912010, 78, 'N'), 
	(1011, 199912010, 89, 'N'), 
	(1012, 199912010, 83, 'N'), 
	(1013, 199912010, 89, 'N'), 
	(1000, 200495500, 80, 'N'), 
	(1001, 200495500, 83, 'N'), 
	(1002, 200495500, 98, 'N'), 
	(1003, 200495500, 98, 'N'), 
	(1004, 200495500, 85, 'N'), 
	(1005, 200495500, 88, 'N'), 
	(1011, 200495500, 88, 'N'), 
	(1000, 200494470, 80, 'N'), 
	(1001, 200494470, 78, 'N'), 
	(1002, 200494470, 78, 'N'), 
	(1003, 200494470, 89, 'N'), 
	(1004, 200494470, 83, 'N'), 
	(1005, 200494470, 89, 'N'), 
	(1006, 200494470, 80, 'N'), 
	(1007, 200494470, 83, 'N'), 
	(1008, 200494470, 98, 'N'), 
	(1009, 200494470, 98, 'N'), 
	(1010, 200494470, 85, 'N'), 
	(1011, 200494470, 88, 'N'), 
	(1012, 200494470, 88, 'N'), 
	(1000, 200122100, 85, 'N'), 
	(1001, 200122100, 80, 'N'), 
	(1002, 200122100, 78, 'N'), 
	(1003, 200122100, 78, 'N'), 
	(1004, 200122100, 89, 'N'), 
	(1005, 200122100, 83, 'N'), 
	(1006, 200122100, 89, 'N'), 
	(1000, 200312345, 80, 'N'), 
	(1001, 200312345, 88, 'N'), 
	(1002, 200312345, 78, 'N'), 
	(1003, 200312345, 89, 'N'), 
	(1004, 200312345, 83, 'N'), 
	(1005, 200312345, 89, 'N'), 
	(1006, 200312345, 89, 'N'), 
	(1000, 200578400, 30, 'N'), 
	(1001, 200578400, 83, 'N'), 
	(1002, 200578400, 98, 'N'), 
	(1003, 200578400, 98, 'N'), 
	(1004, 200578400, 85, 'N'), 
	(1005, 200578400, 88, 'N'), 
	(1006, 200578400, 88, 'N'), 
	(1000, 199899200, 85, 'N'), 
	(1001, 199899200, 80, 'N'), 
	(1002, 199899200, 78, 'N'), 
	(1003, 199899200, 78, 'N'), 
	(1004, 199899200, 89, 'N'), 
	(1005, 199899200, 83, 'N'), 
	(1006, 199899200, 89, 'N'), 
	(1007, 199899200, 80, 'N'), 
	(1008, 199899200,  0, 'Y'), 
	(1012, 200578400,  0, 'Y'), 
	(1013, 200312345,  0, 'Y'), 
	(1012, 200122100,  0, 'Y'), 
	(1014, 199912010,  0, 'Y')

-- Payment
Insert into PaymentType
	(PaymentTypeID, PaymentTypeDescription)
Values
	(5, 'American Express'), 
	(1, 'Cash'), 
	(2, 'Cheque'), 
	(4, 'MasterCard'), 
	(6, 'Debit Card'), 
	(3, 'VISA')

-- Payment
-- need to turn off date check temporarily to allow for old dates
Alter Table Payment NoCheck Constraint CK_Payment_PaymentDate_GreaterEqual_GetDate
Go

Insert into Payment
	(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values
( 8, 'Jan  1 2019 12:10PM',  90.00, 4, 200495500),
(32, 'May  1 2023  2:46PM', 157.00, 2, 200312345),
( 9, 'Sep  1 2019  8:35AM',  90.00, 6, 199912010),
(24, 'May  1 2022 12:59PM',  90.00, 2, 200312345),
(10, 'Sep  1 2019 11:18AM',  45.00, 2, 200494470),
(13, 'Sep  1 2020 10:58AM',  90.00, 5, 200122100),
(30, 'May  1 2023 11:06AM', 157.00, 1, 199912010),
( 3, 'Sep  1 2018  2:49PM', 225.00, 1, 200494470),
( 2, 'Sep  1 2018 11:18AM', 225.00, 5, 199912010),
( 5, 'Sep  1 2018  9:55AM', 180.00, 5, 200578400),
(25, 'May  1 2022  9:21AM',  45.00, 6, 200578400),
(23, 'Jan  1 2022  2:11PM',  45.00, 6, 200578400),
( 4, 'Sep  1 2018  1:30PM', 225.00, 2, 200495500),
( 1, 'Sep  1 2018 12:20PM',  45.00, 5, 199899200),
(14, 'Sep  1 2020 12:05PM',  45.00, 3, 200312345),
(29, 'May  1 2023  1:13PM', 157.00, 4, 199899200),
(21, 'Jan  1 2022  1:30PM', 135.00, 4, 199899200),
(27, 'Sep  1 2022  5:01PM',  45.00, 2, 200578400),
(28, 'Jan  1 2023 12:21PM',  90.00, 1, 199899200),
(11, 'Jan  1 2020 11:16AM',  90.00, 4, 199912010),
(18, 'May  1 2021  3:35PM',  45.00, 5, 200312345),
( 7, 'Jan  1 2019  8:14AM', 225.00, 5, 200494470),
(33, 'May  1 2023  2:01PM', 157.00, 3, 200578400),
(15, 'Jan  1 2021 10:25AM',  90.00, 6, 200122100),
(22, 'Jan  1 2022 10:17AM',  45.00, 2, 200312345),
(26, 'Sep  1 2022 12:36PM',  90.00, 1, 199899200),
(17, 'May  1 2021 12:14PM',  45.00, 6, 200122100),
(31, 'May  1 2023  6:27PM', 157.00, 4, 200122100),
(12, 'Jan  1 2020 10:05AM',  90.00, 4, 200494470),
(16, 'Jan  1 2021  3:58PM',  45.00, 1, 200312345),
(20, 'Sep  1 2021  3:06PM',  45.00, 5, 200312345),
( 6, 'Jan  1 2019 12:33PM', 225.00, 6, 199912010),
(19, 'Sep  1 2021 10:19AM',  90.00, 4, 200122100)

-- need to turn date check back on
Alter Table Payment Check Constraint CK_Payment_PaymentDate_GreaterEqual_GetDate
