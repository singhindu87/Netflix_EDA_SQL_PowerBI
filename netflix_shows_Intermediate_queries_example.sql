/*
Set of queries for netflix dataset - 
Level: Intermediate
Concepts : OR AND, LIKE,  EXTRACT, WITH QUERY, LIMIT, SIMILAR
Additional concepts covered -  ||, CURRENT_DATE

*/
--Show all the Reality TV series or Horror series released in last 3 years
SELECT title,listed_in, release_year 
FROM netflixshows
WHERE listed_in SIMILAR TO '(Reality TV|Horror)%'
AND release_year BETWEEN EXTRACT(YEAR FROM CURRENT_DATE)-3 and EXTRACT(YEAR FROM CURRENT_DATE)

--Show all the Reality TV series and Horror series released in last 3 years
SELECT title,listed_in, release_year 
FROM netflixshows
WHERE UPPER(listed_in) LIKE UPPER('%Reality%TV%')
AND UPPER(listed_in) LIKE UPPER('%Horror%')
AND release_year BETWEEN EXTRACT(YEAR FROM CURRENT_DATE)-3 and EXTRACT(YEAR FROM CURRENT_DATE)

--Show TV shows and movies where director acted in the movie and based out in United States

SELECT ns.title,country, director, ns.cast 
FROM netflixshows ns
WHERE ns.cast like  '%'||ns.director||'%' 
AND country='United States'

--Show directors who are also actors -- and worked in different movie
WITH dir AS 
(
SELECT 
distinct director, title
FROM netflixshows ns 
WHERE director <>''
)
SELECT 
DISTINCT 
d.director AS director_actor, a.title, a.cast
FROM dir d, netflixshows a
WHERE (A.cast LIKE '%'|| D.director||',%' OR A.cast LIKE '%, '||D.director)
AND a.director <> d.director
AND a.title<>d.title
AND a.cast<>''
AND a.title <> ''
LIMIT 100


