USE danabase


--	1. Add a MeetingLocation varchar(50) field to the Club table

ALTER TABLE Club ADD MeetingLocation VARCHAR(50) NULL

--	2. Add a constraint to birthdate to ensure the value is < today's date

ALTER TABLE Student
	ADD CONSTRAINT CK_ValidBirthDate CHECK (Birthdate < GetDate())

-- 3. Add a constraint to set a default of 80 to the Hours field

ALTER TABLE Course
	ADD CONSTRAINT DF_Hours DEFAULT 80 FOR Hours

--	4. Oops, changed our minds…. DISABLE the check constraint for the birthdate field

ALTER TABLE Student
	NOCHECK CONSTRAINT CK_ValidBirthDate


--	5. Yikes! Change our minds again. ENABLE the check constraint for the Birthdate field

ALTER TABLE Student
	CHECK CONSTRAINT CK_ValidBirthDate


--	6. Hold on! Call me silly… Delete the default constraint for the Hours field now!

ALTER TABLE Course
	DROP CONSTRAINT DF_Hours


-- add indices for each FK
CREATE NONCLUSTERED INDEX IX_StudentIDOnGrade
	ON Grade (StudentID)

CREATE NONCLUSTERED INDEX IX_CourseID 
	ON Grade (CourseID)

CREATE NONCLUSTERED INDEX IX_StudentIDOnActivity
	ON Activity (StudentID)

CREATE NONCLUSTERED INDEX IX_ClubID
	ON Activity (ClubID)