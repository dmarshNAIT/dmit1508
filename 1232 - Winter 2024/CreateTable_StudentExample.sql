-- identify which DB to use
USE Sandbox3

-- create each table
CREATE TABLE Course (
	CourseID	CHAR(6)		NOT NULL
,	CourseName	VARCHAR(40)	NOT NULL
,	Hours		SMALLINT	NULL
,	NoOfStudents SMALLINT	NULL
)

CREATE TABLE Student (
	StudentID INT NOT NULL
,	StudentFirstName VARCHAR(40) NOT NULL
,	StudentLastName VARCHAR(40) NOT NULL
,	GenderCode CHAR(1) NOT NULL
,	[Address] VARCHAR(30) NULL
,	Birthdate DATETIME NULL
,	PostalCode CHAR(6) NULL
,	AvgMark DECIMAL(4,1) NULL
,	NoOfCourses SMALLINT NULL
)

CREATE TABLE Club (
	ClubID INT NOT NULL
,	ClubName VARCHAR(50) NOT NULL
)

CREATE TABLE Grade (
	StudentID INT  NOT NULL
,	CourseID CHAR(6)  NOT NULL
,	Mark SMALLINT NULL 
)

CREATE TABLE Activity (
	StudentID INT NOT NULL
,	ClubID INT NOT NULL
)