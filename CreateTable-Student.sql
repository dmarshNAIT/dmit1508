-- drop the old versions of the tables first:
DROP TABLE IF EXISTS Activity
DROP TABLE IF EXISTS Grade
DROP TABLE IF EXISTS Student
DROP TABLE IF EXISTS Course
DROP TABLE IF EXISTS Club
-- we drop the CHILD tables before their PARENT tables

-- create Course table
CREATE TABLE Course (
	CourseID CHAR(6) NOT NULL CONSTRAINT PK_Course PRIMARY KEY CLUSTERED,
	CourseName VARCHAR(40) NOT NULL,
	[Hours] SMALLINT NULL,
	NoOfStudents SMALLINT NULL
)

-- create Student table
CREATE TABLE Student (
            StudentID INT NOT NULL CONSTRAINT PK_Student PRIMARY KEY CLUSTERED
,           StudentFirstName VarChar(40) NOT NULL
,           StudentLastName VarChar(40) NOT NULL
,           GenderCode Char(1) NOT NULL
,           Address VarChar(30) NULL
,           Birthdate DateTime NULL
,           PostalCode Char(6) NULL
,           AvgMark Decimal (4,1) NULL
,           NoOfCourses SmallINT NULL
)

-- Grade is a child table of Course & Student, so has to be created AFTER Course & Student
CREATE TABLE Grade (
	StudentID INT NOT NULL,
	CourseID CHAR(6) NOT NULL,
	Mark SMALLINT NULL,
	CONSTRAINT PK_Grade PRIMARY KEY CLUSTERED (StudentID, CourseID)
)

-- create Club table:
CREATE TABLE Club (
	ClubID INT NOT NULL CONSTRAINT PK_Club PRIMARY KEY CLUSTERED
,	ClubName VARCHAR(50) NOT NULL
)

-- Activity is a child table of Club & Student, so has to be created AFTER Club & Student
CREATE TABLE Activity (
	StudentID INT NOT NULL,
	ClubID INT NOT NULL,
	CONSTRAINT PK_Activity PRIMARY KEY CLUSTERED (StudentID, ClubID)
)