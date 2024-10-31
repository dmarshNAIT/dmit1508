USE IQSchool

-- INSERT example
SELECT * FROM Course

INSERT INTO Course (CourseID, CourseName, CourseHours, MaxStudents, CourseCost)
VALUES ('DMIT9999', 'Test Course', 100, 10, 500), 
	('DMIT0000', 'Very Real Class', (SELECT AVG(CourseHours) FROM Course), 25, 2000)

SELECT * FROM Course

-- UPDATE example
UPDATE Course
SET CourseHours = 5
WHERE CourseID = 'DMIT0000'

SELECT * FROM Course WHERE CourseID = 'DMIT0000'

-- DELETE example
DELETE FROM Course WHERE CourseID = 'DMIT0000' OR CourseID = 'DMIT9999'