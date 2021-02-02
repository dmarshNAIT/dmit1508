-- pick the database to use for this script:
USE sandbox

-- remove any previous versions of tables:
DROP TABLE IF EXISTS Project
DROP TABLE IF EXISTS EmployeeProject
DROP TABLE IF EXISTS Employee

-- CREATE statements:
CREATE TABLE Employee (
	EmployeeID	CHAR(11)	NOT NULL CONSTRAINT PK_Employee PRIMARY KEY CLUSTERED
,	LastName	VARCHAR(30)	NOT NULL
,	FirstName	VARCHAR(30) NOT NULL
)

CREATE TABLE Project (
	ProjectNumber	INT IDENTITY(1,1)	NOT NULL CONSTRAINT PK_Project PRIMARY KEY CLUSTERED
,	ProjectName		VARCHAR(50)			NOT NULL
,	ProjectLocation VARCHAR(50)			NOT NULL
)

CREATE TABLE EmployeeProject (
	EmployeeID		CHAR(11)	NOT NULL 
		CONSTRAINT FK_EmployeeProjectToEmployee REFERENCES Employee (EmployeeID)
,	ProjectNumber	INT			NOT NULL
		CONSTRAINT FK_EmployeProjectToProject REFERENCES Project (ProjectNumber)
,	WeeklyHours		INT			NOT NULL
		CONSTRAINT CK_WeeklyHoursMax CHECK (WeeklyHours <= 20)
	-- because this constraint affects MORE than one column, it is listed as a table-level constraint:
,	CONSTRAINT PK_EmployeeProject PRIMARY KEY CLUSTERED (EmployeeID, ProjectNumber)
)

CREATE TABLE Department (
    DepartmentNumber	INT	IDENTITY (1,1)	NOT NULL CONSTRAINT PK_Department PRIMARY KEY CLUSTERED
,	DepartmentName		VARCHAR(30)			NOT NULL
)



-- verify:
EXEC sp_help Employee
EXEC sp_help Project
EXEC sp_help EmployeeProject

-- how to view the contents of a table:
SELECT * FROM Project
-- we will learn all about SELECT later.
