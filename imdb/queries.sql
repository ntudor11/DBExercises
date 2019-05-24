-- 1. a. The person relation contains 573 entries with a registered height greater than 190
centimetres. How many entries do not have a registered height?

select count(*) from person where height > 190; -- test

select count(*) from person where height is null; -- result: 47315

-- 1. b. In the database, there are 365 movies where the average height of all people involved is less than 165 centimetres (ignoring people where the height is not registered). For how many movies is the average height of all people involved greater than 190 centimetres?

select count(*) from (
  select movieId, avg(P.height)
    from Involved I
       join person P on I.personId = P.ID
    group by I.movieId
    having avg(P.height) < 165
  ) X; -- test

select count(*) from (
  select movieId, avg(p.height)
    from involved i
      join person as p
      on i.personId = p.id
    group by i.movieId
    having avg(p.height) > 190
) x; -- result 190

-- 1. c. The movie genre relation does not have a primary key, which can lead to a movie having more than one entry with the same genre. How many movies in movie genre have such duplicate entries?

select count(*) from
  (select movieId from movie_genre
  group by movieId
  having count(distinct genre) <> count(*)
  )
; -- 143

-- According to the information in the database, 476 different persons acted in movies directed by ‘Francis Ford Coppola’. How many different persons acted in movies directed by ‘Steven Spielberg’?

select count(distinct i1.personId)
 from involved i1
     join involved i2 on i1.movieId = i2.movieId
     join person p on i2.personId = p.id
 where i1.role = 'actor'
   and i2.role = 'director'
   and p.name = 'Francis Ford Coppola'
; -- test / result - 476

select count(distinct i1.personId)
  from involved i1
    join involved i2 on i1.movieId = i2.movieId
    join person p on i2.personId = p.id
  where i1.role = 'actor'
  and i2.role = 'director'
  and p.name = 'Steven Spielberg'
; -- result 2219

-- 1. e. Of all the movies produced in 2002, there are 12 that have no registered entry in involved. How many movies produced in 1999 have no registered entry in involved?

select count(*)
  from movie m
  where m.year = 2002
  and m.id not in (
    select i.movieId
    from involved i
  )
; -- test; result 12

select count(*)
  from movie m
  where m.year = 1999
  and m.id not in (
    select i.movieId
    from involved i
  )
; -- result 7
