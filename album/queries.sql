-- select all albums that have tracks wih duration smaller than 90: search in results of other query
select * from album where id in (
  select distinct album_id from track
  where duration <= 90
);

-- select all album names by what artists, sequence, title and secs whose track duration is less than 90s
SELECT a.title AS album, a.artist, t.track_number AS seq, t.title, t.duration AS secs
  FROM album AS a
  JOIN track AS t
    ON t.album_id = a.id
  WHERE a.id IN (SELECT DISTINCT album_id FROM track WHERE duration <= 90)
  ORDER BY a.title, t.track_number
;


--
select a.id, a.title as album, a.artist, t.track_number as seq, t.title, t.duration as secs
  from album as a
  join (
    select album_id, track_number, duration, title
    from track
    where duration <= 90
  ) as t
  on t.album_id = a.id
  order by a.title, t.track_number
;
