--1) TABEL NAME_BASICS 
	SELECT TOP 100 * FROM NAME_BASICS
	-- Replace '\N' with NULL
	UPDATE NAME_BASICS
	SET	deathYear  = NULL
	WHERE deathYear  = '\N';

	UPDATE NAME_BASICS
	SET	birthYear  = NULL
	WHERE birthYear  = '\N';

	-- Change the data type of columns to the appropriate type
	ALTER TABLE NAME_BASICS
	ALTER COLUMN deathYear INT

	ALTER TABLE NAME_BASICS
	ALTER COLUMN birthYear INT

	SELECT DISTINCT deathYear FROM NAME_BASICS ORDER BY deathYear 
	SELECT DISTINCT birthYear FROM NAME_BASICS ORDER BY birthYear 

	-- There is unlikely to be anyone born before the year 1000 AD who created a TV show. Set such values to NULL.
	UPDATE NAME_BASICS
	SET	deathYear  = NULL
	WHERE deathYear  <= 1000;

	UPDATE NAME_BASICS
	SET	birthYear  = NULL
	WHERE birthYear  <= 1000;
	
	-- Add a new column 'Status' to indicate the living status of individuals
	ALTER TABLE NAME_BASICS
	ADD [Status] VARCHAR(15)

	UPDATE NAME_BASICS
	SET [Status] = CASE
		WHEN deathYear IS NOT NULL AND birthYear IS NOT NULL THEN 'dead'
		WHEN birthYear IS NOT NULL AND birthYear IS NULL THEN 'Alive'
		ELSE NULL
	END

--2) TABEL TITLE_BASICS
	-- Replace '\N' with NULL
	UPDATE TITLE_BASICS
	SET	endYear  = NULL
	WHERE endYear  = '\N';

	UPDATE TITLE_BASICS
	SET	runtimeMinutes  = NULL
	WHERE runtimeMinutes  = '\N';

	UPDATE TITLE_BASICS
	SET	startYear  = NULL
	WHERE startYear  = '\N';

	-- Change the data type of columns to the appropriate type 
	ALTER TABLE TITLE_BASICS
	ALTER COLUMN endYear INT

	ALTER TABLE TITLE_BASICS
	ALTER COLUMN startYear INT

	ALTER TABLE TITLE_BASICS
	ALTER COLUMN titleType VARCHAR(15)

	ALTER TABLE TITLE_BASICS
	ALTER COLUMN isAdult BIT

	SET ANSI_WARNINGS OFF;
	ALTER TABLE TITLE_BASICS
	ALTER COLUMN primaryTitle NVARCHAR(255)

	ALTER TABLE TITLE_BASICS
	ALTER COLUMN originalTitle NVARCHAR(255)
	SET ANSI_WARNINGS ON;

	ALTER TABLE TITLE_BASICS
	ALTER COLUMN runtimeMinutes INT;

	SELECT TOP 10000 originalTitle,primaryTitle from TITLE_BASICS
	


-- 3) TITLE_AKAS
	-- Replace '\N' with NULL
	UPDATE TITLE_AKAS
	SET	Languages  = NULL
	WHERE Languages  = '\N';

	UPDATE TITLE_AKAS
	SET	Region  = NULL
	WHERE Region  = '\N';

	UPDATE TITLE_AKAS
	SET	Types  = NULL
	WHERE Types  = '\N';

	UPDATE TITLE_AKAS
	SET	Attributes  = NULL
	WHERE Attributes  = '\N';

	-- Replace 'Title' values that contain multiple '?' characters with NULL
	UPDATE TITLE_AKAS
	SET	Title  = NULL
	WHERE Title  = '????????'

	-- Change the data type of columns to the appropriate type
	ALTER TABLE TITLE_AKAS DROP CONSTRAINT PK__TITLE_AK__80A11341D2968CA4

	ALTER TABLE TITLE_AKAS
	ALTER COLUMN Ordering SMALLINT NOT NULL

	ALTER TABLE TITLE_AKAS ADD PRIMARY KEY (Ordering,TitleId)

	-- Find the regions that only have one language
	SELECT DISTINCT Region, Languages
	FROM TITLE_AKAS
	WHERE Languages IS NOT NULL AND Region IN (
    SELECT Region
    FROM TITLE_AKAS
    GROUP BY Region
    HAVING COUNT(DISTINCT Languages) = 1
	);

	-- Replace the language of the region according to other data with the same region that only have one language
	UPDATE TITLE_AKAS
	SET Languages = CASE
		WHEN Region = 'MZ' THEN 'pt'
		WHEN Region = 'PE' THEN 'es'
		WHEN Region = 'AL' THEN 'sq'
		WHEN Region = 'ZM' THEN 'en'
		WHEN Region = 'VN' THEN 'vi'
		WHEN Region = 'XWG' THEN 'de'
		WHEN Region = 'EE' THEN 'et'
		WHEN Region = 'YE' THEN 'en'
		WHEN Region = 'BJ' THEN 'fr'
		WHEN Region = 'SK' THEN 'sk'
		WHEN Region = 'BO' THEN 'es'
		WHEN Region = 'GE' THEN 'ka'
		WHEN Region = 'NG' THEN 'en'
		WHEN Region = 'BZ' THEN 'en'
		WHEN Region = 'PR' THEN 'es'
		WHEN Region = 'UZ' THEN 'uz'
		WHEN Region = 'HU' THEN 'hu'
		WHEN Region = 'IS' THEN 'is'
		WHEN Region = 'LA' THEN 'lo'
		WHEN Region = 'MK' THEN 'mk'
		WHEN Region = 'BF' THEN 'bg'
		WHEN Region = 'LV' THEN 'lv'
		WHEN Region = 'XNA' THEN 'en'
		WHEN Region = 'CR' THEN 'es'
		WHEN Region = 'BY' THEN 'be'
		WHEN Region = 'XEU' THEN 'en'
		WHEN Region = 'CG' THEN 'fr'
		WHEN Region = 'VG' THEN 'en'
		WHEN Region = 'AM' THEN 'hy'
		WHEN Region = 'MN' THEN 'mn'
		WHEN Region = 'TJ' THEN 'tg'
		WHEN Region = 'AZ' THEN 'az'
		WHEN Region = 'JE' THEN 'en'
		WHEN Region = 'JO' THEN 'ar'
		WHEN Region = 'SR' THEN 'en'
		WHEN Region = 'PY' THEN 'es'
		WHEN Region = 'PA' THEN 'es'
		WHEN Region = 'CM' THEN 'fr'
		WHEN Region = 'AE' THEN 'en'
		WHEN Region = 'VE' THEN 'es'
		WHEN Region = 'JM' THEN 'en'
		WHEN Region = 'UY' THEN 'es'
		WHEN Region = 'IQ' THEN 'ku'
		WHEN Region = 'NP' THEN 'ne'
		WHEN Region = 'BUMM' THEN 'my'
		ELSE Languages
	END
	WHERE Languages IS NULL
	
