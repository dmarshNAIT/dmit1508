
-- drop the old versions of the tables
DROP TABLE Project

-- create the Employee table
CREATE TABLE Employee (
	EmployeeID	CHAR(11)		NOT NULL
,	LastName	VARCHAR(100)	NOT NULL
,	FirstName	VARCHAR(100)	NOT NULL
)

-- create the associative entity
CREATE TABLE EmployeeOnProject (
	EmployeeID		CHAR(11)	NOT NULL
,	ProjectNumber	INT			NOT NULL
,	WeeklyHours		INT			NOT NULL
)

-- create the Project table
CREATE TABLE Project (
	ProjectNumber	INT	IDENTITY(1,1)	NOT NULL
,	ProjectName		VARCHAR(255)		NOT NULL
,	ProjectLocation	VARCHAR(100)		NOT NULL
)

-- list our table definitions
EXEC sp_help Employee
EXEC sp_help EmployeeOnProject
EXEC sp_help Project