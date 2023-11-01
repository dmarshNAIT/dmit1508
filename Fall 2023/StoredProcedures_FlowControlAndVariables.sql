--SQL Flow Control and Variables Exercise
--Use IQSchool database

--1.	Create a stored procedure called StudentClubCount. It will accept a clubID as a parameter. If the count of students in that club is greater than 2 print ‘A successful club!’. If the count is not greater than 2 print ‘Needs more members!’.

-- create a variable called @ClubID
-- assign it a value using data in our DB
-- If the count of students in that club is greater than 2 print ‘A successful club!’. If the count is not greater than 2 print ‘Needs more members!’.





--2.	Create a stored procedure called BalanceOrNoBalance. It will accept a studentID as a parameter. Each course has a cost. If the total of the costs for the courses the student is registered in is more than the total of the payments that student has made, then print ‘balance owing!’ otherwise print ‘Paid in full! Welcome to IQ School!’
--Do Not use the BalanceOwing field in your solution. 

--3.	Create a stored procedure called ‘DoubleOrNothin’. It will accept a student’s first name and last name as parameters. If the student’s name already is in the table, then print ‘We already have a student with the name firstname lastname!’ Otherwise print ‘Welcome firstname lastname!’

--4.	Create a procedure called ‘StaffRewards’. It will accept a staff ID as a parameter. If the number of classes the staff member has ever taught is between 0 and 10 print ‘Well done!’, if it is between 11 and 20 print ‘Exceptional effort!’, if the number is greater than 20 print ‘Totally Awesome Dude!’

