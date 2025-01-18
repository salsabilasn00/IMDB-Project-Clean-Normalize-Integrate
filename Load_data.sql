DROP DATABASE IF EXISTS TVSHOWS
CREATE DATABASE TVSHOWS
USE TVSHOWS

-- CREATE TABLE 
--1) TITLE_BASICS
DROP TABLE IF EXISTS TITLE_BASICS
CREATE TABLE TITLE_BASICS(
	Tconst NVARCHAR(255) PRIMARY KEY,
	titleType NVARCHAR(255),
	primaryTitle NTEXT,
	originalTitle NTEXT,
	isAdult INT,
	startYear NVARCHAR(30) NULL,
	endYear NVARCHAR(30) NULL,
	runtimeMinutes NVARCHAR(30),
	Genres NVARCHAR(255) NULL,
);


-- 2) NAME_BASICS
DROP TABLE IF EXISTS NAME_BASICS
CREATE TABLE NAME_BASICS(
	Nconst NVARCHAR(255) PRIMARY KEY,
	primaryName NTEXT,
	birthYear NVARCHAR(MAX) NULL,
	deathYear NVARCHAR(MAX) NULL,
	primaryProfession NVARCHAR(MAX) NULL,
	knownForTitles  NVARCHAR(255),
	FOREIGN KEY (knownForTitles) REFERENCES TITLE_BASICS(Tconst)
);


-- 3) PRINCIPALS
DROP TABLE IF EXISTS TITLE_PRINCIPALS
CREATE TABLE TITLE_PRINCIPALS(
	Tconst NVARCHAR(255),
	Ordering VARCHAR(255),
	Nconst NVARCHAR(255),
	Category NVARCHAR(255) NULL,
	Job NVARCHAR(MAX) NULL,
	Characters NVARCHAR(MAX) NULL,
	PRIMARY KEY (Tconst, Ordering),
	FOREIGN KEY (Tconst) REFERENCES TITLE_BASICS(Tconst),
	FOREIGN KEY (Nconst) REFERENCES NAME_BASICS(Nconst)
);


-- 4) TITLE AKAS
DROP TABLE IF EXISTS TITLE_AKAS
CREATE TABLE TITLE_AKAS (
	TitleId NVARCHAR(255) ,
	Ordering int,
	Title VARCHAR (MAX),
	Region VARCHAR (50),
	Languages VARCHAR (50),
	Types VARCHAR (50),
	Attributes VARCHAR (100),
	IsOriginalTitle bit,
	PRIMARY KEY (TitleId, Ordering),
	FOREIGN KEY (TitleId) REFERENCES TITLE_BASICS(Tconst)
);


-- 5) TITLE_RATINGS
DROP TABLE IF EXISTS TITLE_RATINGS
CREATE TABLE TITLE_RATINGS (
	Tconst NVARCHAR (255),
	AverageRating Decimal,
	NumVotes int,
	PRIMARY KEY (Tconst,NumVotes),
	FOREIGN KEY (Tconst) REFERENCES TITLE_BASICS(Tconst),
);
SELECT COUNT(Tconst) FROM TITLE_RATINGS


-- 6) TITLE_CREW
DROP TABLE IF EXISTS TITLE_CREW
CREATE TABLE TITLE_CREW (
	Tconst nVARCHAR (255),
	Director VARCHAR (MAX),
	Writer VARCHAR (MAX),
	PRIMARY KEY (Tconst),
	FOREIGN KEY (Tconst) REFERENCES TITLE_BASICS(Tconst),
);


-- 7) TITLE_EPISODE
DROP TABLE IF EXISTS TITLE_EPISODE 
CREATE TABLE TITLE_EPISODE (
	Tconst NVARCHAR (255),
	ParentTconst VARCHAR (10),
	SeasonNumber VARCHAR(20),
	EpisodeNumber VARCHAR (20),
	PRIMARY KEY (Tconst,ParentTconst),
	FOREIGN KEY (Tconst) REFERENCES TITLE_BASICS (Tconst)
);


-- BULK INSERT 
-- you can copy this bulk insert script and adjust it to your tables. 
-- 1) Insert the first file
BULK INSERT TITLE_BASICS
FROM 'D:\Semester 3 hil\basdat reborn\dataset imdb\1 jutaan\title.basics\title_basic_1.tsv'
WITH (
  FIELDTERMINATOR = '\t', -- Field terminator is tab because our file is tsv (tab separated value)
  ROWTERMINATOR = '\n',
  CODEPAGE = '65001',
  FIRSTROW = 2 -- we load from 2nd row because the first row contains column name
);

-- 2) Insert the other files (inserted by looping)
DECLARE @i INT = 2; -- start from 2nd file
DECLARE @sql NVARCHAR(MAX);
DECLARE @filePath NVARCHAR(255);

WHILE @i <= 12 -- the last file
BEGIN
    -- filePath depends on yours
    SET @filePath = 'D:\Semester 3 hil\basdat reborn\dataset imdb\1 jutaan\title.basics\title_basic_' + CAST(@i AS NVARCHAR(3)) + '.tsv'; 
    
    SET @sql = N'
    BULK INSERT TITLE_BASICS
    FROM ''' + @filePath + '''
    WITH (
      FIELDTERMINATOR = ''\t'',
      ROWTERMINATOR = ''\n'',
      CODEPAGE = ''65001'',
      FIRSTROW = 1
    );'

    EXEC sp_executesql @sql;

    SET @i = @i + 1;
END;