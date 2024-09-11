-- Netflix Project

CREATE TABLE netflix
(
	show_id	VARCHAR(10),
	type	VARCHAR(10),
	title VARCHAR(150),	
	director VARCHAR(210),	
	casts	VARCHAR(800),
	country	VARCHAR(150),
	date_added	VARCHAR(50),
	release_year INT,	
	rating	VARCHAR(10),
	duration VARCHAR(20),	
	listed_in	VARCHAR(25),
	description VARCHAR(300)
);



DROP TABLE netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(10),
	type_movie	VARCHAR(15),
	title VARCHAR(150),	
	director VARCHAR(210),	
	casts	VARCHAR(800),
	country	VARCHAR(150),
	date_added	VARCHAR(50),
	release_year INT,	
	rating	VARCHAR(10),
	duration VARCHAR(20),	
	listed_in	VARCHAR(100),       -- increased the length
	description VARCHAR(300)
);

SELECT * FROM netflix;

SELECT count(*) as total_content FROM netflix;



-- 15  Business Problems

1. Count the number of Movies vs TV shows.

SELECT 
	type_movie,
	COUNT(*) as total_content
FROM netflix
GROUP BY type_movie;


2. Find the most common rating for movies and TV shows.

		---Using Windows function

SELECT 
	type_movie,
	rating
FROM 
(
SELECT 
	type_movie,
	rating,
	COUNT(*),
	RANK() OVER (PARTITION BY type_movie ORDER BY COUNT(*) DESC) as ranking
FROM netflix
GROUP BY 1,2
) as t1
WHERE ranking =1;


3. List all movies released in a specific year (e.g. 2020)

SELECT * FROM netflix;


SELECT *
FROM netflix
WHERE
	type_movie = 'Movie' 
	AND 
	release_year = 2020;


4. Find the top 5 countries with the most content on netflix


SELECT 
	type_movie,
	country,
	count(country) as total_content
FROM netflix
GROUP BY country, type_movie
Order by 
	total_content DESC 
	limit 5   
				------------issue with multiple countries in the same list
				------------------separate countries
				----- String to array functions to solve this problem
				------ UNNEST function to 


SELECT 
	UNNEST(STRING_TO_ARRAY(country,',')) AS new_country,
	count(show_id) as total_content
from netflix
GROUP BY country
ORDER BY 
	total_content DESC
	LIMIT 5;
					



5. Find the Longest movie from the data.


SELECT * FROM netflix
WHERE
 type_movie = 'Movie'
 AND
 duration = (SELECT MAX(duration) from netflix)
 


6. Find the movies which are added in last 5 years

	SELECT 
		*
	FROM netflix
	WHERE 
		TO_DATE(date_added, 'Month DD, YYYY')>= CURRENT_DATE - INTERVAL '5 YEARS'
	
	
	SELECT CURRENT_DATE - INTERVAL '5 YEARS'


7. Find all the movies/TV shows by director 'Rajiv Chilaka'


	SELECT * FROM netflix
	WHERE
		director LIKE '%Rajiv Chilaka%'
	
	SELECT * FROM netflix
	WHERE
		director = 'Rajiv Chilaka'


8.List all the TV shows who has more than 5 Seasons

SELECT * FROM netflix
WHERE
	type_movie = 'TV Show'
	AND
	duration > '5 Seasons';


9. COunt the number of content items in each genre

	SELECT 
		UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genres,
		COUNT(show_id) AS total_count
	FROM netflix
	GROUP BY 1
	ORDER BY 2 DESC;



10. Find the eah year and the average number of movies release by India on Netflix
		and return top 5 year with highest avg movies release


SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as YEAR,
	COUNT(*) AS yearly_content,
	ROUND(COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100, 2) AS avg_content
FROM netflix
WHERE
	country = 'India'
GROUP BY 1
ORDER BY 
	avg_content DESC
	LIMIT 5
	
	
11. List all movies that are Documentaries

	SELECT * FROM netflix
	WHERE
		listed_in ilike '%documentaries%'
		AND
		type_movie = 'Movie'



12. Find all content without a director
	
		SELECT * FROM netflix
		WHERE
			director is null

13. Find how many movies actor 'Salman Khan' appeared in last 10 years

	SELECT * FROM netflix
	WHERE 
		casts ilike '%Salman Khan%'
		AND
		release_year > EXTRACT (YEAR FROM CURRENT_DATE)- 10



14. Find the top 10 actors who have appeared in the highest number of movies produced in India.


	SELECT 
		UNNEST(STRING_TO_ARRAY(casts,',')) AS actors,
		COUNT(*) AS total_content
	FROM netflix
	WHERE country ilike '%India'
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 10



15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field
	& label content containing these keywords as 'Bad' and all other content as 'Good' 
	& count how many items fall into  each category

	WITH new_table
	AS
	(
	SELECT
	*,
		CASE
		WHEN
			description ilike '%kill%' OR
			description ilike '%violence' THEN 'Bad_Content'
			ELSE 'Good_Content'
		END category
	FROM netflix
	)
	SELECT 
		category,
		COUNT(*) AS total_content
	FROM new_table
	GROUP BY 1
	










