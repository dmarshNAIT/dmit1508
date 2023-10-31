/* These are sample solutions, and in some cases there may be other correct answers.
If you aren't sure if your alternate answer is correct, please drop it in the Questions channel on Teams and I am happy to take a look.
*/

USE IQSchool
GO


--1a. Select the firstname, lastname, and paymentdates for studentid 199899200
SELECT firstname
	, lastname
	, paymentdate
FROM student
INNER JOIN payment ON student.StudentID = payment.studentid
WHERE Student.studentid = 199899200

--1b. Select the Student full name, courseIDs and marks for studentID 199899200.
SELECT firstname + ' ' + lastname AS 'StudentName'
	, courseid
	, mark
FROM student
INNER JOIN registration ON student.studentid = registration.studentid
INNER JOIN offering ON offering.OfferingCode = Registration.OfferingCode
WHERE student.studentid = 199899200

--2a. Which Positions have more than 1 staff in them?
SELECT position.positionid
	, positionDescription
FROM position
INNER JOIN staff ON position.PositionID = staff.PositionID
GROUP BY position.positionID
	, PositionDescription
HAVING count(*) > 1

--2b. Which clubs have 3 or more students in them? Display the Club Names.
SELECT clubname
FROM club
INNER JOIN Activity ON club.ClubId = Activity.ClubId
GROUP BY club.clubid
	, clubname
HAVING count(*) >= 3 -- corrected Oct 31, 2023

--3a. Select the staff fullnames, their hiredate, and the month NAME they were hired. List them in chronological order by month
SELECT firstname + ' ' + lastname AS 'StaffName'
	, DateHired
	, datename(mm, DateHired) AS 'MonthHired'
FROM staff
ORDER BY month(DateHired)

--4. How many students firstnames start with each letter? Show the letter and the count.
SELECT left(FirstName, 1) AS 'Letter'
	, count(*) AS 'LetterCount'
FROM student
GROUP BY left(FirstName, 1)

--5a. Select the student names that have no payments.
SELECT firstname + ' ' + lastname AS 'StudentName'
FROM student
WHERE StudentID NOT IN (
		SELECT Studentid
		FROM payment
		)

--5b. Select all the staff names that have not taught a course.
SELECT firstname + ' ' + lastname AS 'StaffName'
FROM staff
WHERE staffid NOT IN (
		SELECT staffid
		FROM offering
		)

--6. Create a View called StudentPayments that contains studentID, firstname, lastname, paymentdate, and amount.
GO
CREATE VIEW StudentPayments
AS
SELECT Student.StudentID
	, firstname
	, lastname
	, paymentdate
	, Amount
FROM student
INNER JOIN payment ON student.Studentid = payment.studentid
GO

--7. Using the StudentPayments view Select the StudentID , firstname,lastname, and average payment amount.
SELECT StudentID
	, firstname
	, lastname
	, AVG(Amount)
FROM StudentPayments
GROUP BY StudentID
	, firstname
	, lastname

--8. Add $10 to the balance owing for all students who have at least one mark <50
UPDATE student
SET BalanceOwing += 10
WHERE studentid IN (
		SELECT studentid
		FROM registration
		WHERE mark < 50
		)

--9. Add a new course which has a coursecost which is the average coursecost of the other courses.
INSERT INTO course (
	CourseId
	, CourseName
	, CourseHours
	, MaxStudents
	, CourseCost
	)
VALUES (
	'ABC1234'
	, 'SQL Forever'
	, '20'
	, 12
	, (
		SELECT avg(courseCost)
		FROM course
		)
	)

--10. Delete all the staff that are not teaching anything
DELETE
FROM staff
WHERE staffid NOT IN (
		SELECT staffid
		FROM offering
		)

-- 11 - Oops, we forgot something. Assuming the table already contains data, add a new column to the Student table called Major. This will contain the subject each student is studying, if they have selected one.
ALTER TABLE Student
ADD Major VARCHAR(30) NULL

-- 12. Create indexes for each FK in the database.
CREATE NONCLUSTERED INDEX IX_Payment_StudentID ON Payment(StudentID)
CREATE NONCLUSTERED INDEX IX_Payment_PaymentTypeID ON Payment(PaymentTypeID)
CREATE NONCLUSTERED INDEX IX_Registration_StudentID ON Registration(StudentID)
CREATE NONCLUSTERED INDEX IX_Registration_OfferingCode ON Registration(OfferingCode)
CREATE NONCLUSTERED INDEX IX_Activity_StudentID ON Activity(StudentID)
CREATE NONCLUSTERED INDEX IX_Activity_ClubID ON Activity(ClubID)
CREATE NONCLUSTERED INDEX IX_Offering_StaffID ON Offering(StaffID)
CREATE NONCLUSTERED INDEX IX_Offering_CourseID ON Offering(CourseID)
CREATE NONCLUSTERED INDEX IX_Offering_SemesterCode ON Offering(SemesterCode)
CREATE NONCLUSTERED INDEX IX_Staff_PositionID ON Staff(PositionID)

-- 13. Modify the CREATE TABLE statements for IQ School to add the following constraints:
-- a) the PositionDescription must be at least 4 characters long.
-- this would be added to line 19 of the IQ School creation script:
CONSTRAINT CK_PositionDescription CHECK (LEN(PositionDescription) >= 4) 

-- b) the default value for PositionID on a new Staff is 4.
-- this would be added to line 77
CONSTRAINT DF_PositionOfStaff DEFAULT 4

-- c) The ClubName cannot contain any numbers.
-- added to line 27:
CONSTRAINT CK_ClubName CHECK (ClubName NOT LIKE '%[0-9]%')

-- d) The default ClubName is 'Unknown'.
-- added to line 27:
CONSTRAINT DF_ClubName DEFAULT 'Unknown'