USE IQSchool
GO

-- this is NOT a realistic trigger, this is just an excuse to check out the temp tables

-- Practice Q #1
CREATE TRIGGER TR_PracticeQ1
	ON Student
	FOR UPDATE
AS
	PRINT 'The trigger is starting...'
	SELECT * FROM inserted
	SELECT * FROM deleted
	SELECT * FROM Student -- the "base" table

	PRINT 'Rolling back...'
	ROLLBACK TRANSACTION
	SELECT * FROM inserted
	SELECT * FROM deleted
	SELECT * FROM Student

	PRINT 'Trigger is done.'
RETURN
GO

-- testing time!
-- test with an UPDATE of 1 row
/*
UPDATE Student 
SET BalanceOwing = 99000
WHERE StudentID = 200978500
*/

-- SELECT * FROM Student


-- test with an UPDATE of many rows
UPDATE Student 
SET BalanceOwing = 99000
-- test with an UPDATE of 0 rows
UPDATE Student 
SET BalanceOwing = 99000
WHERE StudentID = 999999
GO

-- using our fancy new DB
USE MovieDB
GO

-- Practice Q #2
-- Character Wage must be >= 0
CREATE TRIGGER TR_PracticeQ2
	ON MovieCharacter
	FOR INSERT, UPDATE
AS

-- check to see if the trigger needs to run
IF @@ROWCOUNT > 0 AND UPDATE(CharacterWage)
	BEGIN
	-- check to see if the rule was broken
	-- i.e. are there any newly updated/inserted records with a wage < 0?
	IF EXISTS (SELECT * FROM inserted WHERE Characterwage < 0)
		BEGIN
		-- if so, undo the change
		ROLLBACK TRANSACTION
		RAISERROR('You must pay your characters', 16, 1)
		END
	END

RETURN

-- test with 0 rows -- UPDATE
UPDATE MovieCharacter SET Characterwage = 100 WHERE CharacterID = 9999
-- we expect nothing to happen, and 0 rows were affected 
-- TEST PASSES!

-- test with 1 row -- INSERT
INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, CharacterWage)
VALUES ('Donald Duck', 'NOT Looney Tunes', 3, .03)

INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, CharacterWage)
VALUES ('Donald Duck', 'NOT Looney Tunes', 3, -.03)

SELECT * FROM MovieCharacter

-- test with many rows -- once successful, once with a violation
GO

-- Practice Q#3
-- Agent Fee cannot increase by MORE than 100% in a single UPDATE
DROP TRIGGER IF EXISTS TR_PracticeQ3
GO

GO
CREATE TRIGGER TR_PracticeQ3
	ON Agent
	FOR UPDATE
AS

-- make sure the trigger needs to run
IF @@ROWCOUNT > 0 AND UPDATE(AgentFee)
	BEGIN
	-- if so, check if the rule was broken.

		-- NOT ALLOWED:
		-- new price > 2 * old price
		-- inserted.AgentFee > 2 * deleted.AgentFee 

		IF EXISTS (SELECT *
					FROM inserted
					INNER JOIN deleted ON inserted.AgentID = deleted.AgentID
					WHERE inserted.AgentFee > 2 * deleted.AgentFee
					)
			BEGIN
			-- if the rule was broken, ROLLBACK & RAISERROR
				RAISERROR('That is too much of an increase', 16, 1)
				ROLLBACK TRANSACTION
			END
	END
RETURN

-- testing time:
-- make sure it works with 0 updates
-- make sure it works with 1 agent updated that does NOT violate the rule
-- make sure it works with many agents updated that does DOES violate the rule
GO

-- Practice Q #4
-- Create a trigger that enforces a rule that a MovieCharacter cannot be deleted if their Agent's AgentFee is >= 50.
DROP TRIGGER IF EXISTS TR_PracticeQ4
GO


CREATE TRIGGER TR_PracticeQ4
	ON MovieCharacter
	FOR DELETE
AS

-- first: see if the trigger needs to run
IF @@ROWCOUNT > 0
	BEGIN

	-- second: see if the rule was broken
	-- look at the deleted characters, and see if any have an agent whose fee >= 50
	IF EXISTS (		SELECT Agent.AgentFee -- or SELECT *, or any field in the table
					FROM deleted -- remember, deleted has the same columns as the base table (MovieCharacter)
					INNER JOIN Agent ON deleted.AgentID = Agent.AgentID
					WHERE Agent.AgentFee >= 50
				)
		BEGIN
		RAISERROR('Your agent makes too much money, you cannot be deleted.', 16, 1)
		ROLLBACK TRANSACTION
		END

	END

