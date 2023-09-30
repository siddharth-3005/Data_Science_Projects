create database project;
-- 1. List all the tracks released in 2023.
select * from spotify_data where released_year = 2023;

-- 2. Find the track with the highest number of streams.
select track_name,streams from spotify_data where streams = (select max(streams) from spotify_data);

-- 3. Calculate the average danceability percentage for all tracks.
select avg(`danceability_%`) from spotify_data;

-- 4. List the top 5 tracks with the highest energy percentage, ordered by energy percentage in descending order.
select track_name from 
(select track_name, `energy_%`, dense_rank()over(order by `energy_%` desc) rnk from spotify_data order by `energy_%` desc)t
where rnk in (1,2,3,4,5);

-- 5. Find the average number of streams for tracks released in 2023.
select avg(streams) from spotify_data where released_year = 2023;

-- 6. Determine the total number of tracks in major keys (e.g., "A Major," "B Major") and minor keys (e.g., "C# Minor," "F Minor").
select track_name,concat(`key`,' ', `mode`) as song_key from spotify_data where `mode` = 'Major';
select track_name,concat(`key`,' ', `mode`) as song_key from spotify_data where `mode` = 'Minor';

-- 7. Find the track with the longest title (i.e., the maximum character count in the track_name column).

select track_name,length(track_name) as len from spotify_data where length(track_name) = 
(select length(track_name) from spotify_data order by length(track_name) desc limit 1); 

-- 8. Calculate the total number of streams for tracks released in each month of 2023, ordered by the release month.
select released_month,sum(streams) from spotify_data where released_year = 2023 group by released_month order by released_month;

-- 9. List all the artists who have more than one track in the dataset, along with the count of tracks they have.
select count(track_name), `artist(s)_name` from spotify_data 
group by `artist(s)_name` having count(track_name)>1 order by count(track_name) desc;

-- 10. Find the track with the highest valence percentage and the artist(s) who performed it.
select track_name,`artist(s)_name`,`valence_%` from spotify_data 
where `valence_%` = (select max(`valence_%`) from spotify_data);

-- 11. Calculate the average speechiness percentage for tracks that are in the lowest and highest number of spotify playlist
select track_name,`speechiness_%` ,in_spotify_playlists from spotify_data
where in_spotify_playlists = (select min(in_spotify_playlists) from spotify_data) or 
in_spotify_playlists = (select max(in_spotify_playlists) from spotify_data);

-- 12. Find the track with the lowest acousticness percentage and the artist(s) who performed it.
select track_name from spotify_data where `acousticness_%` = (select min(`acousticness_%`) from spotify_data );

-- 13. Calculate the total number of streams for each artist and display the results in descending order of total streams.
select `artist(s)_name`, sum(streams) from spotify_data group by `artist(s)_name` order by sum(streams) desc; 

-- 14. Determine the most common key among the tracks (i.e., the key that appears most frequently)

select `key`from spotify_data 
where `key` = (select `key` from spotify_data group by `key` order by count(`key`) desc limit 1)
group by `key`;

-- 15. Find the average streams for each category of artist count order by average stream count
select artist_count,avg(streams) from spotify_data group by artist_count order by avg(streams) desc;

-- 16. Find the top 3 artists who have the highest average valence percentage across all their tracks.
select `artist(s)_name` from 
(select `artist(s)_name`,avg(`valence_%`),
dense_rank()over(order by avg(`valence_%`) desc) as rnk from spotify_data group by`artist(s)_name` order by avg(`valence_%`) desc)t
where rnk in (1,2,3);

-- 17. Calculate the average danceability percentage for tracks released in 2023, but exclude tracks that have a valence percentage below 50.
select avg(`danceability_%`) from spotify_data where released_year = 2023 and `valence_%`>50;

-- 18. Identify the artist(s) with the most tracks in the dataset who have not appeared in Spotify playlists, and list their track count.
select distinct(`artist(s)_name`) from
(select `artist(s)_name`, count_track,dense_rank()over(order by count_track desc) as rnk from
(select `artist(s)_name` ,count(track_name)over(partition by `artist(s)_name`) as count_track from spotify_data
where in_spotify_charts = 0)t)t1
where rnk = 1;

-- 19. Find the track with the highest number of streams released in 2023 that is not in a major key (e.g., A Major, B Major).
select * from 
(select track_name, streams,dense_rank()over(order by streams desc) as rnk from 
(select track_name,streams from spotify_data where released_year = 2023 and `mode` = 'Minor' order by streams desc)t)t1
where rnk = 1;

-- 20.Calculate the average energy percentage for tracks released in the first half of each year in the dataset (e.g., 2019-2023), and present the results by year.
select released_year,avg(energy) from 
(select released_year,released_month ,avg(`energy_%`) as energy from spotify_data 
where released_month in (1,2,3,4,5,6) group by released_year,released_month)t
group by released_year;

-- 21. Determine the total number of tracks for each artist that have a danceability percentage above the average danceability percentage of all tracks in the dataset.
select `artist(s)_name`,count(track_name) from spotify_data where `danceability_%` > (select avg(`danceability_%`) from spotify_data)
group by `artist(s)_name`;

-- 22. Identify the track(s) with the highest speechiness percentage in each month of 2023, ordered by release month.
select * from 
(select released_month,count(track_name)over(partition by released_month),
dense_rank()over(partition by released_month order by speechiness desc) as rnk from 
(select track_name,released_month,`speechiness_%`as speechiness from spotify_data where released_year = 2023)t)t1
where rnk = 1;

-- 23. Find the artist(s) with the highest total streams for tracks that have a mode of 'Minor'.
select * from 
(select`artist(s)_name`,dense_rank()over(order by total desc) rnk from
(select `artist(s)_name`,sum(streams) as total from spotify_data where `mode` = 'Minor' group by `artist(s)_name`)t)t1
where rnk =1;

-- 24. Calculate the total number of streams for tracks in each key, but consider tracks with a duration less than 3 minutes as outliers and exclude them from the calculation.
select sum(streams),`key` from spotify_data  group by `key` order by sum(streams) desc;

-- 25.List the tracks that have a danceability percentage higher than the average danceability percentage 
-- for all tracks by artists who have more than 3 tracks in the dataset.
select track_name from spotify_data where `danceability_%` > (select avg(`danceability_%`) from spotify_data) and `artist(s)_name`=any
(select `artist(s)_name` from spotify_data group by `artist(s)_name` having count(track_name)>2);

-- 26. Identify the artist(s) with the highest variance in valence percentage across their tracks, and display the variance value.
select * from 
(select `artist(s)_name`,dense_rank()over(order by (max_var - min_var) desc) as rnk from
(select `artist(s)_name`,min(`valence_%`) as min_var,max(`valence_%`) as max_var from spotify_data group by `artist(s)_name`)t)t1
where rnk =1;

-- 27. Calculate the average streams per day for tracks released in 2023, and compare this to the 
-- average streams per day for tracks released in 2019, 2020, 2021, and 2022.
select released_day,avg(streams) from spotify_data where released_year = 2023 group by released_day order by released_day;
select released_day,avg(streams) from spotify_data where released_year = 2019 group by released_day order by released_day;
select released_day,avg(streams) from spotify_data where released_year = 2020 group by released_day order by released_day;
select released_day,avg(streams) from spotify_data where released_year = 2021 group by released_day order by released_day;
select released_day,avg(streams) from spotify_data where released_year = 2022 group by released_day order by released_day;
