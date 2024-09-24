USE IQSchool
GO

-- 1. Select the average mark per course. Include the course name, and the number of students enrolled.
-- Clarify: which courses to include? We want ALL courses.

SELECT AVG(Registration.Mark) AS AverageMark
	, Course.CourseName
	, COUNT(Registration.StudentID) AS NumberStudents
FROM Course
LEFT OUTER JOIN Offering ON Course.CourseId = Offering.CourseID
LEFT OUTER JOIN Registration ON Offering.OfferingCode = Registration.OfferingCode
GROUP BY Course.CourseId, Course.CourseName
-- we GROUP BY CourseID to make sure we aren't combining 2 course with the same name
-- we GROUP BY CourseName because that's in our SELECT & not aggregated

-- 2. Which course is the cheapest?

-- 3. Do any courses exceed the MaxStudents value?

-- 4. Select all the students who are at least 40 years old.

-- 5. A "half-birthday" is the date exactly 6 months after your birthday. How many students have a half-birthday in September (month #9)?
-- get a list of students
SELECT COUNT(*) AS NumberMarchBabies
FROM Student
-- whose half-birthday has a month of September
--WHERE DatePart(mm, Birthdate) + 6 = 9
WHERE DateName(mm, DateAdd(mm, 6, Birthdate)) = 'September'

-- 6. What is the total value of payments made on each day of the week (e.g. Monday, Tuesday)? List the days by name, but order chronologically.

-- 7. Which day of the week had the largest single payment?
SELECT DateName(weekday, PaymentDate) AS DayOfWeek
FROM Payment
WHERE Amount = 
		(SELECT MAX(Amount) FROM Payment) -- $225

-- 8. How many students have made payments in the same month as their birthday?


-- 9. What is the length, in days, of each semester?
SELECT SemesterCode,
	DateDiff(dd, StartDate, EndDate) AS NumberOfDays
FROM Semester

-- 10. What is the most common payment type for each course? List the Course Name and Payment Type Description.