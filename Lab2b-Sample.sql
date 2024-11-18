--d.	Select contractnumber, date, full address (one column), subtotal, GST, total, staff name (one column), client name (one column) and Client phone number for contract number 2. (3 marks)

SELECT ContractNumber
	, Date
	, Address  + ' ' + City  + ' ' + Province  + ' ' + PostalCode
	, Subtotal
	, GST
	, Total
	, Staff.FirstName + ' ' + Staff.LastName
	, Client.FirstName + Client.LastName
	, Client.Phone
FROM Client
INNER JOIN Contract ON Client.ClientID = Contract.ClientID
INNER JOIN Staff ON Staff.StaffID = Contract.StaffID
WHERE ContractNumber = 2

Client 
LEFT JOIN Contract

Staff 
LEFT JOIN Contract

--g.	Select the task code and description of the tasks that have never been used on a contract.(2 marks)
SELECT TaskCode, Description
FROM Task
WHERE TaskCode NOT IN (SELECT TaskCode FROM ContractTask)

SELECT Task.TaskCode, Description
FROM Task
LEFT JOIN ContractTask ON Task.TaskCode = ContractTask.TaskCode
WHERE ContractTask.TaskCode IS NULL

SELECT Task.TaskCode, Description
FROM Task
LEFT JOIN ContractTask ON Task.TaskCode = ContractTask.TaskCode
GROUP BY Task.TaskCode, Description
HAVING COUNT(ContractTask.TaskCode) < 1

--h.	How many times has each award been awarded? Show the Award Description and the count. (3 marks)
SELECT Award.Description, COUNT(StaffAward.AwardCode)
FROM Award
LEFT JOIN StaffAward ON Award.AwardCode = StaffAward.AwardCode
GROUP BY Award.Description, Award.AwardCode

--c.	Select the supply code and description for all the supplies that have been used on more than 2 contracts.(4 marks)
SELECT 
	Supply.SupplyCode
	, Supply.Description
FROM Supply
INNER JOIN ContractSupply ON Supply.SupplyCode = ContractSupply.SupplyCode
GROUP BY 	Supply.SupplyCode
	, Supply.Description
HAVING COUNT(DISTINCT ContractNumber) > 2

-- INSERTing
INSERT INTO Task  (Description, CostPerHour)
VALUES ('Laundry', 20)
	, ('Couch Cleaning', (SELECT MAX(CostPerHour) FROM Task))

	SELECT * FROM Task

-- UPDATE
		--2.	Increase the CostPerHour of all the tasks that have the word Cleaning in their description by 10%. (2 marks)

SELECT *
FROM Task
WHERE Description LIKE '%Cleaning%'

-- window cleaning was $30 --> $33

UPDATE Task
SET CostPerHour = CostPerHour + .10 * CostPerHour
	--CostPerHour = 1.1 * CostPerHour
WHERE Description LIKE '%Cleaning%'

SELECT * FROM Supply

SELECT * FROM ContractSupply

DELETE 
FROM Supply 
WHERE SupplyCode NOT IN (SELECT SupplyCode FROM ContractSupply)

DELETE Supply
FROM Supply 
LEFT JOIN ContractSupply ON Supply.SupplyCode = ContractSupply.SupplyCode
WHERE ContractSupply.SupplyCode IS NULL

INSERT INTO SUpply VALUES ('Coffee')

SELECT DISTINCT TaskCode FROM ContractTask