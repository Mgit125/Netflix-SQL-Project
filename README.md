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


### 5. Find the Longest movie from the data.

```sql
	SELECT * FROM netflix
	WHERE
	 type_movie = 'Movie'
	 AND
	 duration = (SELECT MAX(duration) from netflix)
 ```


### 6. Find the movies which are added in last 5 years
```sql
	SELECT 
		*
	FROM netflix
	WHERE 
		TO_DATE(date_added, 'Month DD, YYYY')>= CURRENT_DATE - INTERVAL '5 YEARS'
	
	
	SELECT CURRENT_DATE - INTERVAL '5 YEARS'
```

### 7. Find all the movies/TV shows by director 'Rajiv Chilaka'
```sql

	SELECT * FROM netflix
	WHERE
		director LIKE '%Rajiv Chilaka%'
	
	SELECT * FROM netflix
	WHERE
		director = 'Rajiv Chilaka'
```

