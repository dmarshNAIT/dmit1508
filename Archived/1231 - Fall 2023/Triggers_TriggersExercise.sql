--Triggers Exercise
--(Use IQSchool Database)
--NOTE: These questions are not in order of increasing difficulty

--1.	In order to be fair to all students, a student can only belong to a maximum of 3 clubs. Create a trigger to enforce this rule.

CREATE TRIGGER TR_Max3Clubs
ON Activity
FOR INSERT, UPDATE
AS

IF @@ROWCOUNT > 0 AND UPDATE(StudentID) 
-- UPDATE() -- returns true if the column in the parentheses was updated
			-- returns false otherwise
	BEGIN
	IF EXISTS (
		SELECT *
		FROM Activity 
		INNER JOIN inserted ON Activity.StudentID = inserted.StudentID
		GROUP BY Activity.studentId
		HAVING COUNT(*) > 3 )
		-- this will only return something: if a student has been inserted/updated AND now shows up in Activity more than 3 times
		BEGIN
			RAISERROR('Max of 3 clubs per student', 16, 1)
			ROLLBACK TRANSACTION
		END
	END
RETURN

GO

--2.	The Education Board is concerned with rising course costs! Create a trigger to ensure that a course cost does not get increased by more than 20% at any one time.

CREATE TRIGGER TR_RisingCourseCosts
ON Course
FOR UPDATE
AS

IF @@ROWCOUNT > 0 AND UPDATE(CourseCost)
	BEGIN
	-- is there any record(s) where the NEW value > OLD value * 1.2
	IF EXISTS ( SELECT * 
			FROM inserted 
			INNER JOIN deleted ON inserted.CourseId = deleted.CourseId
			WHERE inserted.CourseCost > 1.2 * deleted.CourseCost
	)
		BEGIN
		RAISERROR('Too much!', 16, 1)
		ROLLBACK TRANSACTION
		END
	END

RETURN
GO


--3.	Too many students owe us money and keep registering for more courses! Create a trigger to ensure that a student cannot register for any more courses if they have a balance owing of more than $500.

CREATE TRIGGER TR_SchoolIsExpensive
ON Registration
FOR INSERT
AS

IF @@ROWCOUNT > 0
	BEGIN

	IF EXISTS (SELECT *
				FROM inserted
				INNER JOIN Student ON inserted.StudentID = Student.StudentID
				WHERE BalanceOwing > 500
	)
		BEGIN
		RAISERROR('cannot register until you pay', 16, 1)
		ROLLBACK TRANSACTION
		END
	END
RETURN
GO

--4.	Our network security officer suspects our system has a virus that is allowing students to alter their Balance Owing! In order to track down what is happening we want to create a logging table that will log any changes to the BalanceOwing column in the student table. You must create the logging table and the trigger to populate it when a balance owing is updated. LogID is the primary key and will have Identity (1,1).

--BalanceOwingLog
--LogID	int
--StudentID	Int
--ChangeDateTime	datetime
--OldBalance	decimal (7,2)
--NewBalance	decimal (7,2)

-- create the logging table
CREATE TABLE BalanceOwingLog (
	LogID INT IDENTITY(1,1) NOT NULL CONSTRAINT pk_BalanceOwingLog PRIMARY KEY CLUSTERED
,	StudentID INT NOT NULL
,	ChangeDate DATETIME NOT NULL
,	OldBalance DECIMAL(7,2) NOT NULL
,	NewBalance DECIMAL(7,2) NOT NULL
)
GO

-- create a trigger that adds records to the logging table
CREATE TRIGGER TR_Student_UPDATE_BalanceOwing
ON Student
FOR UPDATE
AS

IF @@ROWCOUNT > 0 AND UPDATE(BalanceOwing)
	BEGIN
	INSERT INTO BalanceOwingLog (StudentID, ChangeDate, OldBalance, NewBalance)
	SELECT inserted.StudentID, GetDate(), deleted.BalanceOwing, inserted.BalanceOwing
	FROM inserted INNER JOIN deleted on inserted.StudentID = deleted.StudentID
	WHERE deleted.BalanceOwing != inserted.BalanceOwing
	END
RETURN
GO

--5.	We have learned it is a bad idea to update primary keys. Yet someone keeps trying to update the Club tables ClubID column and the Course tables CourseID column! Create a trigger(s) to stop this from happening! You are authorized to use whatever force is necessary! Well, in your triggers, anyways !


CREATE TRIGGER TR_CantChangeClubID
ON Club
FOR UPDATE
AS

IF @@ROWCOUNT > 0 AND UPDATE(ClubID)
	BEGIN
	RAISERROR('Cannot update ClubID', 16, 1)
	ROLLBACK TRANSACTION
	END
RETURN
GO




CREATE TRIGGER TR_CantChangeCourseID
ON Course
FOR UPDATE
AS

IF @@ROWCOUNT > 0 AND UPDATE(CourseID)
	BEGIN
	RAISERROR('Cannot change CourseID', 16, 1)
	ROLLBACK TRANSACTION
	END

RETURN
GO