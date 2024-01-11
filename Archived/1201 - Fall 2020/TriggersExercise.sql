--Triggers Exercise
USE [IQ-School]
GO

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

CREATE TRIGGER TR_CourseCostLimit
ON Course
FOR UPDATE
AS

IF @@ROWCOUNT > 0 AND UPDATE(CourseCost) -- run trigger only if CourseCost was UPDATEd
	BEGIN

		IF EXISTS (
			SELECT *
			FROM inserted
			INNER JOIN deleted ON inserted.CourseId = deleted.CourseId
			WHERE inserted.CourseCost > deleted.CourseCost * 1.2 -- new value > old value * 1.2
		)
		BEGIN
			RAISERROR('Too much of an increase!', 16, 1)
			ROLLBACK TRANSACTION
		END

	END
RETURN
GO



--3.	Too many students owe us money and keep registering for more courses! Create a trigger to ensure that a student cannot register for any more courses if they have a balance owing of >$500.

CREATE TRIGGER TR_StudentOwesTooMuch
ON Registration
FOR INSERT
AS

IF @@ROWCOUNT > 0 
	BEGIN

	IF EXISTS (
		SELECT *
		FROM inserted
		INNER JOIN Student ON inserted.StudentID = Student.StudentID
		WHERE BalanceOwing > 500
	)
		BEGIN
			RAISERROR('That student owes too much!', 16, 1)
			ROLLBACK TRANSACTION
		END
	END
RETURN
GO




--4.	Our school DBA has suddenly become allergic to Foreign Key constraints and has disabled them in the database! Create a trigger on the Registration table to ensure that only valid StudentIDs and offeringcodes are used for registration records. Try and have the trigger raise an error for each foreign key that is not valid. If you have trouble with this question create the trigger so it just checks for a valid student ID.

ALTER TABLE Registration NOCHECK CONSTRAINT fk_RegistrationToOffering
ALTER TABLE Registration NOCHECK CONSTRAINT fk_RegistrationToStudent
GO

CREATE TRIGGER TR_DBAAllergicToFKs
ON Registration
FOR INSERT, UPDATE
AS

IF @@ROWCOUNT > 0 
BEGIN

	DECLARE @valid CHAR(1)
	SET @valid = 'T'

	IF UPDATE(StudentID) -- if studentID was updated
	BEGIN
		IF EXISTS (
					SELECT * FROM inserted WHERE StudentID NOT IN (SELECT StudentID FROM Student)
		)
			BEGIN
			RAISERROR('invalid studentID', 16, 1)
			SET @valid = 'F'
			END
	END

	IF UPDATE(OfferingCode) -- if offeringcode was updated
	BEGIN
		IF EXISTS ( 
			SELECT * FROM inserted WHERE OfferingCode NOT IN (SELECT OfferingCode FROM Offering)
		)
			BEGIN
			RAISERROR('invalid offering code', 16, 1)
			SET @valid = 'F'
			END
	END

	IF @valid = 'F' -- either failed
		BEGIN
		ROLLBACK TRANSACTION
		END
END 
RETURN
GO




--5.	Contrary to the advice of the school doctor, the DBA still thinks he is allergic to Foreign Key constraints! Yikes! Create a trigger on the Student table that will ensure that we do not delete any students that have made payments, have Registration records, or belong to any clubs.
exec sp_help Activity

ALTER TABLE Registration NOCHECK CONSTRAINT fk_RegistrationToStudent
ALTER TABLE Payment NOCHECK CONSTRAINT FK_paymentToStudent
ALTER TABLE Activity NOCHECK CONSTRAINT FK_ActivityToStudent
GO

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

CREATE TABLE BalanceOwingLog (
	LogID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_BalanceOwingLog PRIMARY KEY CLUSTERED
,	StudentID INT NOT NULL
,	ChangeDateTime DATETIME NOT NULL
,	OldBalanceOwing DECIMAL(7,2) NOT NULL
,	NewBalanceOwing DECIMAL(7,2) NOT NULL
)
GO

CREATE TRIGGER TR_BalanceOwingLog
ON Student
FOR UPDATE
AS

IF @@ROWCOUNT > 0 AND UPDATE(BalanceOwing)
	BEGIN

	INSERT INTO BalanceOwingLog (StudentID, ChangeDateTime, OldBalanceOwing, NewBalanceOwing)
	SELECT inserted.StudentID, GetDate(), deleted.BalanceOwing, inserted.BalanceOwing
	FROM inserted
	INNER JOIN deleted ON inserted.StudentID = deleted.StudentID

	END
RETURN
GO


--7.	We have learned it is a bad idea to update primary keys. Yet someone keeps trying to update the Club table's ClubID column and the Course table's CourseId column! Create a trigger(s) to stop this from happening! You are authorized to use whatever force is necessary! Well, in your triggers, anyways !

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