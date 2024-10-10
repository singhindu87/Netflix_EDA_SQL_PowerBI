/*
Set of queries for netflix dataset - 
Level: Beginners
Concepts : SELECT, COUNT, WHERE, GROUP, LIKE, CAST
Additional concepts covered - SUBSTRING, POSITION, UPPER, LOWER

*/

--count for entire data
SELECT COUNT(1)
FROM netflixshows;

-- select to show data
SELECT * 
FROM netflixshows n
;


--Display how many shows are availabe with rating TV-PG
SELECT COUNT(1)
FROM netflixshows
WHERE rating='TV-PG';

SELECT *
FROM netflixshows
WHERE rating='TV-PG';

--Display how many TV shows and Movies are in the dataset
SELECT TYPE, COUNT(*)
FROM netflixshows
GROUP BY TYPE;

--Show all the Reality TV series
SELECT title
FROM netflixshows
WHERE listed_in LIKE '%Reality%TV%';

--Show 90s kid's movies
SELECT title
FROM netflixshows
WHERE TYPE='Movie'
AND listed_in LIKE '%Children%'
AND release_year BETWEEN 1990 AND 2000;

--shows 90s Kid's movie which has length less 2 hours (100 minutes)
-- order by increasing duration
SELECT title, duration, SUBSTRING(duration,0, POSITION(' ' in duration)) duration_int
FROM netflixshows
WHERE TYPE='Movie'
AND listed_in LIKE '%Children%'
AND release_year BETWEEN 1990 AND 2000
AND CAST(SUBSTRING(duration,0, POSITION(' ' in duration)) as BIGINT) < '100'
ORDER BY duration_int ;

--Show all are available Jaws movie based on the released year
SELECT title, release_year
FROM netflixshows
WHERE TYPE='Movie'
AND UPPER(title) like '%JAWS%'
ORDER BY release_year;