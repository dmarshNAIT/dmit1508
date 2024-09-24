-- this is a comment
-- this statement tells SSMS which db to use
USE Sandbox3

-- if this table exists already, delete it
DROP TABLE IF EXISTS EmployeeOnProject
DROP TABLE IF EXISTS Employee
DROP TABLE IF EXISTS Project

/* hello 
	this is also a comment
*/

-- create our Employee table:
CREATE TABLE Employee (
	EmployeeID CHAR(11)	NOT NULL CONSTRAINT PK_Employee PRIMARY KEY CLUSTERED
,	LastName VARCHAR(100) NOT NULL
,	FirstName VARCHAR(100) NOT NULL
)

-- verify my table:
-- EXEC sp_help Employee

-- create Project table:
CREATE TABLE Project (
	ProjectNumber INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Project PRIMARY KEY CLUSTERED
,	ProjectName VARCHAR(50) NOT NULL
,	ProjectLocation VARCHAR(50) NOT NULL
)

-- EXEC sp_help Project

CREATE TABLE EmployeeOnProject (
	EmployeeID CHAR(11)	NOT NULL 
		CONSTRAINT FK_EmployeeOnProjectToEmployee REFERENCES Employee(EmployeeID)
,	ProjectNumber INT NOT NULL 
		CONSTRAINT EmployeeOnProjectToProject REFERENCES Project(ProjectNumber)
,	WeeklyHours INT NOT NULL 
		CONSTRAINT CK_MaxHours CHECK (WeeklyHours <= 20)
		CONSTRAINT DF_Hours DEFAULT 5
,	CONSTRAINT PK_EmployeeOnProject PRIMARY KEY CLUSTERED (EmployeeID, ProjectNumber)
)

-- EXEC sp_help EmployeeOnProject