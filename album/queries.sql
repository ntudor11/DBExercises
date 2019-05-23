-- select all albums that have tracks wih duration smaller than 90: search in results of other query
select * from album where id in (
  select distinct album_id from track
  where duration <= 90
);

-- select all album names by what artists, sequence, title and secs with all the tracks within the albums
SELECT a.title AS album, a.artist, t.track_number AS seq, t.title, t.duration AS secs
  FROM album AS a
  JOIN track AS t
    ON t.album_id = a.id
  WHERE a.id IN (SELECT DISTINCT album_id FROM track WHERE duration <= 90)
  ORDER BY a.title, t.track_number
;

-- select all album names by what artists, sequence, title and secs whose track duration is less than 90s: join query instead
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

-- create view
create view trackView as
  select id, album_id, title, track_number, duration DIV 60 as m, duration MOD 60 as s from track
;


-- select from a view
select a.title as album, a.artist, t.track_number as seq, t.title, t.m, t.s
  from album as a
  join trackView as t
    on t.album_id = a.id
  order by a.title, t.track_number
;

create view joinedAlbum as
  SELECT a.artist AS artist,
      a.title AS album,
      t.title AS track,
      t.track_number AS trackno,
      t.duration DIV 60 AS m,
      t.duration MOD 60 AS s
    FROM track AS t
    JOIN album AS a
      ON a.id = t.album_id
;

SELECT artist, album, track, trackno,
  CONCAT_WS(':', m, LPAD(s, 2, '0')) AS duration
  FROM joinedAlbum
  where artist = 'Jimi Hendrix'
;
