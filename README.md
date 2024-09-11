# Netflix Movies and TV Shows Data Analysis using SQL

![Netflix_logo](https://github.com/Mgit125/Netflix-SQL-Project/blob/main/N.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.
## Objectives
Analyze the distribution of content types (movies vs TV shows).
Identify the most common ratings for movies and TV shows.
List and analyze content based on release years, countries, and durations.
Explore and categorize content based on specific criteria and keywords.
## Dataset
The data for this project is sourced from the Kaggle dataset:
 https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download

## Schema

```sql

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

```

## Business Problems and Solutions

### 1. Count the number of Movies vs TV shows.
```sql
	SELECT 
		type_movie,
		COUNT(*) as total_content
	FROM netflix
	GROUP BY type_movie;
```

### 2. Find the most common rating for movies and TV shows.

```sql

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
```
### 3. List all movies released in the year 2020

```sql
	SELECT * FROM netflix;
	
	
	SELECT *
	FROM netflix
	WHERE
		type_movie = 'Movie' 
		AND 
		release_year = 2020;
```

### 4. Find the top 5 countries with the most movies/TV shows on netflix

```sql

	SELECT 
		UNNEST(STRING_TO_ARRAY(country,',')) AS new_country,
		count(show_id) as total_content
	from netflix
	GROUP BY country
	ORDER BY 
		total_content DESC
		LIMIT 5;
```


### 5. Find the Longest movie from the netflix data

```sql
	SELECT * FROM netflix
	WHERE
	 type_movie = 'Movie'
	 AND
	 duration = (SELECT MAX(duration) from netflix)
 ```


### 6. Find the Movies which are added in last 5 years
```sql
	SELECT 
		*
	FROM netflix
	WHERE 
		TO_DATE(date_added, 'Month DD, YYYY')>= CURRENT_DATE - INTERVAL '5 YEARS'

	SELECT CURRENT_DATE - INTERVAL '5 YEARS'
```

### 7. Find all the Movies/TV shows by director 'Rajiv Chilaka'
```sql

	SELECT * FROM netflix
	WHERE
		director LIKE '%Rajiv Chilaka%'
```
### 8. List all the TV shows who has more than 5 Seasons
```sql
	SELECT * FROM netflix
	WHERE
		type_movie = 'TV Show'
		AND
		duration > '5 Seasons';
```
### 9. Count the number of content items in each genre

```sql
	SELECT 
		UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genres,
		COUNT(show_id) AS total_count
	FROM netflix
	GROUP BY 1
	ORDER BY 2 DESC;
```

### 10. Find the eah year and the average number of movies release by India on Netflix and return top 5 year with highest avg movies release

```sql
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
```	
	
### 11. List all movies that are Documentaries

```sql
	SELECT * FROM netflix
	WHERE
		listed_in ilike '%documentaries%'
		AND
		type_movie = 'Movie'
```


### 12. Find all content without a director

 ```sql
		SELECT * FROM netflix
		WHERE
			director is null
```

### 13. Find how many movies actor 'Salman Khan' appeared in last 10 years

```sql
	SELECT * FROM netflix
	WHERE 
		casts ilike '%Salman Khan%'
		AND
		release_year > EXTRACT (YEAR FROM CURRENT_DATE)- 10

```

### 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

```sql
	SELECT 
		UNNEST(STRING_TO_ARRAY(casts,',')) AS actors,
		COUNT(*) AS total_content
	FROM netflix
	WHERE country ilike '%India'
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 10
```

### 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field & label content containing these keywords as 'Bad' and all other content as 'Good' & count how many items fall into  each category

```sql
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

```


# Conclusion

### Content Distribution 
The dataset features a diverse array of movies and TV shows, spanning various ratings and genres.

### Common Ratings
Analyzing the most frequent ratings offers insights into the target audience of the content.

### Geographical Insights 
Highlighting the top countries and the average content releases from India provides a view of regional content distribution.

### Content Categorization
Classifying content based on specific keywords helps in understanding the nature of the available content on Netflix.

#### This analysis offers a comprehensive overview of Netflix’s content, aiding in content strategy and decision-making.



## Author - Srinivas

This project is a significant component of my portfolio, demonstrating my proficiency in SQL, which is essential for data analyst roles. It showcases my ability to write complex queries, manage and manipulate databases, and extract meaningful insights from data.

If you have any questions, feedback, or if you're interested in discussing potential collaborations, please feel free to contact me. I'm eager to connect and explore opportunities to leverage data for strategic decision-making.




