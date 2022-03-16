/* 

This is meant to simulate Quiz 2 in its format and complexity.

A sample answer key is available in the GitHub repo.

The actual Quiz will be consist of:
- adding constraints to a CREATE TABLE statement*
- creating indexes*
- writing ALTER TABLE statements*
- writing SELECT statements**
- writing DML (insert, update, delete) statements**
- creating and using views**

* as per Lab 2A
** as per Lab 2B

There will be 12 questions in total, you are given the full class time, and are welcome to reference your own notes and class examples.

Last updated: Mar 16, 2022

*/
USE IQSchool
GO

--1a. Select the firstname, lastname, and paymentdates for studentid 199899200

--1b. Select the Student full name, courseIDs and marks for studentID 199899200.

--2a. Which Positions have more than 1 staff in them?

--2b. Which clubs have 3 or more students in them? Display the Club Names.


--3a. Select the staff fullnames, their hiredate, and the month NAME they were hired. List them in chronological order by month


--4. How many students firstnames start with each letter? Show the letter and the count.


--5a. Select the student names that have no payments.

--5b. Select all the staff names that have not taught a course.


--6. Create a View called StudentPayments that contains studentID, firstname, lastname, paymentdate, and amount.


--7. Using the StudentPayments view Select the CustomerID , firstname,lastname, and average payment amount.


--8. Add $10 to the balance owing for all students who have at least one mark <50


--9. Add a new course which has a coursecost which is the average coursecost of the other courses.


--10. Delete all the staff that are not teaching anything

-- 11 - Oops, we forgot something. Assuming the table already contains data, add a new column to the Student table called Major. This will contain the subject each student is studying, if they have selected one.

-- 12. Create indexes for each FK in the database.

-- 13. Modify the CREATE TABLE statements for IQ School to add the following constraints:
-- a) the PositionDescription must be at least 4 characters long.
-- b) the default value for PositionID on a new Staff is 4.
-- c) The ClubName cannot contain any numbers.
-- d) The default ClubName is 'Unknown'.

