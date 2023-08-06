CREATE DATABASE Cinema
USE Cinema

CREATE TABLE Halls (
	Id int PRIMARY KEY IDENTITY,
	[Name] nvarchar(30) UNIQUE NOT NULL,
	Capacity int NOT NULL
)

CREATE TABLE Languages (
	Id int PRIMARY KEY IDENTITY,
	[Name] nvarchar(10) UNIQUE NOT NULL
)

CREATE TABLE Movies (
	Id int PRIMARY KEY IDENTITY,
	Title nvarchar(100) NOT NULL,
	DurationInMins int NOT NULL
)

CREATE TABLE [Sessions] (
	Id int PRIMARY KEY IDENTITY,
	MovieId int FOREIGN KEY REFERENCES Movies(Id) NOT NULL,
	DubLanguageId int FOREIGN KEY REFERENCES Languages(Id),
	SubLanguageId int FOREIGN KEY REFERENCES Languages(Id),
	StartTime smalldatetime NOT NULL,
	HallId int FOREIGN KEY REFERENCES Halls(Id)
)

INSERT INTO Halls VALUES ('Hall 1', 150), ('Hall 2', 200), ('Hall 3', 250)
INSERT INTO Languages VALUES ('EN'), ('RU'), ('TR'), ('AZ')
INSERT INTO Movies VALUES ('Barbie', 114), ('Oppenheimer', 180)
INSERT INTO [Sessions] VALUES
	(1, 1, NULL, '2023-08-07 18:30:00', 1),
	(2, 1, 2, '2023-08-07 19:40:00', 2),
	(1, 2, 4, '2023-08-07 20:30:00', 1),
	(2, 1, 3, '2023-08-08 14:20:00', 3),
	(2, 3, 4, '2023-08-08 15:00:00', 2),
	(1, 3, NULL, '2023-08-08 16:00:00', 1),
	(1, 2, 3, '2023-08-09 21:10:00', 2),
	(2, 2, NULL, '2023-08-06 17:50:00', 1),
	(2, 1, 4, '2023-08-06 17:20:00', 3)

CREATE VIEW Tickets AS
SELECT M.Title 'Movie', Dub.[Name] 'Language', Sub.[Name] 'Subtitles', StartTime,
	DATEADD(minute, DurationInMins, StartTime) 'EndTime', Halls.[Name] 'Hall', Capacity 'TicketCount'
FROM [Sessions] S JOIN
Movies M ON MovieId = M.Id JOIN
Halls ON HallId = Halls.Id JOIN
Languages Dub ON S.DubLanguageId = Dub.Id LEFT
JOIN Languages Sub ON S.SubLanguageId = Sub.Id

SELECT * FROM Tickets