-- 4) TITLE_PRINCIPALS
	-- delete '[""]' from Characters
	UPDATE TITLE_PRINCIPALS
	SET Characters = REPLACE(REPLACE(Characters, '[', ''), ']', '')

	UPDATE TITLE_PRINCIPALS
	SET Characters = REPLACE(REPLACE(Characters, '"', ''), '"', '')

	UPDATE TITLE_PRINCIPALS
	SET	Characters  = NULL
	WHERE Characters  = '\N';

	UPDATE TITLE_PRINCIPALS
	SET	Job  = NULL
	WHERE Job  = '\N';

	ALTER TABLE TITLE_PRINCIPALS
	DROP CONSTRAINT PK__TITLE_PR__400476639B678830

	ALTER TABLE TITLE_PRINCIPALS
	ALTER COLUMN Ordering SMALLINT NOT NULL
	SET ANSI_WARNINGS OFF;
	ALTER TABLE TITLE_PRINCIPALS
	ADD PRIMARY KEY(Ordering, Tconst)

	ALTER TABLE TITLE_PRINCIPALS
	ALTER COLUMN Category VARCHAR(20)

	ALTER TABLE TITLE_PRINCIPALS
	ALTER COLUMN Job VARCHAR(20)


-- 5) TITLE_EPISODE
	-- Change the data type of columns to the appropriate type
	UPDATE TITLE_EPISODE
	SET	SeasonNumber  = NULL
	WHERE SeasonNumber  = '\N';

	UPDATE TITLE_EPISODE
	SET	EpisodeNumber  = NULL
	WHERE EpisodeNumber  = '\N';

	ALTER TABLE TITLE_EPISODE
	ALTER COLUMN SeasonNumber INT

	ALTER TABLE TITLE_EPISODE
	ALTER COLUMN EpisodeNumber INT

	ALTER TABLE TITLE_EPISODE
	DROP CONSTRAINT [PK__TITLE_EP__0B49213406E79045]
	
	ALTER TABLE TITLE_EPISODE
	DROP CONSTRAINT
	[FK__TITLE_EPI__Tcons__48CFD27E]

	ALTER TABLE TITLE_EPISODE
	ALTER COLUMN ParentTconst NVARCHAR(255) NOT NULL

	ALTER TABLE TITLE_EPISODE
	ADD PRIMARY KEY(Tconst)
	
	-- Check if there is any ParentTconst in TITLE_EPISODE that doesn't exist in Tconst from TITLE_BASICS
	SELECT ParentTconst FROM TITLE_EPISODE
	WHERE ParentTconst NOT IN
	(SELECT Tconst FROM TITLE_BASICS);

	-- Delete rows in TITLE_EPISODE where ParentTconst doesn't exist in Tconst from TITLE_BASICS
	DELETE FROM TITLE_EPISODE
	WHERE ParentTconst NOT IN
	(SELECT Tconst FROM TITLE_BASICS);

	-- Add a foreign key constraint for ParentTconst referencing Tconst in TITLE_BASICS
	ALTER TABLE TITLE_EPISODE 
	ADD CONSTRAINT fk_Parent_episode FOREIGN KEY (ParentTconst) REFERENCES TITLE_BASICS(Tconst);

	-- Check if Tconst in TITLE_EPISODE is properly referenced to Tconst in TITLE_BASICS
	SELECT Tconst FROM TITLE_EPISODE
	WHERE Tconst IN
	(SELECT Tconst FROM TITLE_BASICS);

	-- Delete rows in TITLE_EPISODE where Tconst doesn't exist in Tconst from TITLE_BASICS
	DELETE FROM TITLE_EPISODE
	WHERE Tconst NOT IN
	(SELECT Tconst FROM TITLE_BASICS);

	-- Add a foreign key constraint for Tconst referencing Tconst in TITLE_BASICS
	ALTER TABLE TITLE_EPISODE 
	ADD CONSTRAINT fk_Tconst_episode FOREIGN KEY (Tconst) REFERENCES TITLE_BASICS(Tconst);
