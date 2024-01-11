-- Subquery examples

SELECT PaymentDate, Amount 
FROM Payment
WHERE StudentID IN
(
		SELECT StudentID 
		FROM Student
		WHERE City = 'Edmonton'
)

-- list all the students (full names) who don't have any marks
	-- possible with a JOIN
	SELECT FirstName, LastName
	FROM Student
	LEFT OUTER JOIN Registration ON Student.StudentID = Registration.StudentID
	WHERE Mark IS NULL

	-- possible with a subquery
	SELECT FirstName, LastName
	FROM Student
	WHERE StudentID NOT IN (-- where student id doesn't exist in the marks table
		SELECT DISTINCT StudentID FROM Registration
	)

	-- how do I check this?
	SELECT COUNT(DISTINCT StudentID) FROM Student -- 17 students in total
	SELECT COUNT(DISTINCT StudentID) FROM Registration -- 8 students
	SELECT COUNT(DISTINCT Student.StudentID) FROM Student 
	INNER JOIN Registration ON Student.StudentID = Registration.StudentID -- 8 students
	-- 17 minus 8 = 9 students without marks

