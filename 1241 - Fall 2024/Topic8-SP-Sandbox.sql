USE IQSchool
GO

-- create a procedure called LookupStudent
-- that takes StudentID as an input (AKA a parameter)

-- it will SELECT the full name, city, and birthday of that student

CREATE PROCEDURE LookupStudent (@StudentID INT = NULL) 
AS

-- if parameters are missing, I must raise an error
IF @StudentID IS NULL
	BEGIN
	RAISERROR('StudentID is a required parameter.', 16, 1)
	END

-- otherwise, I will SELECT the student info
ELSE
	BEGIN
	SELECT FirstName + ' ' + LastName AS FullName, City, Birthdate
	FROM Student
	WHERE Student.StudentID = @StudentID
	END

RETURN -- this marks the END of the stored procedure

-- it's time to test
-- try to run it without any parameters
EXEC LookupStudent
-- try to run it with a good parameter

-- try to run it with a bad parameter