	--- 1) TITLE_CREW
	-- Create two tables for normalization results, TITLE_DIRECTOR and TITLE_WRITER
	DROP TABLE IF EXISTS TITLE_DIRECTOR;
	DROP TABLE IF EXISTS TITLE_WRITER;

	CREATE TABLE TITLE_DIRECTOR (
		Tconst NVARCHAR(255),
		Director NVARCHAR(255),
		FOREIGN KEY(Tconst) REFERENCES TITLE_BASICS(Tconst),
		FOREIGN KEY(Director) REFERENCES NAME_BASICS(Nconst)
	);

	CREATE TABLE TITLE_WRITER (
		Tconst NVARCHAR(255),
		Writer NVARCHAR(255),
		FOREIGN KEY(Tconst) REFERENCES TITLE_BASICS(Tconst),
		FOREIGN KEY(Writer) REFERENCES NAME_BASICS(Nconst)
	);

	-- Remove rows where both Director and Writer are '\N'
	DELETE FROM TITLE_CREW
	WHERE Director = '\N' AND Writer = '\N';

	---- Delete rows in TITLE_CREW where Tconst doesn't exist in Tconst from TITLE_BASICS
	DELETE FROM TITLE_CREW 
	WHERE Tconst NOT IN
	(SELECT Tconst FROM TITLE_BASICS)

	---- Delete rows in TITLE_CREW where Nconst doesn't exist in Nconst from NAME_BASICS
	DELETE FROM TITLE_CREW 
	WHERE Director NOT IN
	(SELECT Nconst FROM NAME_BASICS)

	DELETE FROM TITLE_CREW 
	WHERE Writer NOT IN 
	(SELECT Nconst FROM NAME_BASICS)

	-- NORMALIZATION
	-- Insert data into TITLE_DIRECTOR
	INSERT INTO TITLE_DIRECTOR (Tconst, Director)
	SELECT Tconst, TRIM(value) AS Director
	FROM TITLE_CREW
	CROSS APPLY STRING_SPLIT(Director, ',')

	-- Insert data into TITLE_WRITER
	INSERT INTO TITLE_WRITER(Tconst, Writer)
	SELECT Tconst, TRIM(value) AS Writer
	FROM TITLE_CREW
	CROSS APPLY STRING_SPLIT(Writer, ',')

	-- Delete the TITLE_CREW table
	DROP TABLE TITLE_CREW

	-- 2) NAME_BASICS (primaryProfession and knownForTitle)
	-- a) Create tables for normalization
	DROP TABLE IF EXISTS PERSON_PROFESSIONS
	CREATE TABLE PERSON_PROFESSIONS (
		Nconst NVARCHAR(255),
		Profession VARCHAR(100),
		FOREIGN KEY (Nconst) REFERENCES NAME_BASICS(Nconst)
	);

	DROP TABLE IF EXISTS PERSON_KNOWN_FOR_TITLE
	CREATE TABLE PERSON_KNOWN_FOR_TITLE (
		Nconst NVARCHAR(255),
		titleID NVARCHAR(255),
		FOREIGN KEY (Nconst) REFERENCES NAME_BASICS(Nconst),
		FOREIGN KEY (titleID) REFERENCES TITLE_BASICS(Tconst)
	);

	-- b) Move multivalued data from NAME_BASICS to PERSON_PROFESSIONS
	INSERT INTO PERSON_PROFESSIONS (Nconst, Profession)
	SELECT Nconst, TRIM(value) AS Profession
	FROM NAME_BASICS
	CROSS APPLY STRING_SPLIT(primaryProfession, ',');

	DELETE FROM PERSON_PROFESSIONS
	WHERE Profession = '\N'

	-- c) Move data to PERSON_KNOWN_FOR_TITLE
	INSERT INTO PERSON_KNOWN_FOR_TITLE (Nconst, titleID)
	SELECT Nconst, TRIM(value) AS titleID
	FROM NAME_BASICS
	CROSS APPLY STRING_SPLIT(knownForTitles, ',')
	WHERE TRIM(value) IN (SELECT Tconst FROM TITLE_BASICS);

	-- d) Drop columns knownForTitle and primaryProfession from NAME_BASICS
	ALTER TABLE NAME_BASICS
	DROP CONSTRAINT [FK__NAME_BASI__known__398D8EEE]

	ALTER TABLE NAME_BASICS
	DROP COLUMN primaryProfession, knownForTitles;

	SELECT DISTINCT Profession FROM PERSON_PROFESSIONS -- there are 47 professions
	SELECT COUNT(Nconst) FROM PERSON_PROFESSIONS -- there are around 18 million rows
	SELECT COUNT(Nconst) FROM NAME_BASICS -- there are around 13.8 million rows in NAME_BASICS

	-- e) Create a table that stores professions and their IDs
	CREATE TABLE PROFESSION(
		ProfessionId NVARCHAR(10) PRIMARY KEY,
		ProfessionName VARCHAR(100)    
	)

	INSERT INTO PROFESSION (ProfessionId, ProfessionName)
	VALUES
		('Prof1', 'actress'),
		('Prof2', 'stunts'),
		('Prof3', 'editorial department'),
		('Prof4', 'choreographer'),
		('Prof5', 'production designer'),
		('Prof6', 'soundtrack'),
		('Prof7', 'legal'),
		('Prof8', 'make up department'),
		('Prof9', 'art director'),
		('Prof10', 'set decorator'),
		('Prof11', 'special effects'),
		('Prof12', 'executive'),
		('Prof13', 'accountant'),
		('Prof14', 'casting director'),
		('Prof15', 'actor'),
		('Prof16', 'director'),
		('Prof17', 'composer'),
		('Prof18', 'producer'),
		('Prof19', 'camera department'),
		('Prof20', 'archive footage'),
		('Prof21', 'assistant'),
		('Prof22', 'assistant director'),
		('Prof23', 'editor'),
		('Prof24', 'transportation department'),
		('Prof25', 'visual effects'),
		('Prof26', 'electrical department'),
		('Prof27', 'sound department'),
		('Prof28', 'production manager'),
		('Prof29', 'casting department'),
		('Prof30', 'music artist'),
		('Prof31', 'talent agent'),
		('Prof32', 'writer'),
		('Prof33', 'costume department'),
		('Prof34', 'publicist'),
		('Prof35', 'podcaster'),
		('Prof36', 'costume designer'),
		('Prof37', 'archive sound'),
		('Prof38', 'miscellaneous'),
		('Prof39', 'art department'),
		('Prof40', 'music department'),
		('Prof41', 'location management'),
		('Prof42', 'manager'),
		('Prof43', 'cinematographer'),
		('Prof44', 'animation department'),
		('Prof45', 'script department'),
		('Prof46', 'production department');

	-- f) Update Profession column in PERSON_PROFESSIONS to use Foreign Key referencing PROFESSION table
	UPDATE PERSON_PROFESSIONS
	SET Profession = CASE
		WHEN Profession = 'actress' THEN 'Prof1'
		WHEN Profession = 'stunts' THEN 'Prof2'
		WHEN Profession = 'editorial_department' THEN 'Prof3'
		WHEN Profession = 'choreographer' THEN 'Prof4'
		WHEN Profession = 'production_designer' THEN 'Prof5'
		WHEN Profession = 'soundtrack' THEN 'Prof6'
		WHEN Profession = 'legal' THEN 'Prof7'
		WHEN Profession = 'make_up_department' THEN 'Prof8'
		WHEN Profession = 'art_director' THEN 'Prof9'
		WHEN Profession = 'set_decorator' THEN 'Prof10'
		WHEN Profession = 'special_effects' THEN 'Prof11'
		WHEN Profession = 'executive' THEN 'Prof12'
		WHEN Profession = 'accountant' THEN 'Prof13'
		WHEN Profession = 'casting_director' THEN 'Prof14'
		WHEN Profession = 'actor' THEN 'Prof15'
		WHEN Profession = 'director' THEN 'Prof16'
		WHEN Profession = 'composer' THEN 'Prof17'
		WHEN Profession = 'producer' THEN 'Prof18'
		WHEN Profession = 'camera_department' THEN 'Prof19'
		WHEN Profession = 'archive_footage' THEN 'Prof20'
		WHEN Profession = 'assistant' THEN 'Prof21'
		WHEN Profession = 'assistant_director' THEN 'Prof22'
		WHEN Profession = 'editor' THEN 'Prof23'
		WHEN Profession = 'transportation_department' THEN 'Prof24'
		WHEN Profession = 'visual_effects' THEN 'Prof25'
		WHEN Profession = 'electrical_department' THEN 'Prof26'
		WHEN Profession = 'sound_department' THEN 'Prof27'
		WHEN Profession = 'production_manager' THEN 'Prof28'
		WHEN Profession = 'casting_department' THEN 'Prof29'
		WHEN Profession = 'music_artist' THEN 'Prof30'
		WHEN Profession = 'talent_agent' THEN 'Prof31'
		WHEN Profession = 'writer' THEN 'Prof32'
		WHEN Profession = 'costume_department' THEN 'Prof33'
		WHEN Profession = 'publicist' THEN 'Prof34'
		WHEN Profession = 'podcaster' THEN 'Prof35'
		WHEN Profession = 'costume_designer' THEN 'Prof36'
		WHEN Profession = 'archive_sound' THEN 'Prof37'
		WHEN Profession = 'miscellaneous' THEN 'Prof38'
		WHEN Profession = 'art_department' THEN 'Prof39'
		WHEN Profession = 'music_department' THEN 'Prof40'
		WHEN Profession = 'location_management' THEN 'Prof41'
		WHEN Profession = 'manager' THEN 'Prof42'
		WHEN Profession = 'cinematographer' THEN 'Prof43'
		WHEN Profession = 'animation_department' THEN 'Prof44'
		WHEN Profession = 'script_department' THEN 'Prof45'
		WHEN Profession = 'production_department' THEN 'Prof46'
	END;

	ALTER TABLE PERSON_PROFESSIONS
	ALTER COLUMN Profession NVARCHAR(10) NOT NULL

	ALTER TABLE PERSON_PROFESSIONS 
	ADD CONSTRAINT Fk_PersonProfessions FOREIGN KEY (Profession) REFERENCES PROFESSION(ProfessionId);

	-- 2) TITLE_BASICS
	-- Create a table for normalization results
	DROP TABLE IF EXISTS TITLE_GENRE
	CREATE TABLE TITLE_GENRE (
		Tconst NVARCHAR(255),
		Genre VARCHAR(30),
		FOREIGN KEY (Tconst) REFERENCES TITLE_BASICS(Tconst)
	);

	-- Insert genre data
	INSERT INTO TITLE_GENRE (Tconst, Genre)
	SELECT Tconst, TRIM(value) AS Genre
	FROM TITLE_BASICS
	CROSS APPLY STRING_SPLIT(Genres, ',');

	-- Drop the Genres column from TITLE_BASICS
	ALTER TABLE TITLE_BASICS
	DROP COLUMN Genres;

	DELETE FROM TITLE_GENRE
	WHERE Genre = '\N'

	SELECT DISTINCT Genre FROM TITLE_GENRE

	-- CREATE TABLE GENRES 
	CREATE TABLE GENRES(
		GenreId NVARCHAR(10) PRIMARY KEY,
		GenreName NVARCHAR(20)
	)

	INSERT INTO GENRES (GenreId, GenreName)
	VALUES 
		('G1', 'Western'),
		('G2', 'Music'),
		('G3', 'Musical'),
		('G4', 'Adventure'),
		('G5', 'Biography'),
		('G6', 'Drama'),
		('G7', 'Film-Noir'),
		('G8', 'News'),
		('G9', 'Adult'),
		('G10', 'Animation'),
		('G11', 'Family'),
		('G12', 'History'),
		('G13', 'Thriller'),
		('G14', 'Crime'),
		('G15', 'Talk-Show'),
		('G16', 'Game-Show'),
		('G17', 'Romance'),
		('G18', 'Sci-Fi'),
		('G19', 'Sport'),
		('G20', 'Fantasy'),
		('G21', 'Mystery'),
		('G22', 'Documentary'),
		('G23', 'Reality-TV'),
		('G24', 'Comedy'),
		('G25', 'Horror'),
		('G26', 'Action'),
		('G27', 'War'),
		('G28', 'Short');

	UPDATE TITLE_GENRE
	SET TG.Genre = G.GenreId
	FROM TITLE_GENRE TG
	JOIN GENRES G
	ON TG.Genre = G.GenreName;

	ALTER TABLE TITLE_GENRE
	ALTER COLUMN Genre NVARCHAR(10)

	ALTER TABLE TITLE_GENRE
	ADD CONSTRAINT Fk_genretitle FOREIGN KEY (Genre) REFERENCES GENRES(GenreId)


