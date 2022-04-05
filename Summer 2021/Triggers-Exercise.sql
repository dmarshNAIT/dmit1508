--Triggers Exercise
--(Use IQSchool DB)
USE IQSchool
GO
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


--3.	Too many students owe us money and keep registering for more courses! Create a trigger to ensure that a student cannot register for any more courses if they have a balance owing of >$500.

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

-- insert 0 rows
INSERT INTO Registration
SELECT 1014, StudentID, 85, 'N' FROM Student WHERE StudentID = 999999999999

-- insert 1 row successfully
INSERT INTO Registration (OfferingCode, StudentID, Mark, WithdrawYN)
VALUES (1014, 199899200, 85, 'N')

SELECT * FROM Student
SELECT * FROM Registration WHERE StudentID = 199899200
SELECT * FROM Offering -- 1000 to 1014

-- insert many rows where 1 fails
INSERT INTO Registration (OfferingCode, StudentID, Mark, WithdrawYN)
VALUES (1014, 198933540, 99, 'N') -- balance owing $1000+
	, (1012, 199899200, 55, 'N') -- balance owing $100

SELECT * FROM Registration WHERE StudentID = 198933540

--4.	Our school DBA has suddenly become allergic to Foreign Key constraints and has disabled them in the database! Create a trigger on the Registration table to ensure that only valid StudentIDs and offeringcodes are used for registration records. Try and have the trigger raise an error for each foreign key that is not valid. If you have trouble with this question create the trigger so it just checks for a valid student ID.

-- not realistic, but in here just for kicks:

ALTER TABLE Registration NOCHECK CONSTRAINT fk_RegistrationToOffering
ALTER TABLE Registration NOCHECK CONSTRAINT fk_RegistrationToStudent
GO

CREATE TRIGGER TR_Registration_FK
ON Registration
FOR INSERT, UPDATE
AS

IF @@ROWCOUNT > 0 AND ( UPDATE(StudentID) OR UPDATE(OfferingCode) )
	BEGIN
	-- check if there is invalid StudentID OR invalid OfferingCode
	IF EXISTS (SELECT * 
				FROM inserted 
				WHERE StudentID NOT IN (SELECT StudentID FROM Student)
	) OR EXISTS ( SELECT * 
				FROM inserted 
				WHERE OfferingCode NOT IN (SELECT OfferingCode FROM Offering)
	)
	-- if so, RAISERROR & ROLLBACK
		BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('invalid StudentID or OfferingCode', 16, 1)
		END
		-- if you want to challenge yourself, try re-writing this trigger to have a different error message depending on which field was invalid
	END
RETURN

-- test:
-- happy case: update a registration to a valid offering code
UPDATE Registration SET OfferingCode = 1009 WHERE OfferingCode = 1008 AND StudentID = 199899200
SELECT * FROM Registration WHERE StudentID = 199899200

-- update to an invalid offering code
UPDATE Registration SET OfferingCode = 99999999 WHERE OfferingCode = 1009 AND StudentID = 199899200

-- update to an invalid studentID
UPDATE Registration SET StudentID = 99999999 WHERE OfferingCode = 1009 AND StudentID = 199899200



--5.	Contrary to the advice of the school doctor, the DBA still thinks he is allergic to Foreign Key constraints! Yikes! Create a trigger on the Student table that will ensure that we do not delete any students that have made payments, have Registration records, or belong to any clubs.

-- first, disable the FKs:
ALTER TABLE Registration NOCHECK CONSTRAINT fk_RegistrationToStudent
ALTER TABLE Payment NOCHECK CONSTRAINT FK_paymentToStudent
ALTER TABLE Activity NOCHECK CONSTRAINT FK_ActivityToStudent
GO

-- then, create trigger to replace them:
CREATE TRIGGER TR_CantDeleteStudentsWithRecords
ON Student
FOR DELETE
AS

IF @@ROWCOUNT > 0
	BEGIN
		IF EXISTS ( -- records in Registration
			SELECT * FROM deleted 
			INNER JOIN Registration ON deleted.StudentID = Registration.StudentID
		)
		OR EXISTS ( -- records in Payment
			SELECT * FROM deleted 
			INNER JOIN Payment ON deleted.StudentID = Payment.StudentID
		)
		OR EXISTS ( -- records in Activity
			SELECT * FROM deleted 
			INNER JOIN Activity ON deleted.StudentID = Activity.StudentID
		)
			BEGIN
				RAISERROR('Student has records: cannot delete', 16, 1)
				ROLLBACK TRANSACTION
			END
	END
RETURN
GO



--6.	Not only has the school DBA come down with some mysterious allergy but our network security officer suspects our system has a virus that is allowing students to alter their Balance Owing! In order to track down what is happening we want to create a logging table that will log any changes to the balanceowing in the student table. You must create the logging table and the trigger to populate it when a balance owing is updated.

-- create the logging table
CREATE TABLE BalanceOwingLog (
	LogID INT IDENTITY(1,1) NOT NULL CONSTRAINT pk_BalanceOwingLog PRIMARY KEY CLUSTERED
,	StudentID INT NOT NULL
,	ChangeDate DATETIME NOT NULL
,	OldBalance MONEY NOT NULL
,	NewBalance MONEY NOT NULL
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
	END
RETURN
GO

-- testing:
UPDATE Student
SET BalanceOwing = 1000
WHERE StudentID = 198933540

UPDATE Student
SET BalanceOwing = 0
WHERE StudentID = 198933540

SELECT * FROM Student

SELECT * FROM BalanceOwingLog
GO



--7.	We have learned it is a bad idea to update primary keys. Yet someone keeps trying to update the Club tables ClubID column and the Course tables CourseId column! Create a trigger(s) to stop this from happening! You are authorized to use whatever force is necessary! Well, in your triggers, anyways !

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