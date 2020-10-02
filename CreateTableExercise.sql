-- each of these queries was written by a different student, which is why the style changes throughout.
-- In your own work, please be consistent with your capitalization and usage of commas.

-- specify which db we are using:
USE CreateTableExercise

-- drop old versions of tables:
DROP TABLE Grade
DROP TABLE Activity
DROP TABLE Course
DROP TABLE Student
DROP TABLE Club

-- create Course table
CREATE TABLE Course (
         CourseID        CHAR(6)        NOT NULL	CONSTRAINT PK_Course PRIMARY KEY CLUSTERED 
    ,    CourseName      VARCHAR(40)    NOT NULL
    ,    Hours           SMALLINT		NULL		CONSTRAINT CK_CourseHours CHECK ([Hours] > 0)	-- can use "" []
    ,    NoOfStudents    SMALLINT		NULL		CONSTRAINT CK_NoOfStudents CHECK (NoOfStudents >= 0)
)

-- create Student table
create table Student(
    StudentID           int             NOT NULL	CONSTRAINT PK_Student PRIMARY KEY CLUSTERED,
    StudentFirstName    varchar(40)     NOT NULL,
    StudentLastName     varchar(40)     NOT NULL,
    GenderCode          char(1)         NOT NULL	CONSTRAINT CK_GenderCode CHECK (GenderCode LIKE '[FMX]'),
    Address				varchar(30)     NULL,
    Birthdate           datetime        NULL,
    PostalCode          char(6)         NULL		CONSTRAINT CK_PostalCode CHECK (PostalCode LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]'),
    AvgMark             decimal(4,1)    NULL		CONSTRAINT CK_AvgMark CHECK (AvgMark BETWEEN 0 AND 100),
												--or CONSTRAINT CK_AvgMark CHECK (AvgMark >= 0 AND AvgMark <= 100)
    NoOfCourses         smallint        NULL		CONSTRAINT CK_NoOfCourses CHECK (NoOfCourses >= 0)
		CONSTRAINT DF_NoOfCourses DEFAULT 0,
)

-- create Grade table
CREATE TABLE Grade (
		StudentId   INT			NOT NULL	CONSTRAINT FK_GradeToStudent REFERENCES Student (StudentID)
    ,   CourseID    CHAR(6)     NOT NULL    CONSTRAINT FK_GradeToCourse REFERENCES Course (CourseID)
    ,   Mark        SMALLINT    NULL		CONSTRAINT CK_Mark CHECK (Mark BETWEEN 0 AND 100) CONSTRAINT DF_Mark DEFAULT 0
    ,	CONSTRAINT PK_Grade PRIMARY KEY CLUSTERED (StudentID, CourseID)
)

-- create Club table
CREATE TABLE Club (
        ClubID     INT            NOT NULL CONSTRAINT PK_Club PRIMARY KEY CLUSTERED
    ,   ClubName   VARCHAR(50)    NOT NULL
)

-- create Activity table
CREATE TABLE Activity(
    StudentID    int        NOT NULL  CONSTRAINT FK_ActivityToStudent references Student (StudentID),
    ClubID       int        NOT NULL  CONSTRAINT FK_ActivityToClub references Club (ClubID),
    CONSTRAINT PK_Activity PRIMARY KEY CLUSTERED (StudentID, ClubID),
)

EXEC sp_help Student


-- examples using LIKE
--LIKE 'Edmonton' -- only Edmonton
--LIKE 'Edmonton%' -- also pick up Edmonton AB
--NOT LIKE '%[%]%' -- tentatively

--LIKE '___' -- only pick up something 3 characters long
--LIKE 'da_a' 