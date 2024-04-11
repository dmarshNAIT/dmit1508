USE IQSchool
GO

DROP TRIGGER IF EXISTS TR_SillyStudentUpdateTrigger
GO
-- Practice Q 1
--Create a trigger associated with an UPDATE to Student.Balance. It will:
CREATE TRIGGER TR_SillyStudentUpdateTrigger
	ON Student
	FOR UPDATE
AS
	PRINT 'The trigger is starting...'
	SELECT * FROM inserted
	SELECT * FROM deleted
	SELECT * FROM Student

	ROLLBACK TRANSACTION
	SELECT * FROM inserted
	SELECT * FROM deleted
	SELECT * FROM Student

	PRINT 'The trigger is done.'

RETURN -- this marks the end of the trigger definition
GO

-- now it's time to test
-- make sure it works if I'm UPDATing just one Student
UPDATE Student SET BalanceOwing = 2000 WHERE StudentID = 198933540
-- make sure it works if I'm updating MANY students
UPDATE Student SET BalanceOwing = 2000 WHERE City = 'Edmonton'
-- make sure it works if I'm updating 0 students
UPDATE Student SET BalanceOwing = 2000 WHERE StudentID = 123456789012

GO

USE MovieDB
GO

DROP TRIGGER IF EXISTS TR_PositiveWage
GO
-- Practice Q2
-- Create a trigger to enforce a rule that wages cannot be < 0
CREATE TRIGGER TR_PositiveWage
	ON MovieCharacter
	FOR INSERT, UPDATE
AS
	-- check to see if the trigger needs to run
		-- doesn't need to run if 0 characters were inserted/updated
		-- doesn't need to run if we're not changing the value of Wage
	IF @@ROWCOUNT > 0 AND UPDATE(CharacterWage)
		BEGIN
		-- check if that rule was violated
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

