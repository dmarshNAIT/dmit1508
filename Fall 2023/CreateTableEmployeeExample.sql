
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
,	CONSTRAINT PK_EmployeeOnProject PRIMARY KEY CLUSTERED (EmployeeID, ProjectNumber)
)

-- list our table definitions
EXEC sp_help Employee
EXEC sp_help EmployeeOnProject
EXEC sp_help Project

