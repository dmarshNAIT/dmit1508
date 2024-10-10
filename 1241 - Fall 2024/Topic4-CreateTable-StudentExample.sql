/* this solution isn't finished yet.
 to see a completed sample, go to
 https://github.com/dmarshNAIT/dmit1508/blob/main/Archived/1232%20-%20Winter%202024/CreateTable_StudentExample.sql
 */


-- create the parent tables
CREATE TABLE COURSE (
	CourseID CHAR(8) NOT NULL 
		CONSTRAINT PK_Course PRIMARY KEY CLUSTERED
,	CourseName VARCHAR(40) NOT NULL
,	Hours SMALLINT NULL 
		CONSTRAINT CK_MinHours CHECK (Hours > 0)
,	NoOfStudents SMALLINT NULL
		CONSTRAINT CK_MinStudents CHECK (NoOfStudents >= 0)
)

CREATE TABLE Student (
	StudentID INT NOT NULL CONSTRAINT PK_Student PRIMARY KEY CLUSTERED
,	StudentFirstName VARCHAR(40) NOT NULL
,	StudentLastName VARCHAR(40) NOT NULL
,	GenderCode CHAR(1) NOT NULL
		--CONSTRAINT CK_Gender CHECK (GenderCode LIKE '[FMX]')
		--CONSTRAINT CK_Gender CHECK (GenderCode IN ('F','M','X')
		CONSTRAINT CK_Gender CHECK (GenderCode = 'F'
									OR GenderCode = 'M'
									OR GenderCode = 'X')
,	Address VARCHAR(30) NULL
,	Birthdate DATETIME NULL
,	PostalCode CHAR(6) NULL 
		CONSTRAINT CK_PostalCode CHECK (PostalCode LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]')
,	AvgMark DECIMAL(4,1) NULL
		-- CONSTRAINT CK_AvgMark CHECK (AvgMark BETWEEN 0 AND 100)
		CONSTRAINT CK_AvgMark CHECK (AvgMark >= 0 AND AvgMark <= 100)
,	NoOfCourses SMALLINT NULL
		CONSTRAINT CK_NoOfCourses CHECK ( NoOfCourses >= 0)
		CONSTRAINT DF_NoOfCourses DEFAULT 0
)

--1. attributes: including data types & nullability & technical keys
--2. PK & FK
--3. check & default


-- create the child tables 


