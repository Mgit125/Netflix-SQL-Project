
---- Advanced SQL Project: Spotify Music

DROP TABLE IF EXISTS Spotify;

CREATE TABLE Spotify (

	artist VARCHAR(255),
	track VARCHAR(255),
	album VARCHAR(255),
	album_type VARCHAR(50),
	danceability FLOAT,
	energy FLOAT,
	loudness FLOAT,
	speechiness FLOAT,
	acousticness FLOAT,
	instrumentalness FLOAT,
	liveness FLOAT,
	valence FLOAT,
	tempo FLOAT,
	duration_min FLOAT,
	title VARCHAR(255),
	channel VARCHAR(255),
	views FLOAT,
	likes BIGINT,
	comments BIGINT,
	licensed BOOLEAN,
	official_video BOOLEAN,        ------------ missed so added again and updated table
	stream BIGINT,
	energy_liveness FLOAT,
	most_played_on VARCHAR(100)
);

------  Exploratory Data Analysis (EDA)

SELECT * FROM Spotify;

SELECT * FROM Spotify
WHERE duration_min = 0;

DELETE FROM Spotify
WHERE duration_min = 0;

SELECT COUNT(artist) FROM Spotify;

SELECT COUNT(album) FROM Spotify;

select MAX(likes) from Spotify;

select MIN(likes) from Spotify;






-- Easy Level Queries (16)

1. Top 5 Songs by Energy:

SELECT track, energy FROM Spotify
ORDER BY track DESC
LIMIT 5;


2. Most Played Songs by Platform:
							----------------- Using window function : ROW_NUMBER()	

WITH RANKED_TRACKERS_PLATFORM_wise AS (

	SELECT
		track,
		views,
		most_played_on,
		ROW_NUMBER() OVER ( PARTITION BY most_played_on ORDER BY views DESC) AS max_view_rank
	FROM Spotify
	WHERE 
		most_played_on IN ('Spotify', 'Youtube')
)
SELECT
	track,
	views,
	most_played_on
FROM RANKED_TRACKERS_PLATFORM_wise
WHERE 
	max_view_rank =1;


3. Duration and Popularity of Songs by Artist:
								----------------- Using window function : ROW_NUMBER()				

WITH POP_ARTIST_DURATION AS (
	SELECT 
		artist,
		track,
		duration_min,
		stream,
		ROW_NUMBER() OVER (PARTITION BY artist ORDER BY stream DESC) AS popu_artist_rank,
		ROW_NUMBER() OVER (PARTITION BY artist ORDER BY duration_min DESC) AS dur_artist_rank
	FROM Spotify
)
SELECT
	artist,
	track,
	duration_min,
	stream
FROM POP_ARTIST_DURATION
WHERE
	popu_artist_rank = 1 OR dur_artist_rank =1
ORDER BY duration_min DESC, stream DESC
LIMIT 5;

	

4. Find the Average energy_liveness & Average liveness by each Track


SELECT 
    track,
    AVG(energy_liveness) AS avg_energy_liveness,
    AVG(liveness) AS avg_liveness
FROM Spotify
GROUP BY track
ORDER BY avg_energy_liveness DESC, avg_liveness DESC
LIMIT 10;


5. Songs with Highest Danceability and acousticness:

WITH high_dan_aco AS (
	SELECT 
		track,
		danceability,
		acousticness,
		ROW_NUMBER() OVER (ORDER BY danceability DESC) AS high_dan_rank,
		ROW_NUMBER() OVER (ORDER BY acousticness DESC) AS high_aco_rank
	FROM Spotify
)
SELECT 
	track,
	danceability,
	acousticness	
FROM high_dan_aco
WHERE
	high_dan_rank = 1 OR high_aco_rank =1;
	


6. Retrieve the names of all tracks that have more than 1 billion streams.


SELECT 
	track,
	stream
FROM Spotify
WHERE
	stream > 1000000000
ORDER BY stream DESC;



7. List all albums along with their respective artists.

SELECT 
	album,
	artist
FROM Spotify;


8. Get the total number of comments for tracks where licensed = TRUE.


	SELECT 
		track,
		SUM(comments) AS total_comments
	FROM Spotify
	WHERE
		licensed = TRUE
	GROUP BY 1
	ORDER BY 2 DESC;


9. Find all tracks that belong to the album type single.

SELECT 
	track
FROM Spotify
WHERE
	album_type = 'single';


10. Count the total number of tracks by each artist.

SELECT 
	artist,
	COUNT(track) AS total_no_of_songs_artist
FROM Spotify
GROUP BY artist;


11.	How many tracks are in the dataset?

SELECT 
	COUNT(track) 
FROM Spotify;


12.	How many distinct artists are there?

SELECT 
	DISTINCT(COUNT(artist)) 
FROM Spotify;


13.	What are the top 10 most popular songs?


SELECT 
	track,
	stream
FROM Spotify
ORDER BY stream DESC
LIMIT 10;



