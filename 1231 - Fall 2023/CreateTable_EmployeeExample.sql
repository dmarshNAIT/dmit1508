-- tell SSMS which database to use
USE Sandbox

-- drop the old versions of the tables
DROP TABLE IF EXISTS EmployeeOnProject
DROP TABLE IF EXISTS Project
DROP TABLE IF EXISTS Employee

-- create the Employee table
CREATE TABLE Employee (
	EmployeeID	CHAR(11)		NOT NULL	CONSTRAINT PK_Employee PRIMARY KEY CLUSTERED
,	LastName	VARCHAR(100)	NOT NULL
,	FirstName	VARCHAR(100)	NOT NULL
)

-- create the Project table
CREATE TABLE Project (
	ProjectNumber	INT	IDENTITY(1,1)	NOT NULL	CONSTRAINT PK_Project PRIMARY KEY CLUSTERED
,	ProjectName		VARCHAR(255)		NOT NULL
,	ProjectLocation	VARCHAR(100)		NOT NULL
)

-- create the associative entity
CREATE TABLE EmployeeOnProject (
	EmployeeID		CHAR(11)	NOT NULL	
		CONSTRAINT FK_EmployeeOnProjectToEmployee REFERENCES Employee (EmployeeID)
,	ProjectNumber	INT			NOT NULL
		CONSTRAINT FK_EmployeeOnProjectToProject REFERENCES Project (ProjectNumber)
,	WeeklyHours		INT			NOT NULL CONSTRAINT DF_WeeklyHours DEFAULT 5.0
		CONSTRAINT CK_EmployeeHours CHECK (WeeklyHours <= 20)
,	CONSTRAINT PK_EmployeeOnProject PRIMARY KEY CLUSTERED (EmployeeID, ProjectNumber)
)

-- list our table definitions
EXEC sp_help Employee
EXEC sp_help EmployeeOnProject
EXEC sp_help Project


------------------------------------- BONUS QUESTIONS ---------------------------------------------

-- is CHECK case-sensitive?
-- first let's make a rule that names must start with D
ALTER TABLE Employee ADD CONSTRAINT CK_NameABC CHECK (FirstName LIKE 'D%')
-- then, let's try to add in records and see which work and which do not.
INSERT INTO Employee VALUES ('12345678901', 'Marsh', 'Dana') -- works
INSERT INTO Employee VALUES ('12345678902', 'Marsh', 'dana') -- also works!
INSERT INTO Employee VALUES ('12345678903', 'Dana', 'Marsh') -- data has not been added
-- LIKE operator is NOT case-sensitive

-- can we use the full month of January?
-- let's add the new column and its constraint:
ALTER TABLE Employee ADD HireDate DATETIME
ALTER TABLE Employee ADD CONSTRAINT CK_HireDate CHECK (HireDate LIKE '%JAN%')
-- now let's try to add an employee that matches the constraint
INSERT INTO Employee VALUES ('12345678903', 'Marsh', 'Dana', '2020-01-01') -- works
-- now let's create a slightly different constraint
ALTER TABLE Employee ADD CONSTRAINT CK_HireDate2 CHECK (HireDate LIKE '%JANUARY%')
-- and let's see if we can still add that same employee (with a new PK)
INSERT INTO Employee VALUES ('12345678904', 'Marsh', 'Dana', '2020-01-01') -- does not work
-- full month of JANUARY did NOT work
