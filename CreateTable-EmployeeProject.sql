-- create Employee table

CREATE TABLE Employee (
	EmployeeID CHAR(11) NOT NULL
,	LastName VARCHAR(30) NOT NULL
,	FirstName VARCHAR(30) NOT NULL
)

-- create Project table
CREATE TABLE Project (
	ProjectNumber INT IDENTITY(1,1) NOT NULL
,	ProjectName VARCHAR(50) NOT NULL
,	ProjectLocation VARCHAR(50) NOT NULL
)

-- create EmployeeOnProject table
CREATE TABLE EmployeeOnProject (
	EmployeeID CHAR(11) NOT NULL
,	ProjectNumber INT NOT NULL
,	WeeklyHours SMALLINT NOT NULL
)