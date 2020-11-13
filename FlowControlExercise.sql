--SQL Flow Control and Variables Exercise
-- Author: Dana Marsh
USE [IQ-School]

--1.	create a variable called clubid and give it a value. 
	-- If the count of students in that club is greater than 2 print ‘A successful club!’ . 
	-- If the count is not greater than 2 print ‘Needs more members!’.

	-- create variable @clubid
	DECLARE @ClubID VARCHAR(10)
	-- assign it
	SET @ClubID = 'CSS'
		-- want to test with one club >2, and one one with 2 or less
		-- CIPS has 0, CHESS has 1, CSS has 5
	-- get the count of students
	DECLARE @Count INT
	SELECT @Count = COUNT(*)
		FROM Activity
		WHERE ClubID = @ClubID

	IF @Count > 2
		BEGIN
		PRINT 'A successful club!'
		END
	ELSE
		BEGIN
		PRINT 'Needs more members!'
		END

--2.	create a variable called studentID and give it a value. Each course has a cost. 
	-- If the total of the costs for the courses the student is registered in is more than the total of the payments that student has made then print ‘balance owing !’ 
	-- otherwise print ‘Paid in full! Welcome to School 158!’
	--Do Not use the BalanceOwing field in your solution. 
	-- HINT: Can we create some extra variables to help simplify the comparison? Maybe @TotalCost and @TotalPayments ?

	-- declare variable called @StudentID
	DECLARE @StudentID INT
	-- assign it a value (what test cases do we want to use??)
	SET @StudentID = 200978500
		-- need to find one with outstanding payments, and one without.
		-- 199899200 paid in full
		-- 200978500 hasn't paid
		-- how did I find that??
			--SELECT DISTINCT STudentID 
			--FROM Registration -- 8
			--WHERE StudentID NOT IN (
			--	SELECT DISTINCT STudentID FROM Payment -- 7 
			--)
	-- declare variable called @TotalCost
	DECLARE @TotalCost DECIMAL(7,2)
	-- assign it the total cost of the courses for that student
	SELECT @TotalCost = SUM(CourseCost)
	FROM Course
	INNER JOIN Offering ON Course.CourseID = Offering.CourseID
	INNER JOIN Registration AS Reg ON Offering.OfferingCode = Reg.OfferingCode
	-- or we could have started at Registration and JOINed to Offering then to Course: same end result
	WHERE StudentID = @StudentID
	-- declare variable called @TotalPayments
	DECLARE @TotalPayments DECIMAL(7,2)
	-- assign it the total of the payments that student has made
	SELECT @TotalPayments = SUM(Amount)
	FROM Payment
	WHERE StudentID = @StudentID

	IF @TotalCost > @TotalPayments
		BEGIN
		PRINT 'balance owing !'
		END
	ELSE
		BEGIN
		PRINT 'Paid in full! Welcome to School 158!'
		END

	-- adding test data so we can test:
	--INSERT INTO Payment (PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
	--VALUES (34, GETDATE(), 1, 1, 200978500)

--3.	create variables called firstname and lastname and give them a starting value. 
	-- If the student name already is in the table then print ‘We already have a student with the name firstname lastname!’ 
	-- Other wise print ‘Welcome firstname lastname!’

	-- declare @firstname and @lastname
	-- assign @firstname and @lastname some starting values (test: one that exists, one that doesn't)
	-- IF EXISTS (in Student table)
		-- print ‘We already have a student with the name firstname lastname!’ 
	-- otherwise
		-- print ‘Welcome firstname lastname!’

--4.	 create variable named staffid and give it a starting value. 
	-- If the number of classes the staff member has ever taught is between 0 and 10 print ‘Well done!’, 
	-- if it is between 11 and 20 print ‘Exceptional effort!’, 
	-- if the number is greater than 20 print ‘Totally Awesome, Dude!’

	-- declare @StaffID
	-- give it a starting value

	-- declare a variable called @NumberOfClasses
	-- assign it the number of classes that staff member has taught

	-- IF @NumberOfClasses is between 0 and 10
		-- print ‘Well done!’
	-- otherwise
		-- if @NumberOfClasses is between 11 and 20
			-- print ‘Exceptional effort!’
		-- otherwise
			-- print ‘Totally Awesome, Dude!’
		




-- will finish next day