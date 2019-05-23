-- 1. a. The person relation contains 573 entries with a registered height greater than 190
centimetres. How many entries do not have a registered height?

select count(*) from person where height > 190; -- test

select count(*) from person where height is null; -- result: 47315

-- 1. b. In the database, there are 365 movies where the average height of all people involved is less than 165 centimetres (ignoring people where the height is not registered). For how many movies is the average height of all people involved greater than 190 centimetres?

select * from person
group by id having avg(height) < 165;

select distinct i.movieId, p.name
from involved i right join person p
having avg(p.height) < 165
on i.personId = p.id
;