14.	How many albums are in the dataset?

SELECT 
	COUNT(album) AS total_albums
FROM Spotify


15.	Which tracks have a duration greater than 5 minutes?


SELECT
	track,
	duration_min
FROM Spotify
WHERE
	duration_min > 5
ORDER BY duration_min DESC;


16.	List all songs by a specific artist: 'Gorillaz'


SELECT
	artist,
	track
FROM Spotify
WHERE
	artist = 'Gorillaz'
ORDER BY artist;




-- Medium-level SQL queries (9)

1. Calculate the average danceability of tracks in each album.


SELECT 
	album,
	avg(danceability) avg_danceability_album
FROM Spotify
GROUP BY 1
ORDER BY 2 DESC;


2. Find the top 5 tracks with the highest energy values.

SELECT 
	track,
	energy_liveness
FROM Spotify
ORDER BY energy_liveness DESC
LIMIT 5;
	


3. List all tracks along with their views and likes where official_video = TRUE.


SELECT 
	track,
	views,
	likes,
	official_video
FROM Spotify
WHERE
	official_video = TRUE
ORDER BY 
	views DESC,
	likes DESC;
	


4. For each album, calculate the total views of all associated tracks.

SELECT 
	album,
	SUM(views) AS total_views
FROM Spotify
GROUP BY album
ORDER BY total_views DESC;


5. Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT 
	track,
	stream,
	most_played_on
FROM Spotify
WHERE
	most_played_on = 'Spotify'
ORDER BY stream DESC;


6. Total Views and Likes by Platform


SELECT 
	SUM(views) AS total_views,
	SUM(likes) AS total_likes,
	most_played_on	
FROM Spotify
GROUP BY most_played_on;


7. Songs with High Popularity and Low Acousticness


SELECT 
	track,
	stream AS popu_track,
	acousticness AS low_aco_track
FROM Spotify
WHERE
	stream > (SELECT AVG(stream) FROM Spotify)  --- filter for above average popularity
	AND
	acousticness < (SELECT AVG(acousticness) FROM Spotify) --------filter for below average acousticness
ORDER BY 
	stream DESC,
	acousticness ASC;

	
8. Top 5 Most Lively Songs by Track

SELECT 
	track,
	liveness
FROM Spotify
ORDER BY liveness DESC
LIMIT 5;

9.  Who are the top 5 artists with the most songs?

SELECT
	artist,
	COUNT(track) AS top_5_artist_songs
FROM Spotify
GROUP BY artist
ORDER BY top_5_artist_songs DESC
LIMIT 5;




-- Advanced-level SQL queries (10)


1. Top 5 Artists by Total Stream Count for Official Videos


SELECT 
	artist,
	SUM(stream) AS total_stream
FROM Spotify
WHERE 
	official_video = TRUE
GROUP BY artist
ORDER BY total_stream DESC
LIMIT 5;


2. Songs with the Highest Difference Between Views and Likes


SELECT
	track,
	views,
	likes,
	(views - likes) AS difference
FROM spotify
ORDER BY 
	difference DESC
LIMIT 10;



3. Correlating Popularity(stream) and Danceability Across All Songs

					-------	USING WINDOW() Function
					-------- COrelation Formula

WITH Corelation_stat AS (
	SELECT 
		COUNT(track) AS n,  ------- n
		SUM(CAST(stream AS NUMERIC)) AS sum_stream, ----------- x
		SUM(CAST(danceability AS NUMERIC)) AS sum_dan, ---------------y
		SUM(CAST(stream AS NUMERIC) * CAST(danceability AS NUMERIC)) AS sum_stream_dan,  -------- x*y
		SUM(CAST(stream AS NUMERIC) * CAST(stream AS NUMERIC)) AS sum_stream_sq,  ----------------------x*x
		SUM(CAST(danceability AS NUMERIC) * CAST(danceability AS NUMERIC)) AS sum_dan_sq --------------------- y*y
	FROM Spotify
)
SELECT 
	(n * sum_stream_dan - sum_stream * sum_dan)/
	SQRT((n * sum_stream_sq - sum_stream * sum_stream) * (n* sum_dan_sq - sum_dan * sum_dan)) AS corelation
FROM Corelation_stat
WHERE
	n>1;
	
-----------------------USING CORR() Function
SELECT 
    CORR(stream, danceability) AS correlation
FROM Spotify
WHERE 
	stream IS NOT NULL 
	AND 
	danceability IS NOT NULL;




4. What are the most played tracks in specific channels (select top 10 channel)?

SELECT * FROM Spotify;

SELECT 
	channel,
	COUNT(track) AS most_played_tracks
FROM Spotify
GROUP BY channel
ORDER BY most_played_tracks DESC
LIMIT 10;


5. Cluster songs based on audio features (e.g., danceability, energy).


SELECT 
	track,
	danceability,
	energy
FROM Spotify
WHERE 
	danceability IS NOT NULL
	AND
	energy IS NOT NULL;






