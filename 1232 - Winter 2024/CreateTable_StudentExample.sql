-- identify which DB to use
USE Sandbox3

-- drop any old versions of the tables
DROP TABLE IF EXISTS Activity
DROP TABLE IF EXISTS Grade
DROP TABLE IF EXISTS Club
DROP TABLE IF EXISTS Student
DROP TABLE IF EXISTS Course
-- we must drop child tables before their parent

-- create each table
CREATE TABLE Course (
	CourseID	CHAR(6) NOT NULL CONSTRAINT PK_Course PRIMARY KEY CLUSTERED
,	CourseName	VARCHAR(40)	NOT NULL
,	Hours		SMALLINT	NULL CONSTRAINT CK_Hours CHECK (Hours > 0)
,	NoOfStudents SMALLINT	NULL 
		CONSTRAINT CK_Students CHECK (NoOfStudents >= 0)
)

CREATE TABLE Student (
	StudentID INT NOT NULL CONSTRAINT PK_Student PRIMARY KEY CLUSTERED
,	StudentFirstName VARCHAR(40) NOT NULL
,	StudentLastName VARCHAR(40) NOT NULL
,	GenderCode CHAR(1) NOT NULL
		--CONSTRAINT CK_Gender CHECK (GenderCode = 'F' OR GenderCode = 'M' OR GenderCode = 'X')
		CONSTRAINT CK_GenderV2 CHECK (GenderCode LIKE '[FMX]')
		-- check constraint is not case-sensitive
,	[Address] VARCHAR(30) NULL
,	Birthdate DATETIME NULL
,	PostalCode CHAR(6) NULL
		CONSTRAINT CK_PostalCode 
			CHECK (PostalCode LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]')
,	AvgMark DECIMAL(4,1) NULL
		CONSTRAINT CK_AvgMark CHECK (AvgMark BETWEEN 0 AND 100)
		-- or: AvgMark >= 0 AND AvgMark <= 100
,	NoOfCourses SMALLINT NULL CONSTRAINT DF_Courses DEFAULT 0
		CONSTRAINT CK_Courses CHECK (NoOfCourses >= 0)
)

CREATE TABLE Club (
	ClubID INT NOT NULL CONSTRAINT PK_Club PRIMARY KEY CLUSTERED
,	ClubName VARCHAR(50) NOT NULL
)

CREATE TABLE Grade (
	StudentID INT  NOT NULL
		CONSTRAINT FK_GradeToStudent REFERENCES Student (StudentID)
,	CourseID CHAR(6)  NOT NULL
		CONSTRAINT FK_GradeToCourse REFERENCES Course (CourseID)
,	Mark SMALLINT NULL
		CONSTRAINT DF_Mark DEFAULT 0
		-- one way to do this check:
		--CONSTRAINT CK_Mark CHECK (Mark >= 0 AND Mark <= 100)
		-- another way to do the same check:
		CONSTRAINT CK_MarkV2 CHECK (Mark BETWEEN 0 AND 100)
,	CONSTRAINT PK_Grade PRIMARY KEY CLUSTERED (StudentID, CourseID)
)

CREATE TABLE Activity (
	StudentID INT NOT NULL
		CONSTRAINT FK_ActivityToStudent REFERENCES Student (StudentID)
,	ClubID INT NOT NULL
		CONSTRAINT FK_ActivityToClub REFERENCES Club (ClubID)
,	CONSTRAINT PK_Activity PRIMARY KEY CLUSTERED (StudentID, ClubID)
)

-- ALTER TABLE exercise
--Add a MeetingLocation varchar(50) field to the Club table
ALTER TABLE Club 
	ADD MeetingLocation VARCHAR(50) NULL
-- if there are data in the table, we either
-- allow NULL values, OR
-- need to have a DEFAULT value for MeetingLocation

--Add a constraint to birthdate to ensure the value is < today's date
ALTER TABLE Student 
	ADD CONSTRAINT CK_Birthdate CHECK (Birthdate < GetDate())

--Add a constraint to set a default of 80 to the Hours field
ALTER TABLE Course
	ADD CONSTRAINT DF_Hours DEFAULT 80 FOR Hours
-- Default constraints have a slightly different syntax
-- in an ALTER vs a CREATE

--Oops, changed our minds…. DISABLE the check constraint for the birthdate field
ALTER TABLE Student
	NOCHECK CONSTRAINT CK_Birthdate

--Yikes! Change our minds again. ENABLE the check constraint for the Birthdate field
ALTER TABLE Student
	CHECK CONSTRAINT CK_Birthdate

--Hold on! Call me silly. Delete the default constraint for the Hours field now!
ALTER TABLE Course
	DROP CONSTRAINT DF_Hours