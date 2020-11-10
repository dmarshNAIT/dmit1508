--SQL Flow Control and Variables Exercise
-- Author: Dana Marsh

--1.	create a variable called clubid and give it a value. 
	-- If the count of students in that club is greater than 2 print ‘A successful club!’ . 
	-- If the count is not greater than 2 print ‘Needs more members!’.

--2.	create a variable called studentID and give it a value. Each course has a cost. 
	-- If the total of the costs for the courses the student is registered in is more than the total of the payments that student has made then print ‘balance owing !’ 
	-- otherwise print ‘Paid in full! Welcome to School 158!’
	--Do Not use the BalanceOwing field in your solution. 
	-- HINT: Can we create some extra variables to help simplify the comparison? Maybe @TotalCost and @TotalPayments ?

--3.	create variables called firstname and lastname and give them a starting value. 
	-- If the student name already is in the table then print ‘We already have a student with the name firstname lastname!’ 
	-- Other wise print ‘Welcome firstname lastname!’

--4.	 create variable named staffid and give it a starting value. 
	-- If the number of classes the staff member has ever taught is between 0 and 10 print ‘Well done!’, 
	-- if it is between 11 and 20 print ‘Exceptional effort!’, 
	-- if the number is greater than 20 print ‘Totally Awesome, Dude!’

-- review at 3:25pm

DECLARE @myvariable VARCHAR(10)
SET @myvariable = 'hello'
PRINT @myvariable