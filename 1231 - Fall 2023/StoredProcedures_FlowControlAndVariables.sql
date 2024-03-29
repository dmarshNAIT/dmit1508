--SQL Flow Control and Variables Exercise
--Use IQSchool database
USE IQSchool
GO

--1.	Create a stored procedure called StudentClubCount. It will accept a clubID as a parameter. If the count of students in that club is greater than 2 print �A successful club!�. If the count is not greater than 2 print �Needs more members!�.
DROP PROCEDURE IF EXISTS StudentClubCount
GO

CREATE PROCEDURE StudentClubCount ( @ClubID VARCHAR(10) = NULL )
AS

IF @ClubID IS NULL -- if no param was provided
	BEGIN 
	PRINT 'Club ID is a required parameter.'
	END
ELSE -- if we are provided a param:
	BEGIN
	-- create another variable called @StudentCount & assign it a value from the data in the DB
	DECLARE @StudentCount INT
	SELECT @StudentCount = COUNT(*)
		FROM Activity
		WHERE ClubID = @ClubID

	-- If the count of students in that club is greater than 2 print �A successful club!�. If the count is not greater than 2 print �Needs more members!�.
	IF @StudentCount > 2
		BEGIN
			PRINT 'A successful club!'
		END
	ELSE
		BEGIN
			PRINT 'Needs more members'
		END
	END

RETURN -- this marks the end of my SP definition

GO -- this marks the end of the batch (each CREATE PROCEDURE must be alone in its batch)

-- testing for ACM (3 members): successful club! Test has passed.
EXEC StudentClubCount 'ACM'
-- testing for CHESS (1 lonely member)
EXEC StudentClubCount 'CHESS'
-- test with no params:
EXEC StudentClubCount
-- test with a nonsense club
EXEC StudentClubCount 'I hate Databases' -- this club doesn't exist; a bonus challenge we could do is add another branch to print a message that tells the user that.

--2.	Create a stored procedure called BalanceOrNoBalance. It will accept a studentID as a parameter. Each course has a cost. If the total of the costs for the courses the student is registered in is more than the total of the payments that student has made, then print �balance owing!� otherwise print �Paid in full! Welcome to IQ School!�
--Do Not use the BalanceOwing field in your solution. 

DROP PROCEDURE IF EXISTS BalanceOrNoBalance
GO


CREATE PROCEDURE BalanceOrNoBalance(@StudentID INT = NULL)
AS

IF @StudentID IS NULL
	BEGIN
	RAISERROR('StudentID is a required parameter.', 16, 1)
	END
ELSE -- start of outer ELSE
	BEGIN
	-- create a variable called @TotalCourseCost
	DECLARE @TotalCourseCost DECIMAL(8,2)

	-- create a variable called @TotalPayments
	DECLARE @TotalPayments DECIMAL(8,2)

	-- assign each variable a value using data from our DB
	SELECT @TotalCourseCost = SUM(CourseCost)
	FROM Registration
	INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode
	INNER JOIN Course ON Course.CourseId = Offering.CourseId
	WHERE StudentID = @StudentID

	SELECT @TotalPayments = SUM(Amount) 
	FROM Payment 
	WHERE StudentID = @StudentID

	-- If the total of the costs for the courses the student is registered in is more than the total of the payments that student has made, then print �balance owing!� otherwise print �Paid in full! Welcome to IQ School!�
	IF @TotalCourseCost > @TotalPayments
		BEGIN
		PRINT 'Balance Owing'
		END
	ELSE
		BEGIN
		PRINT 'Paid in full: Welcome to IQ School!'
		END
	END -- this ends the outer ELSE block

RETURN
GO


--3.	Create a stored procedure called �DoubleOrNothin�. It will accept a student�s first name and last name as parameters. If the student�s name already is in the table, then print �We already have a student with the name firstname lastname!� Otherwise print �Welcome firstname lastname!�

DROP PROCEDURE IF EXISTS DoubleOrNothin
GO

CREATE PROCEDURE DoubleOrNothin (
	@FirstName VARCHAR(25) = NULL
,	@LastName VARCHAR(25) = NULL
)
AS

IF @FirstName IS NULL OR @LastName IS NULL
	BEGIN
	RAISERROR('First and last names are required params', 16, 1)
	END

-- If the student�s name already is in the table, then print �We already have a student with the name firstname lastname!� Otherwise print �Welcome firstname lastname!�
ELSE IF EXISTS(SELECT * FROM Student WHERE FirstName = @FirstName AND LastName = @LastName)
	BEGIN
	PRINT 'We already have a student with the name ' + @FirstName + ' ' + @LastName
	END

ELSE
	BEGIN
	PRINT 'Welcome, ' + @FirstName + ' ' + @LastName
	END

RETURN
GO

--4.	Create a procedure called �StaffRewards�. It will accept a staff ID as a parameter. If the number of classes the staff member has ever taught is between 0 and 10 print �Well done!�, if it is between 11 and 20 print �Exceptional effort!�, if the number is greater than 20 print �Totally Awesome Dude!�

DROP PROCEDURE IF EXISTS StaffRewards
GO

CREATE PROCEDURE StaffRewards (@StaffID INT = NULL)
AS

IF @StaffID IS NULL
	BEGIN
	RAISERROR('Staff ID is a required param', 16, 1)
	END
ELSE
	BEGIN -- starts my outer ELSE block

	-- create a variable called @NumberOfCourses and assign it a value using data in our DB
	DECLARE @NumberOfCourses INT
	SELECT @NumberOfCourses = COUNT(*) FROM Offering WHERE Offering.StaffID = @StaffID
	-- This would also work if we just had "StaffID" instead of "Offering.StaffID"

	-- if that value is 2 or less: print 'Well done'
	IF @NumberOfCourses <= 2 -- or: @NumberOfCourses BETWEEN 0 AND 2
		BEGIN
		PRINT 'Well done'
		END

	-- if it's between 3 and 5: print 'Exceptional Effort'
	ELSE IF @NumberOfCourses BETWEEN 3 AND 5
		BEGIN
		PRINT 'Exceptional Effort'
		END

	-- if it's more than 5: print 'Totally Awesome, Dude.'
	ELSE --IF @NumberOfCourses > 5
		BEGIN
		PRINT 'Totally awesome, dude'
		END
	
	END -- ends my outer ELSE block


RETURN
GO

-- staff ID #1 has taught 0 courses
-- staff ID 6 has taught 3
-- staff ID 4 has taught >5
