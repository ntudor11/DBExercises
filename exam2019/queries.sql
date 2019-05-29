-- 1. a. In Denmark, there are 2 registered airports. How many airports are registered in Germany?

select count(*) from airport
  where country = 'DK'; -- test, result 2

select count(*) from airport
  where country = 'DE'; -- result 17

-- 1. b. In Asia, there are 57 airports that have both departing and arriving flights. How many airports are in Europe have both departing and arriving flights?

select count(*) from (
  select distinct a.airport, c.region
    from airport a
    join country c on c.country = a.country
    join flights f1 on f1.DEP = a.airport
    join flights f2 on f2.ARR = a.airport
    where region = 'AS'
) x; -- test, result 57

select count(*) from (
  select distinct a.airport, c.region
    from airport a
    join country c on c.country = a.country
    join flights f1 on f1.DEP = a.airport
    join flights f2 on f2.ARR = a.airport
    where region = 'EU'
) x; -- test, result 185

-- 1. c. The average number of days that a flight route has been running is 42.77. For how many days has the longest running flight route been running?

select avg(DATEDIFF(end_op, start_op))
  from flights; -- test, result 42.77(64) - ONLY INCLUDE 2 decimals!!

select max(DATEDIFF(end_op, start_op))
  from flights; -- result 1572

-- 1. d. There are 6126 flights that a) depart from an airport within Europe and b) have an aircraft capacity of more than 300 passengers. How many flights with more capacity than 300 passengers depart from an airport within Asia?

select count(*) from (
  select f.dep, a.capacity
  from flights f
  join aircraft a on a.actype = f.actype
  join airport air on air.airport = f.dep
  join country c on c.country = air.country
  where a.capacity > 300
  and c.region = 'EU'
) x; -- test, result 6126

select count(*) from (
  select f.dep, a.capacity
  from flights f
  join aircraft a on a.actype = f.actype
  join airport air on air.airport = f.dep
  join country c on c.country = air.country
  where a.capacity > 300
  and c.region = 'AS'
) x; -- result 185

-- 1. e. Each aircraft has a registered aircraft group (aircraft.ag). The smallest such aircraft group has 2 members. How many members does the largest group have?
-- Hint: Using a view can simplify the query significantly. If you do, include the view creation statement in your answer.

select count(*)
  from aircraft
  group by ag
  order by count(ag) asc
  limit 1; -- test, result 2

select count(*)
  from aircraft
  group by ag
  order by count(ag) desc
  limit 1; -- result 24

-- 1. f. According to the flights relation, there are 124 airports with more departing flights than arriving flights. How many airports have more arriving flights than departing flights?

select count(*) from (
  select a.airport
  from airport a
  join flights f1 on f1.dep = a.airport
  join flights f2 on f2.arr = a.airport
  group by a.airport
  having count(f1.arr) > count(f2.dep)
) x; -- TODO LATER


select count(*) from (
  select a.airport
  from airport a
  join flights f1 on f1.dep = a.airport
  join flights f2 on f2.arr = a.airport
  group by a.airport
  having count(f1.arr) > count(f2.dep)
) x; -- result 0 ???

-- 1. g. How many freight flights (ag = ’F’) land in a different country from where they departed, but in the same region?

select count(*) from (
  select distinct f.id, c1.region as 'DEP', c2.region as 'ARR'
    from flights f
    join aircraft a on f.actype = a.actype
    join airport air1 on air1.airport = f.dep
    join airport air2 on air2.airport = f.arr
    join country c1 on c1.country = air1.country
    join country c2 on c2.country = air2.country
    where a.ag = 'F'
    and c1.region = c2.region
    order by c1.region
) x; -- result 602


-- 1. h. Only 1 airline has flights departing from every registered airport in Denmark. How many airlines have flights departing from every registered airport in the Netherlands?

select count(*) from (
  select distinct f.al, f.dep
    from flights f
    join airport a on a.airport = f.dep
    where a.country = 'DK'
    group by f.al, f.dep
    having count(distinct f.dep) = (
      select count(*)
        from country c, flights f
        where c.country = 'DK'
    )
) x;

select count(*) from (
  select distinct f.al, f.dep
    from flights f
    join airport a on a.airport = f.dep
    where a.country = 'NL'
    group by f.al, f.dep having count(*) >1
) x; -- TODO that's what I got in


select count(distinct al) from (
  select distinct f.al, f.dep
    from flights f
    join airport a on a.airport = f.dep
    where a.country = 'NL'
    and f.al = 'LH'
    group by f.al, f.dep having count(*) >1
) x;

select distinct f.al, f.dep
  from flights f
  join airport a on a.airport = f.dep
    where a.country = 'DK'
    group by f.al, f.dep
    having count(distinct f.dep) = (
    select count(*)
    from country c
    where c.country = 'DK'
  ); -- TODO later

  select count(distinct al) from (
  select distinct f.al, f.dep
    from flights f
    join airport a on a.airport = f.dep
    where a.country = 'NL'
    and f.al = 'LH'
    group by f.al, f.dep having count(*) >1
) x;

-- the nested query from above shows that 'LH' is the only airline that has flights departing from all the airports in the Netherlands ('NL').



  -- The CAP Theorem is irrelevant for single server relational sytems, since the theorem is mostly aimed at distributed systems. Furthermore, consistency is only maintained at a transaction level in a DBMS, while in a distributed system, consistency is measured from anywhere within the system.
