-- tell SQL which database to use:
USE sandbox2022
GO

-- delete any old versions of these tables
DROP TABLE EmployeeOnProject
DROP TABLE Employee
DROP TABLE Project

-- create Employee table:
CREATE TABLE Employee (
	EmployeeID CHAR(11) NOT NULL CONSTRAINT PK_Employee PRIMARY KEY CLUSTERED
,	LastName VARCHAR(40) NOT NULL
,	FirstName VARCHAR(40) NOT NULL
)
--CHAR(11) = exactly 11 characters
--VARCHAR(11) = up to 11 characters

-- create Project table
CREATE TABLE Project (
	ProjectNumber INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Project PRIMARY KEY CLUSTERED -- this is a technical key
,	ProjectName VARCHAR(50) NOT NULL
,	ProjectLocation VARCHAR(50) NOT NULL
)

-- create EmployeeOnProject table
CREATE TABLE EmployeeOnProject (
	EmployeeID CHAR(11) NOT NULL CONSTRAINT FK_EmployeeOnProjectToEmployee REFERENCES Employee (EmployeeID)  -- this is our FK to Employee.EmployeeID
,	ProjectNumber INT NOT NULL CONSTRAINT FK_EmployeeOnProjectToProject REFERENCES Project (ProjectNumber) -- this is our FK to Project.ProjectNumber
,	WeeklyHours SMALLINT NOT NULL CONSTRAINT CK_MaxHours CHECK (WeeklyHours <= 20) CONSTRAINT DF_Hours DEFAULT 5
,	CONSTRAINT PK_EmployeeOnProject PRIMARY KEY CLUSTERED (EmployeeID, ProjectNumber) -- composite PK
)


--List the table definition.
EXEC sp_help Employee
EXEC sp_help Project
EXEC sp_help EmployeeOnProject

--Save  your script.

