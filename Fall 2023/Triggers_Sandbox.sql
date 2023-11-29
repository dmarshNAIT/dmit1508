USE IQSchool
GO

CREATE TRIGGER TR_Student_Update
	ON Student -- this is the base table
	FOR UPDATE
AS

	-- print message
	PRINT 'Trigger is starting...'
	-- show the contents of all 3 table
	SELECT * FROM inserted
	SELECT * FROM deleted
	SELECT * FROM Student
	-- roll back
	ROLLBACK TRANSACTION
	-- print message
	PRINT 'Txn has been rolled back.'
	-- show the contents of all 3 table again
	SELECT * FROM inserted
	SELECT * FROM deleted
	SELECT * FROM Student
	-- print message
	PRINT 'Trigger is complete!'

RETURN -- marks the end of the trigger

-- testing time!
-- in order to test this, I need to UPDATE the Student table
UPDATE Student
SET BalanceOwing = 5
WHERE StudentID = 199899200 -- this should try to update just one student

UPDATE Student
SET BalanceOwing = 5
WHERE StudentID = 1 -- NO students were updated

UPDATE Student
SET BalanceOwing = 5
WHERE City = 'Edmonton' -- this should try to update MANY students

SELECT * FROM Student

GO

USE Movie
GO
------------------------------ Practice #2 ------------------------------
-- Create a trigger to enforce a rule that CharacterWages must be >= 0.


CREATE TRIGGER TR_PracticeQ2
	ON MovieCharacter
	FOR INSERT, UPDATE 
AS
-- first, we make sure there is at least one character whose wage is being updated:
IF @@ROWCOUNT > 0 AND UPDATE(CharacterWage)
	BEGIN
	-- check if the newly inserted or updated records violate the rule
	-- if so, we roll back
	IF EXISTS (SELECT * FROM inserted WHERE Characterwage < 0)
		BEGIN
		RAISERROR('Cannot have a negative wage.', 16, 1)
		ROLLBACK TRANSACTION
		END
	END
RETURN

-- test our trigger
-- does it work as expected for 0 rows?
UPDATE MovieCharacter SET CharacterWage = -100 WHERE CharacterID = 9999
INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, Characterwage)
SELECT CharacterName, CharacterMovie, CharacterRating, Characterwage
FROM MovieCharacter WHERE CharacterName = 'Bob'
-- does it work as expected for 1 row?
UPDATE MovieCharacter SET CharacterWage = -100 WHERE CharacterID = 3
UPDATE MovieCharacter SET CharacterWage = 100 WHERE CharacterID = 3
INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, Characterwage)
VALUES ('Miles Morales', 'Spiderverse', 5, 200)
INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, Characterwage)
VALUES ('Ethan Hunt', 'Mission Impossible', 5, -1000)
-- does it work as expected for many rows?
UPDATE MovieCharacter SET Characterwage = 500 WHERE CharacterMovie = 'Star Wars'
UPDATE MovieCharacter SET Characterwage = -5 WHERE CharacterMovie = 'Star Wars'
INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, Characterwage)
VALUES ('Miles Morales', 'Spiderverse', 5, 200), 
('Ethan Hunt', 'Mission Impossible', 5, -1000)

SELECT * FROM MovieCharacter
GO

------------------------------ Practice #3 ------------------------------
-- Create a trigger that enforces a rule that an AgentFee cannot be increased by more than 100% in one update.

CREATE TRIGGER TR_PracticeQ3
	ON Agent
	FOR UPDATE
AS

-- check to see if the trigger needs to run
IF @@ROWCOUNT > 0 AND UPDATE(AgentFee)
	BEGIN

	-- check to see if the rule was broken. 
	-- new value > 2 x old value
	-- new value: inserted table
	-- old value: deleted table
	IF EXISTS (	SELECT * 
				FROM inserted
				INNER JOIN deleted ON inserted.AgentID = deleted.AgentID
				WHERE inserted.AgentFee > 2 * deleted.AgentFee
	) -- if there are any records which violate the rule
	-- if so, RAISERROR & ROLLBACK
		BEGIN
		RAISERROR('Cannot increase fee by more than 100 percent', 16, 1)
		ROLLBACK TRANSACTION
		END

	END
RETURN

-- test:
-- does it work for 0 rows?
UPDATE Agent SET AgentFee = 10000000 WHERE AgentID = 999
-- does it work for 1 row?
UPDATE Agent SET AgentFee = 100 WHERE AgentID = 1
UPDATE Agent SET AgentFee = 1000 WHERE AgentID = 1
-- does it work for many rows?
UPDATE Agent SET AgentFee = 200

SELECT * FROM Agent

GO
------------------------------ Practice #4 ------------------------------
--Create a trigger that enforces a rule that a MovieCharacter cannot be deleted if their Agent's AgentFee is >= 50.
CREATE TRIGGER TR_PracticeQ4
	ON MovieCharacter
	FOR DELETE
AS

