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
,	[Hours] SMALLINT NULL
,	NoOfStudents SMALLINT NULL
)

-- create Student table
CREATE TABLE Student (
	StudentID INT NOT NULL CONSTRAINT PK_Student PRIMARY KEY CLUSTERED,
	StudentFirstName VARCHAR(40) NOT NULL,
	StudentLastName VARCHAR(40) NOT NULL,
	GenderCode CHAR(1) NOT NULL,
	[Address] VARCHAR(30) NULL,
	Birthdate DATETIME NULL,
	PostalCode CHAR(6) NULL,
	AvgMark DECIMAL(4,1) NULL,
	NoOfCourses SMALLINT NULL
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
	Mark smallint Null,
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