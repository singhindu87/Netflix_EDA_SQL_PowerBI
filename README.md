![Screenshot Netflix logo](https://github.com/singhindu87/Netflix_SQL_EDA/blob/main/netflix_image.jfif)
# Netflix_SQL_EDA
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset.
# Problem Statement
The goal of this exploratory data analysis is to investigate the patterns, trends, and insights within the Netflix catalog of TV shows and movies. By investigating key factors such as genre, release year, runtime and cast details, we aim to cover correlation between content available and the key trends.

Understand Content Catalog: Analyze the distribution of Movies vs. TV Shows, genres, and countries to evaluate the diversity of Netflix’s offerings.
Identify Content Trends: Examine release patterns over time to discover key trends in Netflix’s content production and acquisition.
Target Audience Analysis: Assess content ratings to determine the primary audience Netflix serves and identify potential gaps in age group or content type.
Analyze Global Reach: Investigate which countries produce the most content for Netflix and explore regional opportunities for growth.
Popular Genres and Directors: Identify the most successful genres, directors, and content categories to inform future production and licensing decisions.
# Dataset Information

* Dataset source: [Netflix shows (movies and TV shows)](https://www.kaggle.com/datasets/shivamb/netflix-shows)
* Total records: 8807

# Key Attributes:
* show_id 				: unique identifier for rows(movies and TV shows)
* type					  :namely, Movie or TV Show
* title 					: name of the TV show or Movie
* director 				: director name (blank in few cases)
* cast 					  : cast (blank in few cases)
* country 				: country the show produced in (blank in few cases)
* date_added 			: date the show is added on Netflix (YYYY-MM-DD)
* release_year		: year of release 
* rating				  : rating of the show  from 18 categories  (blank in few cases)
* duration				: namely, in minutes, or season
* listed_in				: genre
* description 		: description text about the show
# Data Load
![Screenshot of data load](https://github.com/singhindu87/Netflix_SQL_EDA/blob/main/netflix_dataload.JPG)
# PostgreSQL Create table script
  ```
  CREATE TABLE IF NOT EXISTS mockdb.netflixshows(
    show_id character varying ,
    type character varying ,
    title character varying ,
    director character varying ,
    "cast" character varying ,
    country character varying ,
    date_added date,
    release_year integer,
    rating character varying ,
    duration character varying ,
    listed_in character varying ,
    description character varying);
  ```
# SQL - Exploratory Data Analysis
## SQL functions used
* AVG
* CASE
* CAST
* COUNT
* EXTRACT
* GROUP BY
* LIMIT
* STRING_TO_ARRAY
* UNNEST
* ORDER BY
* ROUND
* SUBSTRING
* DISTINCT
* MIN
* ILIKE
* SPLIT_PART
* RANK()

## UC#1 - Most common rating for Movies and TV shows
```
select type as show_type,
rating,
total_count
from (
select type,
rating,
count(show_id) as total_count,
rank() over(partition by type order by count(*) desc ) as ranking
from netflixshows a
group by 1,2
order by 3 desc
) as t1
where ranking = 1
;
```
![Screenshot of resultset](https://github.com/singhindu87/Netflix_SQL_EDA/blob/main/uc1_screenshot.png)
## UC#2 - Avg runtime of TV-shows and movies
```
SELECT type,
CAST(ROUND(AVG(CAST(split_part(duration, ' ', 1) AS INTEGER)), 2) AS TEXT) ||
CASE WHEN type = 'Movie' THEN ' minutes'
ELSE ' Seasons' END average_duration
FROM netflixshows
WHERE duration IS NOT NULL
GROUP BY type;
```
![Screenshot of resultset](https://github.com/singhindu87/Netflix_SQL_EDA/blob/main/uc2_screenshot.png)
## UC#3 - Find top 5 Directors with most movies and TV shows
```
select *
from (
select unnest(string_to_array(director, ',')),
count(show_id) as no_of_shows_directors,
row_number() over( order by count(show_id) desc) as row_num
from netflixshows
group by 1 ) as t1
where row_num <=5
;
```
![Screenshot of resultset](https://github.com/singhindu87/Netflix_SQL_EDA/blob/main/uc3_screenshot.png)
## UC#4 - Top 3 directors who worked as actors
```
WITH DIR AS
(
SELECT
DISTINCT director
FROM netflixshows
WHERE director<>''
and type='Movie'
)
, SUBSET AS
(
SELECT
d.director,
COUNT(1) AS count_of_appearance
FROM netflixshows A
JOIN DIR D
ON ((A.cast LIKE '%'|| D.director||',%' )OR (A.cast LIKE '%, '||D.director))
where a.type='Movie'
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
```
![Screenshot of resultset](https://github.com/singhindu87/Netflix_SQL_EDA/blob/main/uc4_screenshot.png)
## UC#5 -  Top 3 most popular genres based on country using a dense rank to break ties
```
WITH country_unnest_tbl
AS (
	SELECT show_id,
		   TRIM (BOTH ' ' FROM UNNEST (string_to_array(LOWER(country), ','))) country_single
	FROM netflixshows
	WHERE country IS NOT NULL
	),
genre_unnest_tbl
AS (
	SELECT show_id,
	       TRIM (BOTH ' ' FROM UNNEST (STRING_TO_ARRAY(LOWER(listed_in), ','))) genre
	FROM netflixshows
	WHERE listed_in IS NOT NULL
	),
grouped_tbl
AS (
SELECT 
       c.country_single country,
	   g.genre genre,
	   COUNT(*) total_shows
FROM country_unnest_tbl c,
     genre_unnest_tbl g
WHERE c.show_id = g.show_id AND
      c.country_single <> '' AND
	  genre <> ''
GROUP BY 
         c.country_single,
		 g.genre),
ranked_tbl 
AS 
	(SELECT country,
	       genre,
		   total_shows,
		   DENSE_RANK() OVER (PARTITION BY country ORDER BY total_shows DESC) top_genre_ranking
	FROM grouped_tbl
	)
SELECT * 
FROM ranked_tbl
WHERE top_genre_ranking <= 3;
```
![Screenshot of resultset](https://github.com/singhindu87/Netflix_SQL_EDA/blob/main/uc5_screenshot.png)







