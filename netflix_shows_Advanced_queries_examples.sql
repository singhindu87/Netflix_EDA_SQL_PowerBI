/*
Set of queries for netflix dataset - 
Level: Intermediate
Concepts : RANK, Subqueries

*/
--Top 3 director who worked as actor and director in most movies
WITH DIR AS
(
SELECT 
DISTINCT director
FROM netflixshows
WHERE director<>''
) 
, SUBSET AS
(
SELECT  
d.director, 
COUNT(1) AS count_of_appearance 
FROM netflixshows A 
JOIN DIR D  
ON  A.cast LIKE '%'|| D.director||',%' OR A.cast LIKE '%, '||D.director
GROUP BY d.director) 
, RN AS
(
SELECT 
director, 
count_of_appearance, rank() over (order by count_of_appearance DESC) RNK
FROM SUBSET
)
SELECT *
FROM RN
WHERE RNK<=3
ORDER BY RNK;


--Least 3 years where any TV show or movie is uploaded

WITH SUBSET  AS
(
SELECT EXTRACT (YEAR FROM date_added) YEAR_OF_UPLOAD, COUNT(title) COUNT_OF_SHOWS
FROM netflixshows ns
WHERE date_added IS NOT NULL
GROUP BY EXTRACT (YEAR FROM date_added)
), 
RN AS
(
SELECT S.*, 
RANK() OVER (  ORDER BY COUNT_OF_SHOWS DESC) 
FROM SUBSET S)
SELECT * 
FROM RN
WHERE RANK <=3