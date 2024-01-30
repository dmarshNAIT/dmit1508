-- this is a comment

/* hello 
	this is also a comment
*/

-- create our Employee table:
CREATE TABLE Employee (
	EmployeeID CHAR(11)	NOT NULL
,	LastName VARCHAR(100) NOT NULL
,	FirstName VARCHAR(100) NOT NULL
)

-- verify my table:
EXEC sp_help Employee

-- create Project table:
CREATE TABLE Project (
	ProjectNumber INT IDENTITY(1,1) NOT NULL
,	ProjectName VARCHAR(50) NOT NULL
,	ProjectLocation VARCHAR(50) NOT NULL
)

CREATE TABLE EmployeeOnProject (
	EmployeeID CHAR(11)	NOT NULL
,	ProjectNumber INT NOT NULL
,	WeeklyHours INT NOT NULL
)