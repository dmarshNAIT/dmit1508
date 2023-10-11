-- Oct 11
SELECT FirstName
, LastName
, FirstName + ' ' + LastName AS [Full Name]
, FullName = FirstName + ' ' + LastName
FROM Student

SELECT *
FROM Student
-- a handy shortcut, but not something we will have in final version!

-- all students who owe money:
SELECT FirstName, LastName, BalanceOwing
FROM Student
WHERE BalanceOwing > 0

-- all students with an 'a' in their first name
SELECT FirstName + ' '  + LastName AS FullName
FROM Student
WHERE FirstName LIKE '%a%'