-- 4) TITLE_PRINCIPALS
-- Check if 'characters' are only assigned to records with categories 'actress', 'actor', 'self', 'archive footage', and 'archive sound'
SELECT *
FROM TITLE_PRINCIPALS
WHERE characters IS NOT NULL
AND category NOT IN ('actress', 'actor', 'self', 'archive_footage', 'archive_sound');
-- It turns out the answer is yes

ALTER TABLE TITLE_PRINCIPALS
DROP CONSTRAINT [PK__TITLE_PR__0614A2B44556EBA8]

ALTER TABLE TITLE_PRINCIPALS
ALTER COLUMN Nconst NVARCHAR(255) NOT NULL

ALTER TABLE TITLE_PRINCIPALS
ADD PRIMARY KEY(Tconst, Ordering)

-- We will create a separate characters table to minimize null values in the title
DROP TABLE IF EXISTS TITLE_CHARACTERS
CREATE TABLE TITLE_CHARACTERS(
    Tconst NVARCHAR(255) NOT NULL,
    Nconst NVARCHAR(255) NOT NULL,
    [Character] NVARCHAR(600),
    FOREIGN KEY(Tconst) REFERENCES TITLE_BASICS(Tconst),
    FOREIGN KEY (Nconst) REFERENCES NAME_BASICS(Nconst)
);

INSERT INTO TITLE_CHARACTERS(Tconst, Nconst, Character)
SELECT Tconst, Nconst, TRIM(value) AS Character
FROM TITLE_PRINCIPALS
CROSS APPLY STRING_SPLIT(Characters, ',')
WHERE Characters IS NOT NULL

ALTER TABLE TITLE_PRINCIPALS
DROP COLUMN Characters
