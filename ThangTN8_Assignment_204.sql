-- BSQL Assignment 204
-- Problem Description: Building a Movie Collection database to store information about movies.

USE master
GO

-- Check if Database exists
IF	EXISTS(
	SELECT * 
		FROM sys.databases 
		WHERE name = N'BSQL_Assignment_204'
)
DROP DATABASE BSQL_Assignment_204
GO

-- Create Database
CREATE DATABASE BSQL_Assignment_204
GO

USE BSQL_Assignment_204
GO

-- Create schema
CREATE SCHEMA BSQL
GO 

-- Q1: Create your tables

-- 1:Create a table called Movie to store information about movies. Add columns in your table for a movie name, duration, genre, director, amount of money made at the box office and comments.
--		Make sure one of your columns works as a PRIMARY KEY.
--		Genre: accepts value range from 1 to 8 only (1: Action, 2: Adventure, 3: Comedy, 4: Crime (gangster), 5: Dramas, 6: Horror, 7: Musical/dance, 8: War)
--		Duration: must be greater than or equal 1 hours

CREATE TABLE Movie(
	MovieID			INT			IDENTITY(1,1)	PRIMARY KEY,
	MovieName		Varchar(50) NOT NULL,
	Duration		TIME		NOT NULL		CHECK(DATEPART(HOUR,Duration) >= 1) ,
	Genre			INT			NOT NULL		CHECK(Genre BETWEEN 1 AND 8),
	Director		VARCHAR(30) NOT NULL,
	[Money]			MONEY NOT NULL,
	Comments		VARCHAR(255)
);
GO

-- 2: Create another table called Actor to store information about actors. Just like you did with Movie, add several columns to store actor data for the actor's name, age, 
-- average movie salary, and Nationality. Again, make sure there is a PRIMARY KEY in your table.

CREATE TABLE Actor(
	ActorID			INT			IDENTITY(1,1)	PRIMARY KEY,
	ActorName		VARCHAR(50) NOT NULL,
	Age				INT			NOT NULL,
	AvgSalary		MONEY		NOT NULL,
	Nationality		VARCHAR(30)	NOT NULL
);
GO

-- 3: Create a final table called ActedIn to store information about which movies certain actors have acted in. Think carefully about what the columns of this table should be. 
-- This table should make use of FOREIGN KEYS.

CREATE TABLE Actedln (
	ActorID			INT			NOT NULL	FOREIGN KEY REFERENCES Actor(ActorID),
	MovieID			INT			NOT NULL	FOREIGN KEY REFERENCES Movie(MovieID),
	PRIMARY KEY(ActorID,MovieID)
);
GO

-- Q2. Populate tables

-- 1: Add an ImageLink field to Movie table and make sure that the database will not allow the value for ImageLink to be inserted into a new row if that value has already been used in another row.

ALTER TABLE Movie
ADD ImageLink VARCHAR(50) UNIQUE NOT NULL;
GO

-- 2: Populate your tables with some data using the INSERT statement. Make sure you have at least 5 tuples per table.

INSERT INTO Movie
VALUES 
	('Titanic','03:14:00',2,'James Cameron',2186772302,'Good Film','Titanic.img'),
	('The Godfather (1972)','02:55:00',4,'Francis Ford Coppola',286000000,'Good and meaningful movie','Godfather.img'),
	('The Wolf of Wall Street','03:00:00',3,'Martin Scorsese',392000000,'Best Film','The_Wolf_of_Wall_Street.img'),
	('Bohemian Rhapsody','02:14:00',7,'Bryan Singer, Dexter Fletcher',903700000,'Meaningful movie','Bohemian_Rhapsody.img'),
	('Infinity War','02:29:00',1,'Anthony Russo, Joe Russo',2048000000,'Good Film','Avengers.img')
;
GO

INSERT INTO Actor 
VALUES
	('Leonardo DiCaprio',47,100000,'USA'),
	('Robert Downey Jr',56,150000,'USA'),
	('Chris Evans',40,30000,'Canada'),
	('Al Pacino',81,200000,'UK'),
	('Rami Malek',39,12000,'Arab Saudi'),
	('Chris Hemsworth',38,36000,'Australia '),
	('Scarlett Johansson',37,32000,'Israel');
GO

INSERT INTO Actedln 
VALUES	(1,1),
		(1,3),
		(2,5),
		(3,5),
		(4,2),
		(5,4),
		(6,5),
		(7,5);
GO

-- You accidentally mistyped one of the actors' names. Fix your typo by using an UPDATE statement.
UPDATE	Actor
SET     ActorName = 'Rami Malek Junior'
WHERE	(ActorName = 'Rami Malek');
GO

-- Q3. Query tables

-- 1: Write a query to retrieve all the data in the Actor table for actors that are older than 50.

SELECT		ActorID, ActorName, Age, AvgSalary, Nationality
FROM		Actor
WHERE		(Age > 50)
GO

-- 2: Write a query to retrieve all actor names and average salaries from ACTOR and sort the results by average salary.

SELECT		ActorName, AvgSalary
FROM		Actor
ORDER BY	AvgSalary
GO

-- 3: Using an actor name from your table, write a query to retrieve the names of all the movies that the actor has acted in.

SELECT 'Leonardo DiCaprio' AS Actor, MovieName
FROM     Movie
WHERE  (MovieID IN
                      (SELECT MovieID
                       FROM      Actedln
                       WHERE   (ActorID IN
                                             (SELECT ActorID
                                              FROM      Actor AS a
                                              WHERE   (ActorName = 'Leonardo DiCaprio')))));
GO

-- 4: Write a query to retrieve the names of all the action movies that amount of actor be greater than 3

SELECT MovieName 
FROM Movie 
WHERE Genre = 1 
AND  MovieID IN	(SELECT MovieID
				FROM Actedln 
				GROUP BY MovieID
				HAVING COUNT(ActorID) > 3)
GO








