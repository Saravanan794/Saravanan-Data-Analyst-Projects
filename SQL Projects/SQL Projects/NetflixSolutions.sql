-- Netflix Project

CREATE TABLE netflix
(
show_id  VARCHAR(6),
type VARCHAR(10),
title VARCHAR(150),
director VARCHAR(208),
casts VARCHAR(1000),
country VARCHAR(150),
date_added VARCHAR(50),
release_year INT,
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(100),
description VARCHAR(250)
);

SELECT * FROM netflix;

SELECT COUNT(*) AS total_content FROM netflix;

SELECT DISTINCT type FROM netflix;

SELECT DISTINCT title FROM netflix;


-- 1) COUNT THE NUMBER OF MOVIES VS TV SHOWS
SELECT type,COUNT(*) as total_content FROM netflix GROUP BY type;

-- 2) FIND THE MOST COMMON RATING FOR MOVIES AND TV SHOWS
SELECT 
type,rating FROM
(SELECT type,rating,COUNT(*),
RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
FROM netflix
GROUP BY 1,2) as t1
WHERE
ranking = 1

-- 3) LIST ALL THE MOVIES RELEASED IN SPECIFIC YEAR
SELECT * FROM netflix
WHERE type = 'Movie'
AND release_year = 2020

-- 4) FIND THE TOP 5 COUNTRIES WITH THE MOST CONTENT ON NETFLIX
SELECT 
UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- 5) IDENTIFY THE LONGEST MOVIE LENGTH
SELECT * FROM netflix
WHERE 
type = 'Movie'
AND
duration = (SELECT MAX(duration) FROM netflix)

-- 6) FIND THE CONTENT THAT ADDED IN THE LAST 5 YEARS
SELECT * FROM netflix
WHERE
TO_DATE(date_added,'Month DD, YYYY') >= CURRENT_DATE >= INTERVAL'5 years'

-- 7) FIND ALL THE MOVIES/TVSHOWS BY DIRECTOR 'JOHNNY MARTIN'
SELECT * FROM netflix
WHERE director LIKE '%Johnny Martin'

-- 8) LIST ALL TV SHOWS WITH MORE THAN 5 SEASONS
SELECT * FROM netflix
WHERE type = 'TV Show'
AND
SPLIT_PART(duration,' ',1)::numeric >5 

-- 9) COUNT THE NUMBER OF CONTENT ITEMS IN EACH GENRE	 
SELECT 
UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
COUNT(show_id) as total_content
FROM netflix
GROUP BY 1

-- 10) FIND EACH YEAR AND THE AVERAGE NUMBERS OF CONTENT RELEASE IN INDIA ON NETFLIX RETURN TOP 5 YEAR WITH HIGEST AVERAGE CONTENT RELEASE
SELECT 
EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) as year,
COUNT(*),
ROUND(COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100,2) as AVG_CONTENT
FROM netflix
WHERE COUNTRY = 'India'
GROUP BY 1 

-- 11) LIST ALL THE MOVIES THAT ARE DOCUMENTARIES
SELECT * FROM netflix
WHERE 
listed_in ILIKE '%documentaries'

-- 12) FIND ALL CONTENT WITHOUT A DIRECTOR

SELECT * FROM netflix WHERE director IS NULL


-- 13) FIND HOW MANY MOVIES ACTOR 'Salman Khan' APPEARED IN LAST 10 YEARS
SELECT * FROM netflix
WHERE casts ILIKE '%Salman Khan%'
AND
release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

-- -- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

