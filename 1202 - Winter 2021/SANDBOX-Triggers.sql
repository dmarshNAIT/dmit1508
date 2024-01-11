USE IQSchool
GO


-- practice Q 1:

CREATE TRIGGER TR_Student_Update
	ON Student
	FOR UPDATE
AS

-- print a message: trigger started
PRINT 'Executing trigger now...'
-- view all the tables
SELECT * FROM inserted
SELECT * FROM deleted
SELECT * FROM Student

-- print a message: ROLLBACK
PRINT 'Rolling back...'
-- ROLLBACK
ROLLBACK TRANSACTION
-- view all the tables
SELECT * FROM inserted
SELECT * FROM deleted
SELECT * FROM Student

-- print a message: done
PRINT 'Trigger is complete'

RETURN -- end of trigger

GO

-- test:
-- updating zero rows:
UPDATE Student
SET BalanceOwing = 1000
WHERE StudentID = 999999

SELECT * FROM Student WHERE StudentID = 999999

-- updating 1 row:
UPDATE Student
SET BalanceOwing = 1000
WHERE StudentID = 198933540

SELECT * FROM Student WHERE StudentID = 198933540

-- updating many rows:
UPDATE Student
SET BalanceOwing = 1000

GO


USE MovieCharacter
GO

-- Q2: Create a trigger to enforce a rule that CharacterWages must be >= 0.
CREATE TRIGGER TR_MovieCharacter_INSERT_UPDATE
ON MovieCharacter
FOR INSERT, UPDATE -- triggered by both INSERT and UPDATE statements
AS

IF @@ROWCOUNT > 0 AND UPDATE(CharacterWage)
	-- @@ROWCOUNT tells us how many rows were affected by the last statement.
		-- i.e. how many records are we inserting, updating, or deleting
	-- UPDATE() tells us whether or not a specific column has been updated: it returns TRUE or FALSE
	-- if we don't have any rows to check, or haven't changed the CharacterWage: we're done and can branch around the trigger's logic
	BEGIN
	
	IF EXISTS (SELECT * FROM inserted WHERE CharacterWage < 0)
		BEGIN -- if the rule was broken, ROLLBACK TRANSACTION & RAISERROR
		ROLLBACK TRANSACTION
		RAISERROR('Cannot have wage <0', 16, 1)
		END

	END

-- insert 0 rows: do nothing
-- insert 1 row : check rule
-- insert many rows: check rule
-- update 0 rows: do nothing
-- update 1 row: check rule
-- update many rows: check rule

RETURN -- end of trigger
GO -- end of the batch

-- TEST:
-- insert 0 rows: nothing should happen
-- insert 1 row: test with a "good" wage and a negative wage
INSERT INTO MovieCharacter (CharacterName, CharacterMovie, Characterwage, AgentID)
VALUES ('Spongebob', 'Spongebob', 50000, 1)
-- insert many rows: test with "good" wages, negative wages, and a mix
INSERT INTO MovieCharacter (CharacterName, CharacterMovie, Characterwage, AgentID)
VALUES ('Spongebob', 'Spongebob', 50000, 1),
	('Patrick', 'Spongebob', -20, 1)

SELECT * FROM MovieCharacter
-- update 0 rows: nothing should happen
-- update 1 row: test with a "good" wage and a negative wage
-- update many rows: test with "good" wages, negative wages, and a mix

GO

-- Q3: Create a trigger that enforces a rule that an AgentFee cannot be increased by more than 100% in one update.

CREATE TRIGGER TR_Agent_UPDATE
ON Agent
FOR UPDATE
AS

IF @@ROWCOUNT > 0 AND UPDATE(AgentFee)
	BEGIN
		-- compare the NEW value to the OLD value. if NEW > 2*old, RAISERROR & ROLLBACK
			-- new value: inserted.AgentFee	
			-- old value: deleted.AgentFee

		IF EXISTS (SELECT * FROM inserted
					INNER JOIN deleted ON inserted.AgentID = deleted.AgentID
					WHERE inserted.AgentFee > 2* deleted.AgentFee)
			BEGIN -- if the rule was broken, ROLLBACK TRANSACTION & RAISERROR
			ROLLBACK TRANSACTION
			RAISERROR('that is too much', 16, 1)
			END

	END

RETURN -- end of trigger
GO -- end of batch

-- TEST:
-- test with a big change
UPDATE Agent SET AgentFee = 150 WHERE AgentID = 1
SELECT * FROM Agent
-- test with a small change
UPDATE Agent SET AgentFee = 100 WHERE AgentID = 1
SELECT * FROM Agent

GO

-- Q4: Create a trigger that enforces a rule that a MovieCharacter cannot be deleted if their Agent's AgentFee is >= 50.

