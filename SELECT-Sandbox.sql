SELECT FirstName, LastName, City
FROM Student

SELECT FirstName + ' ' + LastName AS StudentName
, StudentName = FirstName + ' ' + LastName
, FirstName + ' ' + LastName AS [Student Name]
, FirstName + ' ' + LastName AS 'Student Name'
FROM Student