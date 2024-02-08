USE IQSchool
GO

SELECT FirstName + ' ' + LastName AS FullName
	, FullName = FirstName + ' ' + LastName
	-- 2 different ways to create aliases
	, City
FROM Student

SELECT PaymentDate 
	, Amount
	, Amount * 0.05 AS GST
	-- the AS keyword lets us name this derived column
FROM Payment

-- a dangerous shorcut
SELECT *
FROM Student

-- what if I don't want all the students?
SELECT FirstName, LastName, City
FROM Student
WHERE City = 'Edmonton'

-- students with a Q or Z in their postal code
SELECT FirstName, LastName, PostalCode
FROM Student
WHERE PostalCode LIKE '%Q%' OR PostalCode LIKE '%Z%'
-- or
SELECT FirstName, LastName, PostalCode
FROM Student
WHERE PostalCode LIKE '%[QZ]%'