RETURN -- marks the end of the trigger

GO

-- Practice Q #5
-- Create a trigger that enforces a rule that an Agent cannot represent more than 2 movie characters.

CREATE TRIGGER TR_PracticeQ5
	ON MovieCharacter
	FOR INSERT, UPDATE
AS

-- first: check if the trigger needs to run
IF @@ROWCOUNT > 0 AND UPDATE(AgentID)
	BEGIN

	-- second: check if the rule was broken
	-- look at the new inserted characters / newly changed characters
	-- connect them to all the OTHER characters with the same AgentID
	-- check if that count of characters PER AGENT > 2
	IF EXISTS (			SELECT *
						FROM inserted
						INNER JOIN MovieCharacter ON inserted.AgentID = MovieCharacter.AgentID 
						GROUP BY MovieCharacter.AgentID -- we want a count PER AGENT
						HAVING COUNT(MovieCharacter.CharacterID) > 2 ) -- where # of characters > 2
		BEGIN
		RAISERROR('That is too many characters!', 16, 1)
		ROLLBACK TRANSACTION
		END
	END
RETURN
GO

-- test time!
-- make sure it works for all the DML operations specified:
-- make sure it works for INSERT						DONE (line 202)
-- make sure it works for UPDATE						DONE (line 212)

-- make sure it works for any number of rows:
-- make sure it works for 0 rows						DONE (line 212)
-- make sure it works for 1 row							DONE (line 202)
-- make sure it works for many rows						DONE (line 218)

-- make sure both branches of the IF statement are tested:
-- make sure it works when the rule is violated			DONE (line 202)
-- make sure it works when the rule is NOT violated		DONE (line 207)

SELECT * FROM MovieCharacter
-- AgentID #2 already has 2 characters
-- let's try adding another.
INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, Characterwage, AgentID)
VALUES ('Rodney', 'ET', 5, 100000, 2)
-- expectation: not allowed because too many characters
-- actual: the same!

INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, Characterwage, AgentID)
VALUES ('Rodney', 'ET', 5, 100000, 3)
-- expectation: should be allowed!
-- actual: it was!

UPDATE MovieCharacter
SET AgentID = 3
WHERE CharacterID = 99999
-- expectation: successfully update 0 rows
-- actual: SAME!

UPDATE MovieCharacter
SET AgentID = 3
-- expectation: not allowed
-- actual: same!

-- Practice Q #6
-- Create a trigger to Log when changes are made to the CourseCost in the Course table. The changes will be inserted in to the following Logging table:

USE IQSchool
GO

DROP TABLE IF EXISTS CourseChanges
GO

CREATE TABLE CourseChanges(
LogID INT IDENTITY(1,1) NOT NULL 
CONSTRAINT pk_CourseChanges PRIMARY KEY CLUSTERED
,	ChangeDate datetime NOT NULL
,	OldCourseCost money NOT NULL
,	NewCourseCost money NOT NULL
,	CourseID CHAR(8) NOT NULL 		-- not CHAR(7)
)


SELECT * FROM CourseChanges

GO

CREATE TRIGGER TR_PracticeQ6
	ON Course
	FOR UPDATE
AS

-- first: check if the trigger needs to run (are there any records to log?)
IF @@ROWCOUNT > 0 AND UPDATE(CourseCost)	
	BEGIN
	-- if so, INSERT records into the Logging table

	INSERT INTO CourseChanges (ChangeDate, OldCourseCost, NewCourseCost, CourseID)
	SELECT GetDate(), deleted.CourseCost, inserted.CourseCost, inserted.CourseID
	FROM inserted 
	INNER JOIN deleted ON inserted.CourseId = deleted.CourseId
	WHERE inserted.CourseCost != deleted.CourseCost -- only want to log courses with a different cost

	END
RETURN

-- testing
-- does it work for 0 rows			Yes! tested on line 282
-- does it work for 1 row			YES! Tested on line 275
-- does it work for many rows?		Yes! Tested on line 286

UPDATE Course
SET CourseCost = 0
WHERE CourseID = 'DMIT1508'

SELECT * FROM Course
SELECT * FROM CourseChanges

UPDATE Course
SET CourseCost = 0
WHERE CourseID = 'fdslkdsfkljsdfjkl'

UPDATE Course
SET CourseCost = 0