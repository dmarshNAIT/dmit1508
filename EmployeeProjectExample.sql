-- create Employee table
DROP TABLE Employee
CREATE TABLE Employee (
	EmployeeID	CHAR(11)		NOT NULL	CONSTRAINT PK_Employee PRIMARY KEY CLUSTERED
,	LastName	VARCHAR(100)	NOT NULL
,	FirstName	VARCHAR(100)	NOT NULL
)

-- create Project table
DROP TABLE Project
CREATE TABLE Project (
	ProjectNumber	INT IDENTITY(1,1)	NOT NULL CONSTRAINT PK_Project PRIMARY KEY CLUSTERED
,	ProjectName		VARCHAR(100)		NOT NULL
,	ProjectLocation	VARCHAR(100)		NOT NULL
)

-- create EmployeeOnProject table
DROP TABLE EmployeeOnProject
CREATE TABLE EmployeeOnProject (
	EmployeeID		CHAR(11)	NOT NULL	
		CONSTRAINT FK_EmployeeOnProjectToEmployee REFERENCES Employee (EmployeeID)
,	ProjectNumber	INT			NOT NULL
		CONSTRAINT FK_EmployeeOnProjectToProject REFERENCES Project (ProjectNumber)
,	WeeklyHours		INT			NOT NULL
,	CONSTRAINT PK_EmployeeOnProject PRIMARY KEY CLUSTERED (EmployeeID, ProjectNumber)
)

-- create Department table
CREATE TABLE Department (
	DepartmentNumber	INT IDENTITY(1,1)	NOT NULL
		CONSTRAINT PK_Department PRIMARY KEY CLUSTERED
,	Name				VARCHAR(100)		NOT NULL
)

-- list definitions
EXEC sp_help Employee
EXEC sp_help Project
EXEC sp_help EmployeeOnProject
EXEC sp_help Department