--SQL Flow Control and Variables(including exists)Exercise
--Use IQ School tables
USE IQSchool
GO


-- 1. If the count of students in a club is greater than 2 print ‘A successful club!’ . If the count is not greater than 2 print ‘Needs more members!’.

-- create a variable called @studentCount
-- check its value, then print the appropriate message

--2. Each course has a cost. If the total of the costs for the courses a given student is registered in is more than the total of the payments that student has made then print ‘balance owing !’ otherwise print ‘Paid in full! Welcome to School 158!’
--Do Not use the BalanceOwing field in your solution. 

-- create a variable to hold the @StudentID
-- create a variable called @TotalCourseCost, and assign it a value for a specific student
-- create a variable called @TotalPayments, and assign it a value for a specific student
-- compare variables, and print the appropriate message

--3. Create variables for student @firstName and student @lastName. If that student name already is in the table then print ‘We already have a student with the name firstname lastname!’ Otherwise print ‘Welcome firstname lastname!’

-- create variables for the first and last name
-- check if that student EXISTS already, and print the appropriate message


--4. Create a variable to hold a @staffID. If the number of classes the staff member has ever taught is between 0 and 2 print ‘Well done!’, if it is between 3 and 5 print ‘Exceptional effort!’, if the number is greater than 5 print ‘Totally Awesome Dude!’

-- IF statement INSIDE another IF statement








