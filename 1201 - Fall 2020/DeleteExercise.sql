SELECT * FROM Staff
SELECT * FROM StaffType

--1.	Delete the Staff with StaffID 8

DELETE FROM Staff
WHERE StaffID = 8 -- 0 rows affected: no error

--2.	Delete StaffTypeId 1
DELETE FROM StaffType
WHERE StaffTypeId = 1 -- FAILS because it has child records

--3.	Delete all the staff whose wage is less than $21.66
DELETE FROM Staff
WHERE Wage < 21.66

--4.	Try and Delete StaffTypeID 1 again. Why did it work this time?
DELETE FROM StaffType
WHERE StaffTypeId = 1 -- now it works, because no more children records.

--5.	Delete ItemID 5
DELETE FROM Item
WHERE ItemID = 5

SELECT * FROM Item