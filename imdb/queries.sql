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
