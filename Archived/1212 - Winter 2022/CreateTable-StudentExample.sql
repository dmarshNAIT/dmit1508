-- tell SQL which db to use
USE sandbox2022
GO

-- drop old versions of tables first
DROP TABLE IF EXISTS Grade
DROP TABLE IF EXISTS Activity
DROP TABLE IF EXISTS Course
DROP TABLE IF EXISTS Student
DROP TABLE IF EXISTS Club
-- drop child tables first, then parent tables


-- create Course table
CREATE TABLE Course (
	CourseID CHAR(6) NOT NULL CONSTRAINT PK_Course PRIMARY KEY CLUSTERED
,	CourseName VARCHAR(40) NOT NULL
,	[Hours] SMALLINT NULL CONSTRAINT CK_MinHours CHECK (Hours > 0)
,	NoOfStudents SMALLINT NULL CONSTRAINT CK_MinStudents CHECK (NoOfStudents >= 0)
)

-- create Student table
CREATE TABLE Student (
	StudentID INT NOT NULL CONSTRAINT PK_Student PRIMARY KEY CLUSTERED,
	StudentFirstName VARCHAR(40) NOT NULL,
	StudentLastName VARCHAR(40) NOT NULL,
	GenderCode CHAR(1) NOT NULL CONSTRAINT CK_Gender CHECK (GenderCode LIKE '[FMX]') ,
	-- or: CHECK (GenderCode = 'F' OR GenderCode = 'M' OR GenderCode = 'X')
	-- or: check(GenderCode IN ('M', 'F', 'X')
	[Address] VARCHAR(30) NULL,
	Birthdate DATETIME NULL,
	PostalCode CHAR(6) NULL CONSTRAINT CK_PostalCode CHECK (PostalCode LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]'),
	AvgMark DECIMAL(4,1) NULL CONSTRAINT CK_AvgMark CHECK (AvgMark BETWEEN 0 AND 100),
	-- or: CHECK (AvgMark >= 0 AND AvgMark <= 100)
	NoOfCourses SMALLINT NULL 
		CONSTRAINT CK_NumCourses CHECK (NoOfCourses >= 0) 
		CONSTRAINT DF_NumCourses DEFAULT 0
)

-- create Club table
CREATE TABLE CLUB (
	ClubId int NOT NULL CONSTRAINT PK_CLUB PRIMARY KEY CLUSTERED,
	ClubName varchar(50) NOT NULL
)

-- create Grade table (child of Course & Student)
CREATE TABLE GRADE (
	StudentID int NOT NULL CONSTRAINT FK_GRADEToSTUDENT REFERENCES STUDENT(StudentID),
	CourseID char(6) NOT NULL CONSTRAINT FK_GRADEToCOURSE REFERENCES COURSE (CourseID),
	Mark smallint NULL CONSTRAINT CK_Mark CHECK (Mark BETWEEN 0 AND 100) CONSTRAINT DF_Mark DEFAULT 0,
	CONSTRAINT PK_Grade PRIMARY KEY CLUSTERED (StudentID, CourseID)
)

-- create Activity table (child of Student & Club)
CREATE TABLE Activity (
	StudentID INT NOT NULL CONSTRAINT FK_ActivityToStudent REFERENCES Student (StudentID), --FK
	ClubID INT NOT NULL CONSTRAINT FK_ActivityToClub REFERENCES Club (ClubID), --FK
	CONSTRAINT PK_Activity PRIMARY KEY CLUSTERED (StudentID, ClubID)
)

-- verify tables:
EXEC sp_help Course
EXEC sp_help Student
EXEC sp_help Club
EXEC sp_help Grade
EXEC sp_help Activity

-- ALTER TABLE statements:
--Add a MeetingLocation varchar(50) field to the Club table
ALTER TABLE Club ADD MeetingLocation VARCHAR(50) NULL

--Add a constraint to birthdate to ensure the value is < today's date
ALTER TABLE Student 
	ADD CONSTRAINT CK_ValidBirthdate CHECK (Birthdate < GetDate())

--Add a constraint to set a default of 80 to the Hours field
ALTER TABLE Course
	ADD CONSTRAINT DF_Hours DEFAULT 80 FOR Hours

--Oops, changed our minds…. DISABLE the check constraint for the birthdate field
ALTER TABLE Student NOCHECK CONSTRAINT CK_ValidBirthdate

--Yikes! Change our minds again. ENABLE the check constraint for the Birthdate field
ALTER TABLE Student CHECK CONSTRAINT CK_ValidBirthdate

--Hold on! Call me silly. Delete the default constraint for the Hours field now!
ALTER TABLE Course DROP CONSTRAINT DF_Hours

-- add an index for the FKs on the GRADE table:
CREATE NONCLUSTERED INDEX IX_StudentID ON Grade (StudentID)
CREATE NONCLUSTERED INDEX IX_CourseID ON Grade (CourseID)
