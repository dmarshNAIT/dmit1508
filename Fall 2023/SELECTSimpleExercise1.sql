--SIMPLE SELECT EXERCISE 1
--USE THE IQSCHOOL DATABASE 
USE IQSchool
GO

--1.	Select all the information from the club table

--2.	Select the FirstNames and LastNames of all the students

--3.	Select all the CourseId and CourseName of all the coureses. Use the column aliases of Course ID and Course Name

--4.	Select all the course information for courseID 'DMIT1001'

--5.	Select the Staff names who have positionID of 3

--6.	select the CourseNames whose CourseHours are less than 96

--7.	Select the studentIDs, OfferingCode and mark where the Mark is between 70 and 80
SELECT StudentID, OfferingCode, Mark
FROM Registration
WHERE Mark BETWEEN 70 AND 80

SELECT StudentID, OfferingCode, Mark
FROM Registration
WHERE Mark >= 70 AND Mark <= 80

--8.	Select the studentID's, Offering Code and mark where the Mark is between 70 and 80 and the OfferingCode is 1001 or 1009

--9.	Select the students first and last names who have last names starting with S

--10.	Select Coursenames whose CourseID  have a 1 as the fifth character

--11.	Select the CourseIDs and Coursenames where the CourseName contains the word 'programming'
SELECT CourseID, CourseName
FROM Course
WHERE CourseName LIKE '%programming%'

--12.	Select all the ClubNames who start with N or C.

--13.	Select Student Names, Street Address and City where the LastName is only 3 letters long.
SELECT FirstName + ' ' + LastName AS StudentName
,	StreetAddress
,	City
FROM Student
WHERE LastName LIKE '___'

--14.	Select all the StudentID's where the PaymentAmount < 500 OR the PaymentTypeID is 5

