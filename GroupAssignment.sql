-- create tables

CREATE TABLE Collectors
(
CollectorID INT IDENTITY (1,1) NOT NULL,
FirstName varchar(35),
LastName varchar(35),
CONSTRAINT pkGameCollectors PRIMARY KEY (CollectorID)
);

CREATE TABLE Developers
(
DeveloperID INT IDENTITY (1,1) NOT NULL,
DeveloperName varchar(35),
CONSTRAINT pkDevelopersID PRIMARY KEY (DeveloperID)
);

CREATE TABLE Publishers
(
PublisherID INT IDENTITY (1,1) NOT NULL,
PublisherName varchar(35),
CONSTRAINT pkDeveloperID PRIMARY KEY (PublisherID)
);

CREATE TABLE Genres
(
GenreID INT IDENTITY (1,1) NOT NULL,
GenreName varchar(35),
CONSTRAINT pkGenreID PRIMARY KEY (GenreID)
);

CREATE TABLE Consoles
(
ConsoleID INT IDENTITY (1,1) NOT NULL,
CollectorID INT NOT NULL,
EditionName varchar(35),
Manufacturer varchar(35),
CONSTRAINT pkConsole PRIMARY KEY (ConsoleID),
CONSTRAINT fkCollectorID FOREIGN KEY (CollectorID) REFERENCES Collectors (CollectorID)
);

CREATE TABLE ConsoleEditions
(
ConsoleID INT IDENTITY (1,1) NOT NULL,
EditionName varchar(35),
ConsolePrice money,
DateOfPurchase date,
CONSTRAINT fkConsoleEditionsID FOREIGN KEY (ConsoleID) REFERENCES Consoles (ConsoleID)
);

CREATE TABLE Games
(
GameID INT IDENTITY (1,1) NOT NULL,
ConsoleID INT NOT NULL,
GameName varchar(35),
GenreID INT NOT NULL,
DeveloperID INT NOT NULL,
PublisherID INT NOT NULL
CONSTRAINT pkGameID PRIMARY KEY (GameID),
CONSTRAINT fkConsoleGamesID FOREIGN KEY (ConsoleID) REFERENCES Consoles (ConsoleID),
CONSTRAINT fkGenreID FOREIGN KEY (GenreID) REFERENCES Genres (GenreID),
CONSTRAINT fkDeveloperID FOREIGN KEY (DeveloperID) REFERENCES Developers (DeveloperID),
CONSTRAINT PublisherID FOREIGN KEY (PublisherID) REFERENCES Publishers (PublisherID)
);

CREATE TABLE GameEditions
(
GameID INT NOT NULL,
EditionName varchar(35),
GamePrice money,
DateOfPurchase date,
Rating varchar(2),
CONSTRAINT checkRating CHECK (Rating IN ('E', 'T', 'M', 'A', 'RP')),
CONSTRAINT fkGameEditionID FOREIGN KEY (GameID) REFERENCES Games (GameID)
);

 

-- inserts

--PS4
--Collectors
SET IDENTITY_INSERT Collectors ON
INSERT INTO Collectors (CollectorID, FirstName, LastName) VALUES (1, 'Jacob', 'Gonzales')
SET IDENTITY_INSERT Collectors OFF

--Devolopers
SET IDENTITY_INSERT Developers ON
INSERT Developers (DeveloperID, DeveloperName) VALUES (1, 'Rockstar Games')
INSERT Developers (DeveloperID, DeveloperName) VALUES (2, 'Gearbox Software')
INSERT Developers (DeveloperID, DeveloperName) VALUES (3, 'Survios')
INSERT Developers (DeveloperID, DeveloperName) VALUES (4, 'Insomniac')
SET IDENTITY_INSERT Developers OFF

--Publishers
SET IDENTITY_INSERT Publishers ON
INSERT Publishers (PublisherID, PublisherName) VALUES (1, 'Rockstar Games')
INSERT Publishers (PublisherID, PublisherName) VALUES (2, '2K')
INSERT Publishers (PublisherID, PublisherName) VALUES (3, 'Survios')
INSERT Publishers (PublisherID, PublisherName) VALUES (4, 'SIEA')
SET IDENTITY_INSERT Publishers OFF

