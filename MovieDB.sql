Use MovieDB
Go

Drop Table If Exists MovieCharacter
Drop Table If Exists Agent
Go

Create Table Agent
(
	AgentID			int identity(1,1)	Not Null
										Constraint PK_Agent_AgentID
											Primary Key Clustered,
	AgentName		varchar(70)			Not Null,
	AgentFee		money				Not Null
)

Create Table MovieCharacter
(
	CharacterID		int identity(1,1)	Not Null
										Constraint PK_Character_CharacterID
											Primary Key Clustered,
	CharacterName	varchar(70)			Not Null,
	CharacterMovie	varchar(70)			Not Null,
	CharacterRating	char(1)				Null 
										Constraint DF_CharacterRating_3
											Default 3,
	Characterwage	smallmoney			Null,
	AgentID			int					Null
										Constraint FK_MovieCharacter_AgentID_To_Agent_AgentID
											References Agent(AgentID)
)
Go

Insert Into Agent
	(AgentName, AgentFee)
Values
	('Bob the agent', 50)
Insert Into Agent
	(AgentName, AgentFee)
Values
	('Good Acting For U', 125)
Insert Into Agent
	(AgentName, AgentFee)
Values
	('I represent anyone', 5)

Insert Into MovieCharacter	
	(CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
Values
	('ET', 'ET The Extraterrestrial', '4', 20000, 3)
Insert Into MovieCharacter
	(CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
Values
	('Luke Skywalker', 'Star Wars', '5', 12000, 2)
Insert Into MovieCharacter
	(CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
Values
	('R2D2', 'Star Wars', '4', 0, 1)
Insert Into MovieCharacter
	(CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
Values
	('Winnie The Pooh', 'Heffalump', '1', 20500, 2)
Insert Into MovieCharacter
	(CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
Values
	('Guy in red uniform', 'Star Trek II', '4', 27000, 1)
Go