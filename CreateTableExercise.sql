-- each of these queries was written by a different student, which is why the style changes throughout.
-- In your own work, please be consistent with your capitalization and usage of commas.

-- create Course table
DROP TABLE Course
CREATE TABLE Course (         CourseID        CHAR(6)        NOT NULL   			CONSTRAINT PK_Course PRIMARY KEY CLUSTERED     ,    CourseName      VARCHAR(40)    NOT NULL    ,    Hours           SMALLINT		NULL -- can use "" []    ,    NoOfStudents    SMALLINT		NULL)


-- create Student table
create table Student(    StudentID           int                NOT NULL    		CONSTRAINT PK_Student PRIMARY KEY CLUSTERED,    StudentFirstName    varchar(40)        NOT NULL,    StudentLastName     varchar(40)        NOT NULL,    GenderCode          char(1)            NOT NULL,    Address				varchar(30)        NULL,    Birthdate           datetime        NULL,    PostalCode          char(6)         NULL,    AvgMark             decimal(4,1)    NULL,    NoOfCourses         smallint        NULL,)

-- create Grade table
CREATE TABLE Grade (		StudentId   INT			NOT NULL    			CONSTRAINT FK_GradeToStudent REFERENCES Student (StudentID)    ,   CourseID    CHAR(6)     NOT NULL    			CONSTRAINT FK_GradeToCourse REFERENCES Course (CourseID)    ,   Mark        SMALLINT    NULL            ,		CONSTRAINT PK_Grade PRIMARY KEY CLUSTERED (StudentID, CourseID))

-- create Club table
CREATE TABLE Club (        ClubID     INT            NOT NULL 			CONSTRAINT PK_Club PRIMARY KEY CLUSTERED    ,   ClubName   VARCHAR(50)    NOT NULL)

-- create Activity table
CREATE TABLE Activity(    StudentID    int        NOT NULL 		CONSTRAINT FK_ActivityToStudent references Student (StudentID),    ClubID       int        NOT NULL 		CONSTRAINT FK_ActivityToClub references Club (ClubID),    CONSTRAINT PK_Activity PRIMARY KEY CLUSTERED (StudentID, ClubID),)EXEC sp_help Activity