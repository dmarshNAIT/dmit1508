USE IQSchool
GO

-- inserting a single record
exec sp_help Staff
select * from Staff

INSERT INTO Staff (StaffID, FirstName, LastName, DateHired, DateReleased, PositionID, LoginID)
VALUES (11, 'Dana', 'Marsh', 'Aug 1 2019', NULL, 5, NULL)

-- insert a single record including a subquery
INSERT INTO Staff (StaffID, FirstName, LastName, DateHired, DateReleased, PositionID, LoginID)
VALUES (12, 'Maimee', 'Zaraska', 'May 1 2020', NULL, (SELECT PositionID FROM Position WHERE PositionDescription = 'Office Administrator'), NULL)

-- insert using a SELECT
INSERT INTO Position (PositionID, PositionDescription)
SELECT MAX(PositionID) + 1, 'Therapy Dog' FROM Position

-- insert multiple records
INSERT INTO Club (ClubID, ClubName)
VALUES ('DAS', 'Dog Appreciation Society')
	, ('IHP', 'I Hate Pigeons Club')

SELECT * FROM Club

-- update record
UPDATE Club
SET ClubName = 'Dog Appreciation Society'
WHERE ClubId = 'DAS'

SELECT * FROM Course
-- update Web Design 1 to be as expensive as the most expensive course:
UPDATE Course
SET CourseCost = (SELECT Max(CourseCost) FROM Course)
	, MaxStudents = 10
WHERE CourseId = 'DMIT108'

-- testing a DELETE before I actually delete:
SELECT * FROM Club WHERE ClubId = 'IHP'
DELETE FROM Club WHERE ClubId = 'IHP'

SELECT * FROM Club WHERE ClubName LIKE '%hate%'
DELETE FROM Club WHERE ClubName LIKE '%hate%'

-- Views:
CREATE View StudentMarks
AS
SELECT Student.StudentID, Mark
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID 
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode

SELECT *
FROM StudentMarks

GO

ALTER View StudentMarks
AS
SELECT Student.StudentID, Mark
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID 

GO

CREATE View StudentMarksWithEverything
AS
SELECT Student.StudentID, Student.FirstName, Student.LastName, Registration.Mark, Offering.CourseID
FROM Student
INNER JOIN Registration ON Student.StudentID = Registration.StudentID 
INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode

GO

SELECT * 
FROM StudentMarksWithEverything
INNER JOIN Course ON StudentMarksWithEverything.CourseID = Course.CourseId

exec sp_helptext StudentMarksWithEverything