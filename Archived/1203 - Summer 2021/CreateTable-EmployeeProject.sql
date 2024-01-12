-- drop old versions of the tables
DROP TABLE IF EXISTS Employee
DROP TABLE IF EXISTS Project
DROP TABLE IF EXISTS EmployeeOnProject


-- create Employee table

CREATE TABLE Employee (
	EmployeeID CHAR(11) NOT NULL CONSTRAINT PK_Employee PRIMARY KEY CLUSTERED
,	LastName VARCHAR(30) NOT NULL
,	FirstName VARCHAR(30) NOT NULL
)

-- create Project table
CREATE TABLE Project (
	ProjectNumber INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Project PRIMARY KEY CLUSTERED
,	ProjectName VARCHAR(50) NOT NULL
,	ProjectLocation VARCHAR(50) NOT NULL
)

-- create EmployeeOnProject table
CREATE TABLE EmployeeOnProject (
	EmployeeID CHAR(11) NOT NULL CONSTRAINT FK_EmployeeOnProjectToEmployee REFERENCES Employee (EmployeeID)
,	ProjectNumber INT NOT NULL CONSTRAINT FK_EmployeeOnProjectToProject REFERENCES Project (ProjectNumber)
,	WeeklyHours SMALLINT NOT NULL 
		CONSTRAINT CK_HoursTwentyOrLess CHECK (WeeklyHours <= 20)
		CONSTRAINT DF_Hours DEFAULT 5
,	CONSTRAINT PK_EmployeeOnProject PRIMARY KEY CLUSTERED (EmployeeID, ProjectNumber)
)

-- verify tables
EXEC sp_help Employee
exec sp_help Project
exec sp_help EmployeeOnProject

