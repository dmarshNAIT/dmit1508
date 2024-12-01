Use MovieDB
GO

--------------------- PRACTICE Q #1 ---------------------
-- this question was included purely to demonstrate what the temp tables look like and isn't a very realistic trigger, so has been excluded.


--------------------- PRACTICE Q #2 ---------------------
-- Create a trigger to enforce a rule that CharacterWages must be >= 0.

CREATE TRIGGER TR_PositiveWage
	ON MovieCharacter
	FOR INSERT, UPDATE -- this means this trigger will run for EVERY INSERT & UPDATE on the MovieCharacter table.
AS
	-- first, let's check to see if the trigger needs to run
		-- doesn't need to run if 0 characters were inserted/updated
		-- doesn't need to run if we're not changing the value of Wage
	IF @@ROWCOUNT > 0 AND UPDATE(CharacterWage)
		BEGIN
		-- second, let's check if that rule was violated
			-- i.e. check the INSERTED table to see if any records have wage < 0
		-- if so, ROLLBACK
		IF EXISTS (SELECT * FROM inserted WHERE Characterwage < 0)
			BEGIN
			RAISERROR('You must pay your characters!', 16, 1)
			ROLLBACK TRANSACTION
			END
		END
RETURN -- this marks the end of the trigger
GO

--------------------- PRACTICE Q #3 ---------------------
--Create a trigger that enforces a rule that an AgentFee cannot be increased by more than 100% in one update.

--e.g. if the AgentFee was $100, I cannot update it to a value greater than $200.

CREATE TRIGGER TR_AgentsCannotDouble
	ON Agent
	FOR UPDATE
AS
	-- first, check if the trigger needs to run: 
		-- i.e. at least one row was updated AND the AgentFee was updated
		-- because we don't care if any other rows were UPDATEd, just AgentFee.
	IF @@ROWCOUNT > 0 AND UPDATE(AgentFee)
		BEGIN
		-- second, let's check if the rule was violated. If so, RAISERROR & ROLLBACK
			-- this means: we must check to see if any Agent has a new value > 2 * old value
		IF EXISTS (	SELECT *
					FROM inserted
					INNER JOIN deleted ON inserted.AgentID = deleted.AgentID -- JOIN the "old" version of the Agent to the "new" version
					WHERE inserted.AgentFee > 2 * deleted.AgentFee )
			BEGIN
			RAISERROR('You make too much money', 16, 1)
			ROLLBACK TRANSACTION
			END
		END
RETURN
GO

--------------------- PRACTICE Q #4 ---------------------
--Create a trigger that enforces a rule that a MovieCharacter cannot be deleted if their Agent's AgentFee is >= 50.

CREATE TRIGGER TR_CantDelete
	ON MovieCharacter
	FOR DELETE
AS

-- first, make sure the trigger needs to run
IF @@ROWCOUNT > 0
	BEGIN
	-- second, check if the rule was violated
	-- let's look at which character(s) were deleted, and see if their agent has a wage >= 50
	IF EXISTS (	SELECT *
				FROM deleted
				INNER JOIN Agent ON deleted.AgentID = Agent.AgentID
				WHERE Agent.AgentFee >= 50	)
		BEGIN
			RAISERROR('Sorry Dave, I cannot do that.', 16, 1)
			ROLLBACK TRANSACTION
		END
	END
RETURN -- this marks the end of the trigger
GO


--------------------- PRACTICE Q #5 ---------------------
-- Create a trigger that enforces a rule that an Agent cannot represent more than 2 movie characters.

CREATE TRIGGER TR_TooManyCharacters
	ON MovieCharacter
	FOR INSERT, UPDATE
AS
-- first, check if the trigger needs to run
IF @@ROWCOUNT > 0 AND UPDATE(AgentID)
	BEGIN
	-- second, check if the rule was violated
	-- look at the character(s) that were inserted/updated
	-- then count the total characters per agent
	IF EXISTS (	SELECT MovieCharacter.AgentID, COUNT(MovieCharacter.CharacterID)
				FROM inserted
				INNER JOIN MovieCharacter ON inserted.AgentID = MovieCharacter.AgentID -- connect the "new" character with their agent
				GROUP BY MovieCharacter.AgentID --  because we want the count per agent
				HAVING COUNT(MovieCharacter.CharacterID) > 2 -- looking at both "old" and "new" characters.
	)
		BEGIN
			RAISERROR('That is too much, man.', 16, 1)
			ROLLBACK TRANSACTION
		END
END
RETURN
GO

--------------------- PRACTICE Q #6 ---------------------
-- Create a trigger to Log when changes are made to the CourseCost in the Course table. The changes will be inserted in to the following Logging table:

USE IQSchool
GO

-- first, let's create the table to hold the changes.
-- this happens OUTSIDE of the trigger because we only want it to be created one time, not every time we update the CourseCost.
CREATE TABLE CourseChanges(
LogID INT IDENTITY(1,1) NOT NULL 
CONSTRAINT pk_CourseChanges PRIMARY KEY CLUSTERED
,	ChangeDate datetime NOT NULL
,	OldCourseCost money NOT NULL
,	NewCourseCost money NOT NULL
,	CourseID CHAR(8) NOT NULL 		-- not CHAR(7)
)


CREATE TRIGGER TR_CostCheck
	ON Course
	FOR UPDATE
AS
-- first, check to see if the trigger needs to run (is there anything to log?)
IF @@ROWCOUNT > 0 AND UPDATE(CourseCost)
	BEGIN
	-- if so, log the changes
	INSERT INTO CourseChanges (ChangeDate, OldCourseCost, NewCourseCost, CourseID)
	SELECT GetDate(), deleted.CourseCost, inserted.CourseCost, inserted.CourseID
	FROM inserted
	INNER JOIN deleted ON inserted.CourseID = deleted.CourseId
	WHERE inserted.CourseCost != deleted.CourseCost -- we only care if the CourseCost changed.
	END
RETURN
GO

--------------------- PRACTICE Q #7 ---------------------
-- Create a trigger to enforce referential integrity between the Agent and MovieCharacter table.
-- realistically, we will use FKs to enforce referential integrity, so this has been intentionally left out.