-- TESTING:
-- insert 0 rows
-- insert 1 row
INSERT INTO MovieCharacter	(CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
VALUES ('Scooby Doo', 'Scooby Doo', 4, 0, 3) -- we expect this to work, and it did! :)
-- insert many rows
INSERT INTO MovieCharacter	(CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
VALUES ('Scrappy Doo', 'Scooby Doo', 4, -500, 3), -- this should fail
	('Spiderman', 'OG Spiderman', 5, 0, 2)
-- update 0 rows
-- update 1 row
UPDATE MovieCharacter SET Characterwage = -20 WHERE MovieCharacter.CharacterName = 'Scooby Doo'
-- we expect this to fail, because this violates our rule
-- update many rows
GO

-- Practice Q #3
--Create a trigger that enforces a rule that an AgentFee cannot be increased by more than 100% in one update.
--e.g. if the AgentFee was $100, I cannot update it to a value greater than $200.

CREATE TRIGGER TR_AgentsCannotDouble
	ON Agent
	FOR UPDATE
AS
	-- check if the trigger needs to run: 
		-- at least one row was updated AND the AgentFee was updated
	IF @@ROWCOUNT > 0 AND UPDATE(AgentFee)
		BEGIN
		-- check if the rule was violated. If so, RAISERROR & ROLLBACK
			-- check to see if any pair of records has a new value > 2 * old value
		IF EXISTS (	SELECT *
					FROM inserted
					INNER JOIN deleted ON inserted.AgentID = deleted.AgentID
					WHERE inserted.AgentFee > 2 * deleted.AgentFee )
			BEGIN
			RAISERROR('You make too much money', 16, 1)
			ROLLBACK TRANSACTION
			END
		END
RETURN
GO

--- TESTING:
-- does it work for 0 rows?
UPDATE Agent SET AgentFee = 5 WHERE AgentID = 999999
-- does it work for 1 row?
UPDATE Agent SET AgentFee = 100 WHERE AgentID = 1
UPDATE Agent SET AgentFee = 1000 WHERE AgentID = 1
-- does it work for many rows?
UPDATE Agent SET AgentFee = 100
UPDATE Agent SET AgentFee = 10



DROP TRIGGER IF EXISTS TR_CantDelete
GO

-- Practice Q #4
--Create a trigger that enforces a rule that a MovieCharacter cannot be deleted if their Agent's AgentFee is >= 50.

CREATE TRIGGER TR_CantDelete
	ON MovieCharacter
	FOR DELETE
AS

-- make sure the trigger needs to run
IF @@ROWCOUNT > 0
	BEGIN
	-- if so, check if the rule was violated
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

-- testing:
-- DELETE  0 rows
DELETE FROM MovieCharacter WHERE CharacterID = 99999
-- DELETE 1 row successfully
DELETE FROM MovieCharacter WHERE AgentID = 3
-- DELETE many rows unsuccessfully
DELETE FROM MovieCharacter WHERE AgentID = 2


DROP TRIGGER IF EXISTS TR_TooManyCharacters
GO
-- Practice Q #5
--Create a trigger that enforces a rule that an Agent cannot represent more than 2 movie characters.
CREATE TRIGGER TR_TooManyCharacters
	ON MovieCharacter
	FOR INSERT, UPDATE
AS
-- check if the trigger needs to run
	IF @@ROWCOUNT > 0 AND UPDATE(AgentID)
		BEGIN
	-- if so, check if the rule was violated
		-- look at the character(s) that were inserted/updated
		-- then count the total characters per agent
		IF EXISTS (	SELECT MovieCharacter.AgentID, COUNT(MovieCharacter.CharacterID)
					FROM inserted
					INNER JOIN MovieCharacter ON inserted.AgentID = MovieCharacter.AgentID
					GROUP BY MovieCharacter.AgentID
					HAVING COUNT(MovieCharacter.CharacterID) > 2
		)
			BEGIN
				RAISERROR('That is too much, man.', 16, 1)
				ROLLBACK TRANSACTION
			END
	END
RETURN
GO


-- testing
-- test 0 rows, 1 row, many rows
-- test inserts & updates
-- test successful changes & unsuccessful changes
UPDATE MovieCharacter SET AgentID = 3 WHERE CharacterID = 999 -- successfully did nothing

UPDATE MovieCharacter SET AgentID = 2 WHERE CharacterName = 'R2D2' -- rolled back as expected

INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
VALUES ('Snoopy', 'Charlie Brown Christmas', 5, 10000, 3),
	('Superman', 'Superman', 3, 1, 3)

SELECT * FROM MovieCharacter
SELECT * FROM Agent

--- back to IQ School for #6...
USE IQSchool
GO

CREATE TABLE CourseChanges(
LogID INT IDENTITY(1,1) NOT NULL 
CONSTRAINT pk_CourseChanges PRIMARY KEY CLUSTERED
,	ChangeDate datetime NOT NULL
,	OldCourseCost money NOT NULL
,	NewCourseCost money NOT NULL
,	CourseID CHAR(8) NOT NULL 		-- not CHAR(7)
)
GO

-- Practice Q # 6
-- Create a trigger to Log when changes are made to the CourseCost in the Course table.
CREATE TRIGGER TR_CostCheck
	ON Course
	FOR UPDATE
AS
-- check to see if the trigger needs to run (is there anything to log?)
IF @@ROWCOUNT > 0 AND UPDATE(CourseCost)
	BEGIN
	-- if so, log the changes
	INSERT INTO CourseChanges (ChangeDate, OldCourseCost, NewCourseCost, CourseID)
	SELECT GetDate(), deleted.CourseCost, inserted.CourseCost, inserted.CourseID
	FROM inserted
	INNER JOIN deleted ON inserted.CourseID = deleted.CourseId
	WHERE inserted.CourseCost != deleted.CourseCost
	END
RETURN
GO


-- TESTING:
-- test 0 rows
UPDATE Course SET CourseCost = 500 WHERE CourseID = 'ABC123'
-- test 1 row
UPDATE Course SET CourseCost = 0 WHERE CourseID = 'DMIT1001'
-- test many rows
UPDATE Course SET CourseCost = 20 WHERE MaxStudents = 4 -- why? for fun.

SELECT * FROM Course WHERE MaxStudents = 4
SELECT * FROM CourseChanges