--Genres
SET IDENTITY_INSERT Genres ON
INSERT Genres (GenreID, GenreName) VALUES (1, 'Action')
INSERT Genres (GenreID, GenreName) VALUES (2, 'First Person Shooter')
SET IDENTITY_INSERT Genres OFF

--Console
SET IDENTITY_INSERT Consoles ON
INSERT Consoles (CollectorID, ConsoleID, EditionName, Manufacturer) VALUES (1, 1, 'PS4', 'Sony Interactive Ent.')
SET IDENTITY_INSERT Consoles OFF

--Console Editions
SET IDENTITY_INSERT ConsoleEditions ON
INSERT ConsoleEditions (ConsoleID, EditionName, ConsolePrice, DateOfPurchase) VALUES (1, 'Slim Playstation 4', 299.99, '2016/09/29')
SET IDENTITY_INSERT ConsoleEditions OFF

--Games
SET IDENTITY_INSERT Games ON
 INSERT Games (GameID, ConsoleID, GameName, GenreID, DeveloperID, PublisherID) VALUES (1, 1, 'L.A Noire: The VR Case Files', 1, 1, 1 )
 INSERT Games (GameID, ConsoleID, GameName, GenreID, DeveloperID, PublisherID) VALUES (2, 1, 'Borderlands 3', 2, 2, 2)
 INSERT Games (GameID, ConsoleID, GameName, GenreID, DeveloperID, PublisherID) VALUES (5, 1, 'Borderlands 3', 2, 2, 2)
 INSERT Games (GameID, ConsoleID, GameName, GenreID, DeveloperID, PublisherID) VALUES (3, 1, 'Battlewake', 1, 3, 3)
 INSERT Games (GameID, ConsoleID, GameName, GenreID, DeveloperID, PublisherID) VALUES (4, 1, 'Marvels Spiderman', 1, 4, 4)
 SET IDENTITY_INSERT Games OFF

 --GameEditions
INSERT GameEditions (GameID, EditionName, GamePrice, DateOfPurchase, Rating) VALUES (1, 'Standard', 29.99, '2017/12/15', 'M')
INSERT GameEditions (GameID, EditionName, GamePrice, DateOfPurchase, Rating) VALUES (2, 'Standard', 59.99, '2019/09/13', 'M')
INSERT GameEditions (GameID, EditionName, GamePrice, DateOfPurchase, Rating) VALUES (3, 'Standard', 29.99, '2019/09/10', 'E')
INSERT GameEditions (GameID, EditionName, GamePrice, DateOfPurchase, Rating) VALUES (4, 'Game of the Year', 39.99, '2018/09/07', 'T')

-- Queries

--	Write a query that generates a list of consoles
SELECT 
    C.EditionName
FROM
    Consoles AS C

--Write a query that returns all games in the collection
SELECT
    G.GameName
FROM
    Games AS G

--Write a query that returns all Xbox One games
SELECT
    G.GameName
FROM
    Consoles AS C
    INNER JOIN Games AS G ON C.ConsoleID = G.ConsoleID
WHERE
    C.EditionName LIKE '%Xbox One%'

--Write a query that returns all games that I have multiple copies of, including the platform they are on


SELECT
    G.GameName, C.EditionName
FROM
    Consoles AS C
    INNER JOIN Games AS G ON C.ConsoleID = G.ConsoleID
JOIN(
    SELECT
        G.GameName, C.EditionName, COUNT(*) AS Counted
    FROM
        Consoles AS C
        INNER JOIN Games AS G ON C.ConsoleID = G.ConsoleID
    GROUP BY
        G.GameName, C.EditionName
    HAVING
        COUNT(*) > 1
) q
ON 
    q.GameName = G.GameName
AND
    q.EditionName = C.EditionName


 --Write a query that returns all Role-playing games, including what platform they are on
SELECT
    C.EditionName, GA.GameName
FROM
    Games AS GA
    INNER JOIN Genres AS GE ON GA.GenreID = GE.GenreID
    INNER JOIN Consoles AS C ON GA.ConsoleID = C.ConsoleID
WHERE
    GE.GenreName LIKE '%Role-playing%'

--drop tables 
/*
drop table GameEditions
drop table Games
drop table ConsoleEditions
drop table Consoles
drop table Genres
drop table Publishers
drop table Developers
drop table Collectors
*/