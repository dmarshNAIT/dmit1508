DROP TABLE IF EXISTS EmployeeOnProject
DROP TABLE IF EXISTS Employee
DROP TABLE IF EXISTS Project

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
	EmployeeID CHAR(11) NOT NULL 
		CONSTRAINT FK_EmployeeOnProjectToEmployee REFERENCES Employee (EmployeeID),
	ProjectNumber INT NOT NULL
		CONSTRAINT FK_EmployeeOnProjectToProject REFERENCES Project (ProjectNumber),
	WeeklyHours INT NOT NULL
		CONSTRAINT CK_MaximumHours CHECK (WeeklyHours <= 20)
		CONSTRAINT DF_Hours DEFAULT 5,
	CONSTRAINT PK_EmployeeOnProject PRIMARY KEY CLUSTERED (EmployeeID, ProjectNumber)
)

EXEC sp_help Employee
EXEC sp_help EmployeeOnProject
EXEC sp_help Project