-- tell SSMS which db to use:
USE School
GO

-- DROP any old versions of tables
DROP TABLE IF EXISTS Grade
DROP TABLE IF EXISTS Activity
DROP TABLE IF EXISTS Course
DROP TABLE IF EXISTS Club
DROP TABLE IF EXISTS Student


-- CREATE TABLES

CREATE TABLE Student (
	StudentID			INT			NOT NULL	CONSTRAINT PK_Student PRIMARY KEY CLUSTERED
,	StudentFirstName	VARCHAR(40)	NOT NULL 
,	StudentLastName		VARCHAR(40)	NOT NULL
,	GenderCode			CHAR(1)		NOT NULL	--CONSTRAINT CK_Gender CHECK (GenderCode = 'F' OR GenderCode = 'M' OR GenderCode = 'X')
		CONSTRAINT CK_GenderV2 CHECK (GenderCode LIKE '[FMX]')
,	[Address]			VARCHAR(30)	NULL
,	Birthdate			DATETIME	NULL
,	PostalCode			CHAR(6)		NULL		CONSTRAINT CK_PostalCode CHECK (PostalCode LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]')
,	AvgMark				DECIMAL(4,1) NULL		CONSTRAINT CK_AvgMark CHECK (AvgMark BETWEEN 0 AND 100)
,	NoOfCourses			SMALLINT	NULL		CONSTRAINT CK_MinCourses CHECK (NoOfCourses >= 0)
		CONSTRAINT DF_NoOfCourses DEFAULT 0
)

CREATE TABLE CLUB (
	ClubID				INT			NOT NULL	CONSTRAINT PK_Club PRIMARY KEY CLUSTERED
,	ClubName			VARCHAR(50)	NOT NULL
)

CREATE TABLE Course (
	CourseID			CHAR(8)		NOT NULL	CONSTRAINT PK_Course PRIMARY KEY CLUSTERED
,	CourseName			VARCHAR(40)	NOT NULL
,	Hours				SMALLINT	NULL		CONSTRAINT CK_MinHours CHECK (Hours > 0)
,	NoOfStudents		SMALLINT	NULL		CONSTRAINT CK_MinStudents CHECK (NoOfStudents >= 0)
)

CREATE TABLE Activity (
	StudentID			INT			NOT NULL	CONSTRAINT FK_ActivityToStudent REFERENCES Student (StudentID)
,	ClubID				INT			NOT NULL	CONSTRAINT FK_ActivityToClub REFERENCES Club (ClubID)
,	CONSTRAINT PK_Activity PRIMARY KEY CLUSTERED (StudentID, ClubID)
)

CREATE TABLE Grade (
	StudentID			INT			NOT NULL	CONSTRAINT FK_GradeToStudent REFERENCES Student (StudentID)
,	CourseID			CHAR(8)		NOT NULL	CONSTRAINT FK_GradeToCourse REFERENCES Course (CourseID)
,	Mark				SMALLINT	NULL		CONSTRAINT CK_Mark CHECK (Mark BETWEEN 0 AND 100)
		-- or (Mark >= 0 AND Mark <= 100)
		CONSTRAINT DF_Mark DEFAULT 0
,	CONSTRAINT PK_Grade PRIMARY KEY CLUSTERED (StudentID, CourseID)
)


--- ALTER TABLEs:
--1.	Add a MeetingLocation varchar(50) field to the Club table
ALTER TABLE Club 
	ADD MeetingLocation VARCHAR(50) NULL
-- if we don't know for sure that the table is empty,
-- the new column must be NULLable or have a DEFAULT value.

--2.	Add a constraint to birthdate to ensure the value is < today's date
ALTER TABLE Student
	ADD CONSTRAINT CK_Birthdate CHECK (Birthdate < GetDate())

--3.	Add a constraint to set a default of 80 to the Hours field
ALTER TABLE Course
	ADD CONSTRAINT DF_Hours DEFAULT 80 FOR Hours

--4.	Oops, changed our minds…. 
-- DISABLE the check constraint for the birthdate field
ALTER TABLE Student
	NOCHECK CONSTRAINT CK_Birthdate

--5.	Yikes! Change our minds again. 
-- ENABLE the check constraint for the Birthdate field
ALTER TABLE Student
	CHECK CONSTRAINT CK_Birthdate

--6.	Hold on! Call me ridiculous…. 
-- Delete the default constraint for the Hours field now!
ALTER TABLE Course
	DROP CONSTRAINT DF_Hours

-- can we disable an FK?
ALTER TABLE Grade
	NOCHECK CONSTRAINT FK_GradeToCourse