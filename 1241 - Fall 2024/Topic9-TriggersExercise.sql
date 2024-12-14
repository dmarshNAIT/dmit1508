USE IQSchool
GO

-- Q4 from Triggers Exercise

CREATE TABLE BalanceOwingLog (
	LogID INT IDENTITY(1,1) CONSTRAINT PK_Log PRIMARY KEY CLUSTERED
,	StudentID	INT
,	ChangeDateTime	DateTime
,	OldBalance	DECIMAL(7,2)
,	NewBalance	DECIMAL(7,2)
)
GO

CREATE TRIGGER TR_Stinky
	ON Student
	FOR UPDATE
AS

-- does the trigger need to run?
IF @@ROWCOUNT > 0 AND UPDATE(BalanceOwing)
	BEGIN

	-- INSERT records into the logging table
	INSERT INTO BalanceOwingLog (StudentID, OldBalance, NewBalance, ChangeDateTime)
	SELECT inserted.StudentID, deleted.BalanceOwing, inserted.BalanceOwing, GetDate()
	FROM inserted
	INNER JOIN deleted ON inserted.StudentID = deleted.StudentID
	WHERE inserted.BalanceOwing != deleted.BalanceOwing

	END
RETURN
GO

-- Q5
-- prevent anyone from changing the Club table's ClubID 
CREATE TRIGGER TR_NoClubIDChange
	ON Club 
	FOR UPDATE
AS

IF @@ROWCOUNT > 0 AND UPDATE(ClubID)
	BEGIN
	RAISERROR('You cannot do that, sir.', 16, 1)
	ROLLBACK TRANSACTION
	END

RETURN
GO

-- prevent anyone from changing the Course table's CourseID
CREATE TRIGGER TR_NoCourseIDChange
	ON Course
	FOR UPDATE
AS

IF @@ROWCOUNT > 0 AND UPDATE(CourseID)
	BEGIN
	RAISERROR('Nuh uh, cannot do that', 16, 1)
	ROLLBACK TRANSACTION
	END
RETURN
GO


-- Q1 
-- students can belong to a max of 3 clubs

CREATE TRIGGER TR_TooMuchFun
	ON Activity
	FOR INSERT, UPDATE
AS

IF @@ROWCOUNT > 0 AND UPDATE(StudentID)
	BEGIN
	IF EXISTS (	SELECT *
				FROM inserted
				INNER JOIN Activity ON inserted.StudentID = Activity.StudentID
				GROUP BY Activity.StudentID
				HAVING COUNT(*) > 3 )
					BEGIN
					RAISERROR('Too many clubs!', 16, 1)
					ROLLBACK TRANSACTION
					END
	END
RETURN
GO