-- tell SQL which db to use
USE danabase
GO

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
	[Hours] SMALLINT NULL CONSTRAINT CK_Hours CHECK (Hours>0),
	NoOfStudents SMALLINT NULL CONSTRAINT CK_NumStudents CHECK (NoOfStudents >=0)
)

-- create Student table
CREATE TABLE Student (
	StudentID INT NOT NULL CONSTRAINT PK_Student PRIMARY KEY CLUSTERED
,	StudentFirstName VarChar(40) NOT NULL
,	StudentLastName VarChar(40) NOT NULL
,	GenderCode Char(1) NOT NULL
	CONSTRAINT CK_GenderMFX CHECK (GenderCode LIKE '[MFX]' )
		-- or we could have used this: (GenderCode = 'M' OR GenderCode = 'F' OR GenderCode = 'X')
,	Address VarChar(30) NULL
,	Birthdate DateTime NULL
,	PostalCode Char(6) NULL CONSTRAINT CK_PostalCode CHECK (PostalCode LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]')
,	AvgMark Decimal (4,1) NULL CONSTRAINT CK_AvgMark CHECK (AvgMark BETWEEN 0 AND 100)
,	NoOfCourses SmallINT NULL 
		CONSTRAINT CK_NumCourses CHECK (NoOfCourses >=0)
		CONSTRAINT DF_NumCourses DEFAULT 0
)

-- Grade is a child table of Course & Student, so has to be created AFTER Course & Student
CREATE TABLE Grade (
	StudentID INT NOT NULL CONSTRAINT FK_GradeToStudent REFERENCES Student (StudentID),
	CourseID CHAR(6) NOT NULL CONSTRAINT FK_GradeToCourse REFERENCES Course (CourseID),
	Mark SMALLINT NULL 
		CONSTRAINT CK_Mark CHECK (Mark BETWEEN 0 AND 100)
		CONSTRAINT DF_Mark DEFAULT 0,
	CONSTRAINT PK_Grade PRIMARY KEY CLUSTERED (StudentID, CourseID)
)

-- create Club table:
CREATE TABLE Club (
	ClubID INT NOT NULL CONSTRAINT PK_Club PRIMARY KEY CLUSTERED
,	ClubName VARCHAR(50) NOT NULL
)

-- Activity is a child table of Club & Student, so has to be created AFTER Club & Student
CREATE TABLE Activity (
	StudentID INT NOT NULL CONSTRAINT FK_ActivityToStudent REFERENCES Student (StudentID),
	ClubID INT NOT NULL CONSTRAINT FK_ActivityToClub REFERENCES Club (ClubID),
	CONSTRAINT PK_Activity PRIMARY KEY CLUSTERED (StudentID, ClubID)
)

-- verify
EXEC sp_help Grade