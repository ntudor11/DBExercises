-- 2. a.  372 songs in the database have a duration of at most 1 minute. How many songs have a duration of over 1 hour?

select count(*) from songs
  where time_to_sec(duration) <= 60; -- test, result 372

select count(*) from songs
  where time_to_sec(duration) > 3600; -- result 2

-- 2. b. What is the total duration, in seconds, of all songs in the database?

select sum(time_to_sec(duration)) from songs; -- result 15114

-- 2. c. The database contains just 5 songs released in 1953. What is the largest number of songs released in a single year?

select count(*) from songs
  where year(Releasedate) = 1953; -- test, result 5

select max(c) from (
  select count(*) c
  from songs
  group by year(Releasedate)
) x; -- result 833

-- 2. d. The database contains 12 albums by the artist Queen. How many albums by the artist Tom Waits are in the database?

select count(*) from (
  select aa.AlbumId, art.Artist from AlbumArtists aa
    join artists art on art.ArtistId = aa.ArtistId
    where art.Artist = 'Queen'
) x; -- test, result 12

select count(*) from (
  select aa.AlbumId, art.Artist from AlbumArtists aa
    join artists art on art.ArtistId = aa.ArtistId
    where art.Artist = 'Tom Waits'
) x; -- result 24

-- 2. e. The database contains 187 different albums with a genre whose name starts with Ele (for example, some of these have the genre Electronica). How many different albums have a genre whose name starts with Alt?

select count(distinct AlbumId) from (
  select ag.AlbumId, g.Genre from AlbumGenres ag
   join Genres g on g.GenreId = ag.GenreId
   where g.Genre like 'Ele%'
) x; -- test, result 187

select count(distinct AlbumId) from (
  select ag.AlbumId, g.Genre from AlbumGenres ag
    join Genres g on g.GenreId = ag.GenreId
    where g.Genre like 'Alt%'
) x; -- result 421

-- 2. f. For how many songs does there exist another different song in the database with the same title?

select count(distinct s1.songId)
  from Songs s1, Songs s2
  where s1.title=s2.title
  and s1.songId<>s2.songId; -- result 2313

  -- 2. g. The average number of albumIds per genreId in albumGenres is 26.5246. An album can have multiple genres. What is the average number of genreIds per albumId?

select count(*)/count(distinct GenreId) from AlbumGenres; -- test, result 26.5246

select count(*)/count(distinct albumId) from AlbumGenres; -- result 1.1994

-- 2. h. An album can have multiple genres. There are 1215 albums in the database that do not have the genre Rock. How many albums do not have the genre HipHop?

select count(*) from Albums
  where albumId not in (
    select albumId from albumGenres a, Genres g
    where g.genreId = a.genreId
    and g.genre = 'Rock'
); -- test, result 1215

select count(*) from Albums
  where AlbumId not in (
    select albumId from albumGenres a, Genres g
    where a.GenreId = g.GenreId
    and g.Genre = 'HipHop'
); -- result 1278