-- check to see if the trigger needs to run
IF @@ROWCOUNT > 0
	BEGIN
	-- check to see if the rule was broken
	-- look at the deleted characters, and see if their agent's fee was $50 or more. if so, RAISERROR & ROLLBACK
	IF EXISTS (	SELECT *
				FROM deleted
				INNER JOIN Agent ON deleted.AgentID = Agent.AgentID
				WHERE Agent.AgentFee >= 50)
		BEGIN
		RAISERROR('The agent makes too much to delete this character', 16, 1)
		ROLLBACK TRANSACTION
		END
	END
RETURN

-- Test:
-- delete 0 characters
DELETE FROM MovieCharacter WHERE CharacterID = 99999

-- delete 1 character with a rich agent
UPDATE MovieCharacter SET AgentID = 1 WHERE CharacterName LIKE 'Miles%'

SELECT * FROM MovieCharacter

DELETE FROM MovieCharacter WHERE CharacterName LIKE 'Miles%'

-- delete 1 character successfully
UPDATE MovieCharacter SET AgentID = 3 WHERE CharacterName LIKE 'Miles%'

DELETE FROM MovieCharacter WHERE CharacterName LIKE 'Miles%'

-- delete many characters with a rich agent
DELETE FROM MovieCharacter

-- delete many characters successfully
DELETE FROM MovieCharacter WHERE AgentID = 3
GO

------------------------------ Practice #5 ------------------------------
--Create a trigger that enforces a rule that an Agent cannot represent more than 2 movie characters.
CREATE TRIGGER TR_PracticeQ5
	ON MovieCharacter
	FOR INSERT, UPDATE
AS

-- check to see if the trigger even needs to run
IF @@ROWCOUNT > 0 AND UPDATE(AgentID)
	BEGIN
	-- check to see if the rule was broken. if so, RAISERROR & ROLLBACK
	IF EXISTS (	-- look at the newly inserted/updated characters
				-- count the characters per agent
				SELECT MovieCharacter.AgentID, COUNT(DISTINCT inserted.CharacterID)
				FROM inserted
				INNER JOIN MovieCharacter ON inserted.AgentID = MovieCharacter.AgentID
				GROUP BY MovieCharacter.AgentID
				HAVING COUNT(DISTINCT MovieCharacter.CharacterID) > 2)
		BEGIN
		RAISERROR('Agents cannot represent more than 2 characters', 16, 1)
		ROLLBACK TRANSACTION
		END
	END
RETURN

-- TEST:
-- insert 0 rows
INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, Characterwage)
SELECT CharacterName, CharacterMovie, CharacterRating, Characterwage
FROM MovieCharacter WHERE CharacterName = 'Bob'
-- insert 1 row
INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, Characterwage, AgentID)
VALUES ('Miles Morales', 'Spiderverse', 5, 200, 1)

INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, Characterwage, AgentID)
VALUES ('Miles Morales', 'Spiderverse', 5, 200, 3)
-- insert many rows
INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, Characterwage, AgentID)
VALUES ('Miles Morales', 'Spiderverse', 5, 200, 1), ('Miles Morales', 'Spiderverse', 5, 200, 3)

-- update 0 rows
UPDATE MovieCharacter SET AgentID = 1 WHERE CharacterID = 9999
-- update 1 row
UPDATE MovieCharacter SET AgentID = 2 WHERE CharacterID = 13 -- Miles v1
UPDATE MovieCharacter SET AgentID = 3 WHERE CharacterID = 13 -- Miles v1

-- update many rows
UPDATE MovieCharacter SET AgentID = 1

INSERT INTO Agent (AgentName, AgentFee) VALUES ('Sheena', 100)
UPDATE MovieCharacter SET AgentID = 4 WHERE CharacterName LIKE 'Miles%'

SELECT * FROM Agent
SELECT * FROM MovieCharacter

GO
------------------------------ Practice #6 ------------------------------
USE IQSchool
GO

DROP TABLE IF EXISTS CourseChanges
CREATE TABLE CourseChanges(
LogID INT IDENTITY(1,1) NOT NULL 
CONSTRAINT pk_CourseChanges PRIMARY KEY CLUSTERED
,	ChangeDate datetime NOT NULL
,	OldCourseCost money NOT NULL
,	NewCourseCost money NOT NULL
,	CourseID CHAR(8) NOT NULL
)

GO

-- Create a trigger to Log when changes are made to the CourseCost in the Course table.
DROP TRIGGER IF EXISTS TR_PracticeQ6
GO

CREATE TRIGGER TR_PracticeQ6
	ON Course
	FOR UPDATE
AS
-- is there anything to log?
IF @@ROWCOUNT > 0 AND UPDATE(CourseCost)
	BEGIN

	-- if so, INSERT it into the log table
	INSERT INTO CourseChanges (ChangeDate, OldCourseCost, NewCourseCost, CourseID)
	SELECT GetDate(), deleted.CourseCost, inserted.CourseCost, inserted.CourseId
	FROM inserted
	INNER JOIN deleted ON inserted.CourseId = deleted.CourseId
	WHERE inserted.CourseCost != deleted.CourseCost

	END
RETURN

-- test:
-- update 0 rows
-- update 1 row
UPDATE Course SET CourseCost = 0 WHERE CourseId = 'DMIT1508'
-- update many rows

SELECT * FROM Course
SELECT * FROM CourseChanges
