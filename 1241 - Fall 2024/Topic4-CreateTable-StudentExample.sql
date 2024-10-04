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
	StudentID INT NOT NULL
,	GenderCode CHAR(1) NOT NULL
		--CONSTRAINT CK_Gender CHECK (GenderCode LIKE '[FMX]')
		--CONSTRAINT CK_Gender CHECK (GenderCode IN ('F','M','X')
		CONSTRAINT CK_Gender CHECK (GenderCode = 'F'
									OR GenderCode = 'M'
									OR GenderCode = 'X')
....
)

-- create the child tables 


