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


-- 1. f. In the database, the number of persons who have acted in exactly one movie that they self directed is 603. How many persons have acted in more than one movie that they self directed?

select count(distinct i1.personId)
  from involved i1
    join involved i2 on i1.movieId = i2.movieId
    join person p1 on i2.personId = p1.id
    join person p2 on i1.personId = p2.id
  where i1.role = 'actor'
  and i2.role = 'director'
;

select count(*)
   from (
       select I1.personId, count(*)
       from involved I1
           join involved I2 on I1.movieId = I2.movieId and I1.personId = I2.personId
       where I1.role = 'actor'
         and I2.role = 'director'
       group by I1.personId
       having count(*) = 1
) X; -- test, result 603

select count(*)
  from (
    select i1.personId
    from involved i1
      join involved i2
        on i1.movieId = i2.movieId
        and i1.personId = i2.personId
    where i1.role = 'actor'
    and i2.role = 'director'
    group by i1.personId
    having count(*) > 1
) x
; -- result 345

-- 1. g. Of all the movies produced in 2002, there are 282 that have entries registered in involved for all roles defined in the roles relation. How many movies produced in 1999 have entries registered in involved for all roles defined in the roles relation? Note: This is a relational division query which must work for any schema; you can not use the fact that currently there are only 2 different roles.

select count(*)
  from (
    select M.id
    from movie M
      join involved I on M.id = I.movieId
    where M.year = 2002
    group by M.id
    having count(distinct I.role) = (
      select count(*)
from role R )
) X; -- test, result 282

select count(*) from (
    select m.id
    from movie m
      join involved i on m.id = i.movieId
      where m.year = 1999
      group by m.id
      having count(distinct i.role) = (
        select count(*) from role
      )
) x
; -- result 250


-- 1. h. The number of persons who have had some role in some movie from all genres from the category ‘Newsworthy’ is 156. How many persons have had some role in some movie from all genres from the category ‘Lame’?

select count(*)
   from (
       select P.id
       from person P
           join involved I on P.id = I.personId
           join movie M on I.movieId = M.ID
           join movie_genre MG on MG.movieId = M.id
           join genre G on MG.genre = G.genre
       where G.category  = 'Newsworthy'
       group by P.id
       having count(distinct G.genre) = (
           select count(*)
           from genre
           where category = 'Newsworthy'
) ) X; -- test, result 156

select count(*) from (
  select p.id from person p
    join involved i on p.id = i.personId
    join movie m on i.movieId = m.id
    join movie_genre mg on mg.movieId = m.id
    join genre g on mg.genre = g.genre
  where g.category = 'Lame'
  group by p.id
  having count(distinct g.genre) = (
    select count(*) from genre
      where category = 'Lame'
  )
) x; -- result 1
