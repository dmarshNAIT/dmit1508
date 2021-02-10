--1.	Add a MeetingLocation varchar(50) field to the Club table

ALTER TABLE Club
	ADD 

--2.	Add a constraint to birthdate to ensure the value is < todays date
--3.	Add a constraint to set a default of 80 to the Hours field
--4.	Oops, changed our minds…. DISABLE the check constraint for the birthdate field
--5.	Yikes! Change our minds again. ENABLE the check constraint for the Birthdate field
--6.	Hold on! Call me crazy…. Delete the default constraint for the Hours field now!
