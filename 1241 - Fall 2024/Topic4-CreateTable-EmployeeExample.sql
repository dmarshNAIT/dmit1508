DROP TABLE IF EXISTS Employee

CREATE TABLE Employee (
	EmployeeID CHAR(11)	NOT NULL CONSTRAINT PK_Employee PRIMARY KEY CLUSTERED,
	LastName VARCHAR(50) NOT NULL,
	FirstName VARCHAR(50) NOT NULL
)

CREATE TABLE Project (
	ProjectNumber INT IDENTITY(1,1) NOT NULL 
		CONSTRAINT PK_Project PRIMARY KEY CLUSTERED,
	ProjectName VARCHAR(100) NOT NULL,
	ProjectLocation VARCHAR(100) NOT NULL
)

CREATE TABLE EmployeeOnProject (
	EmployeeID CHAR(11) NOT NULL,
	ProjectNumber INT NOT NULL,
	WeeklyHours INT NOT NULL,
	CONSTRAINT PK_EmployeeOnProject PRIMARY KEY CLUSTERED (EmployeeID, ProjectNumber)
)

EXEC sp_help Employee
EXEC sp_help EmployeeOnProject
EXEC sp_help Project