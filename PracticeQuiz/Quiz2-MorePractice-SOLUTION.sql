USE IQSchool
GO

-- Select the average mark per course. Include the course name, and the number of students enrolled.
SELECT Course.CourseName
	, COUNT(reg.StudentID) AS NumberEnrolled
	, AVG(reg.Mark) AS AverageMark
FROM Course
LEFT JOIN Offering on Course.CourseID = Offering.CourseID
LEFT JOIN Registration AS reg on Offering.OfferingCode = reg.OfferingCode
GROUP BY Course.CourseId, Course.CourseName

-- Which course is the cheapest?
SELECT CourseID, CourseName, CourseCost
FROM Course
WHERE CourseCost <= ALL (SELECT CourseCost FROM Course)

-- Do any courses exceed the MaxStudents value?
SELECT Course.CourseName
	, MaxStudents
	, COUNT(reg.StudentID) AS NumberEnrolled
FROM Course
LEFT JOIN Offering on Course.CourseID = Offering.CourseID
LEFT JOIN Registration AS reg on Offering.OfferingCode = reg.OfferingCode
GROUP BY Course.CourseId, Course.CourseName, MaxStudents
HAVING COUNT(reg.StudentID) > MaxStudents

-- Select all the students who are at least 40 years old.
SELECT StudentID, Firstname, LastName, Birthdate
FROM Student
WHERE DATEDIFF(yy, Birthdate, GetDate()) >= 40

-- A "half-birthday" is the date exactly 6 months after your birthday. How many students have a half-birthday in September?
SELECT COUNT(DISTINCT StudentID) AS NumberMarchBabies
FROM Student
WHERE DateName(mm, DateAdd(mm, 6, birthdate)) = 'September'

-- What is the total value of payments made on each day of the week (e.g. Monday, Tuesday)? List the days by name, but order chronologically.
SELECT DateName(dw, PaymentDate) AS DayOfWeek
	, SUM(Amount) AS TotalAmount
FROM Payment
GROUP BY DateName(dw, PaymentDate), DatePart(dw, PaymentDate)
ORDER BY DatePart(dw, PaymentDate)

-- Which day of the week had the largest single payment?
SELECT DateName(dw, PaymentDate) AS DayOfWeek
	, Max(Amount) AS LargestPayment
FROM Payment
GROUP BY DateName(dw, PaymentDate)
HAVING Max(Amount) >= ALL (SELECT Max(Amount)
							FROM Payment
							GROUP BY DateName(dw, PaymentDate))

-- How many students have made payments in the same month as their birthday?
SELECT COUNT(DISTINCT Student.StudentID) AS NumberStudents
FROM Student
INNER JOIN Payment ON Student.StudentID = Payment.StudentID
WHERE Month(Birthdate) = Month(PaymentDate)

-- What is the length, in days, of each semester?
SELECT SemesterCode
	, DateDiff(dd, StartDate, EndDate) AS LengthInDays
FROM Semester

-- What is the most common payment type for each course? List the Course Name and Payment Type Description.

-- Note from Dana: I accidentally made this one MUCH harder than the others. A more reasonable ask would have been: select each course and the payment types that its enrolled students have used. 

-- Anyway, back to the monstrosity I asked you to create... here's a solution in which I create a view to simplify the query.

-- First, create a view that gives me the count of each payment use per course:
GO
CREATE VIEW CoursesWithPayments AS
	SELECT CourseName
		, Course.CourseID
		, PaymentType.PaymentTypeID
		, PaymentTypeDescription
		, COUNT(DISTINCT PaymentID) AS NumberPayments
	FROM Course
	LEFT JOIN Offering on Course.CourseId = Offering.CourseID
	LEFT JOIN Registration ON Offering.OfferingCode = Registration.OfferingCode
	LEFT JOIN Student ON Registration.StudentID = Student.StudentID
	LEFT JOIN Payment ON Student.StudentID = Payment.StudentID
	LEFT JOIN PaymentType ON Payment.PaymentTypeID =PaymentType.PaymentTypeID
	GROUP BY Course.CourseID, CourseName, PaymentType.PaymentTypeID, PaymentTypeDescription
GO

-- Then, use that view in a subquery:
SELECT OuterQuery.CourseId, OuterQuery.CourseName, OuterQuery.PaymentTypeDescription AS MostUsed
FROM CoursesWithPayments AS OuterQuery
INNER JOIN (-- inner query to get the highest count per course
	SELECT CourseID, CourseName, MAX(NumberPayments) AS MostPayments
	FROM CoursesWithPayments
	GROUP BY CourseID, CourseName
) AS InnerQuery ON OuterQuery.CourseId = InnerQuery.CourseId
WHERE OuterQuery.NumberPayments = InnerQuery.MostPayments

-- To reiterate: you are not expected to be able to solve something with such complicated logic.. sorry :(