CREATE TRIGGER TR_MovieCharacter_DELETE
ON MovieCharacter
FOR DELETE
AS

IF @@ROWCOUNT > 0 
	BEGIN

		-- check if there are any deleted records WHERE the record's agent's agentFee >=50
		IF EXISTS (
			SELECT * FROM deleted
			INNER JOIN Agent ON deleted.AgentID = Agent.AgentID
			WHERE Agent.AgentFee >= 50
		)
			BEGIN -- if the rule was broken, ROLLBACK TRANSACTION & RAISERROR
			ROLLBACK TRANSACTION
			RAISERROR('cannot delete bc agent makes too much', 16, 1)
			END

	END
RETURN
GO


-- Q5: Create a trigger that enforces a rule that an Agent cannot represent more than 2 movie characters.

CREATE TRIGGER TR_MovieCharacter_INSERT_UPDATE
ON MovieCharacter
FOR INSERT, UPDATE
AS

IF @@ROWCOUNT > 0 AND UPDATE(AgentID)
	BEGIN
	IF EXISTS (
				SELECT *
				FROM MovieCharacter
				INNER JOIN inserted ON MovieCharacter.AgentID = inserted.AgentID
				GROUP BY MovieCharacter.AgentID
				HAVING COUNT(*) > 2 -- each agent cannot have more than 2 characters, which means cannot have more than 2 records in the MovieCharacter table
	)
		BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('an Agent cannot represent more than 2 movie characters', 16, 1)
		END
	END
RETURN
GO

-- testing:
SELECT * FROM MovieCharacter

INSERT INTO MovieCharacter (CharacterName, CharacterMovie, Characterwage, AgentID)
VALUES  ('Patrick', 'Spongebob', 20, 3)

GO

USE IQSchool
GO

-- Q6: Create a trigger to Log when changes are made to the CourseCost in the Course table. The changes will be inserted in to the following Logging table:

-- first, create the logging table:
CREATE TABLE CourseChanges(
	LogID INT IDENTITY(1,1) NOT NULL CONSTRAINT pk_CourseChanges PRIMARY KEY CLUSTERED
	,	ChangeDate datetime NOT NULL
	,	OldCourseCost money NOT NULL
	,	NewCourseCost money NOT NULL
	,	CourseID CHAR(7) NOT NULL
)
GO

-- then, create the trigger to insert records into that logging table:
CREATE TRIGGER TR_Course_UPDATE
ON Course
FOR UPDATE
AS

IF @@ROWCOUNT > 0 AND UPDATE(CourseCost)
	BEGIN
	INSERT INTO CourseChanges (ChangeDate, OldCourseCost, NewCourseCost, CourseID)
	SELECT GetDate(), deleted.CourseCost, inserted.CourseCost, inserted.CourseID
	FROM deleted
	INNER JOIN inserted ON deleted.CourseId = inserted.CourseId
	-- if the prompt specified we only log changes where the value changed, we could add
	-- WHERE inserted.CourseCost != deleted.CourseCost
	END
RETURN

GO



-- Q7: Create a trigger to enforce referential integrity between the Agent and MovieCharacter table.

-- This is a bit of a silly example because FKs already do this for us, but it would make sense if we had separate databases that didn't have FKs defining that relationship.
-- to "hack" this, we will disable the FK between these tables, and recreate the functionality in a trigger instead.

USE MovieCharacter
GO

-- first, disable the FK:
ALTER TABLE MovieCharacter NOCHECK CONSTRAINT fk_MovieCharacterToAgent
GO

-- then, I need 2 triggers. One on the parent, one on the child.

-- on the child table, I need to make sure that every child has a parent record:
CREATE TRIGGER TR_MovieCharacter_FK_Child
ON MovieCharacter
FOR UPDATE, INSERT
AS

IF @@ROWCOUNT > 0 AND UPDATE(AgentID)
	BEGIN
	IF EXISTS (
			SELECT * FROM inserted
			WHERE AgentID NOT IN (Select AgentID FROM Agent)
	
	) -- if there are records with no valid parent
		BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('this child has no parent :(', 16, 1)
		END
	END
RETURN
GO

-- on the parent table, I need to make sure I'm not deleting a parent who has a child:
CREATE TRIGGER TR_MovieCharacter_FK_Parent
ON Agent
FOR DELETE
AS
IF @@ROWCOUNT > 0
	BEGIN
	IF EXISTS (
		SELECT * FROM deleted
		INNER JOIN MovieCharacter ON deleted.AgentID = MovieCharacter.AgentID
	) -- if this parent has 1+ child record
		BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('this parent has children: cannot dropkick', 16, 1)
		END
	END
RETURN
GO