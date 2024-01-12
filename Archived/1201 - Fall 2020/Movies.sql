USE Movies


CREATE TABLE Agent (AgentID INT identity(1, 1) NOT NULL CONSTRAINT pk_Agent PRIMARY KEY CLUSTERED, AgentName VARCHAR(70) NOT NULL, AgentFee MONEY NOT NULL)

CREATE TABLE MovieCharacter (CharacterID INT identity(1, 1) NOT NULL CONSTRAINT pk_Character PRIMARY KEY CLUSTERED, CharacterName VARCHAR(70) NOT NULL, CharacterMovie VARCHAR(70) NOT NULL, CharacterRating CHAR(1) NULL CONSTRAINT DF_characterRating DEFAULT 3, Characterwage SMALLMONEY NULL, AgentID INT NULL CONSTRAINT fk_MovieCharacterToAgent REFERENCES Agent(AgentID))

INSERT INTO Agent (AgentName, AgentFee)
VALUES ('Bob the agent', 50)

INSERT INTO Agent (AgentName, AgentFee)
VALUES ('Good Acting For U', 125)

INSERT INTO Agent (AgentName, AgentFee)
VALUES ('I represent anyone', 5)

INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
VALUES ('ET', 'ET The Extraterrestrial', '4', 20000, 3)

INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
VALUES ('Luke Skywalker', 'Star Wars', '5', 12000, 2)

INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
VALUES ('R2D2', 'Star Wars', '4', 0, 1)

INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
VALUES ('Winnie The Pooh', 'Heffalump', '1', 20000, 2)

INSERT INTO MovieCharacter (CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
VALUES ('Guy in red uniform', 'Star Trek II', '4', 20000, 1)

SELECT * FROM Agent
SELECT * FROM MovieCharacter