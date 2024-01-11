CREATE TABLE Customer (
	CustomerNumber	INT IDENTITY(1,1)	NOT NULL
,	LastName		VARCHAR(100)		NOT NULL	
,	FirstName		VARCHAR(100)		NOT NULL
,	Phone			CHAR(8)				NULL
)

EXEC sp_help Customer