-- 1. a. Of all the players, 93 have an email address with gmail.com. How many have an email address with yahoo.dk?

select count(*) from player
  where email like '%gmail.com'; -- test, result 93

select count(*) from player
  where email like '%yahoo.dk'; -- result 87


-- 1. b. The Score relation contains 403 entries with a score smaller than 1000. How many entries have a score that is lower than the average score of all entries in the relation?

select count(*) from Score
  where score < 1000; -- test, result 403

select count(*) from Score
  where score < (select avg(score) from Score); -- result 967

-- 1. c. The database does not have foreign keys defined, which can lead to data errors. How many entries in PlayerAchievement refer to an achievement that does not exist?

select count(*) from (
  select pa.AchievementId, a.id from PlayerAchievement pa
  left join Achievement a on pa.AchievementId = a.id
    where a.id is null
) x; -- result 2


-- 1. d. Only 5 distinct players have both a registered score and a registered achievement in some game produced by “Electronix Arts”. How many distinct players have both a registered score and a registered achievement in some game produced by “Codemasters”?

select count(distinct PA.playerId)
  from PlayerAchievement PA
    join Achievement A on PA.achievementId = A.id
    join Game G on A.gameId = G.id
    join Score S on PA.playerId = S.playerId and S.gameId = G.id
  where G.producer = 'Electronix Arts'; -- test, result 5

select count(distinct pa.playerId)
  from PlayerAchievement pa
    join Achievement a on pa.achievementId = a.id
    join Game g on a.gameId = g.id
    join Score s on pa.playerId = s.playerId and s.gameId = g.id
  where g.producer = 'Codemasters'; -- result 6

-- 1. e. The number of distinct players who have a registered score in some game, but no registered achievement in that same game, is 493. How many distinct players have a registered achievement in some game, but no registered score in that game?

select count(distinct pa.playerId)
  from PlayerAchievement pa
    join Achievement a on pa.achievementId = a.id
  where not exists (
    select * from Score s
      where pa.playerId = s.playerId
      and a.gameId = s.gameId
  ); -- result 486

-- OR:

select count(distinct playerId)
from PlayerAchievement PA
    join Achievement A on PA.achievementId = A.id
where Pa.playerId not in (
    select S.playerId
    from Score S
    where A.gameId = S.gameId
);

-- 1. f. One player has played all the games named “Bioforge”. How many players have played all the games named “Project Eden”?

select count(*) from (
  select distinct s.playerId, g.name
  from Score s
    join Game g on s.gameId = g.id
    where g.name = "Bioforge"
  group by s.playerId
  having count(s.playerId) > 1) x; -- test, result 1


select count(*) from (
  select distinct s.playerId, g.name
  from Score s
    join Game g on s.gameId = g.id
    where g.name = "Project Eden"
    group by s.playerId
    having count(s.playerId) > 1) x; -- result 2

-- 1. g. One game name is used by three different producers. How many game names are used by two different producers?

select count(*) from (
  select g.name
  from Game g
  group by g.name
  having count(g.producer) = 3
) x; -- test, result 1

select count(*) from (
  select g.name
  from Game g
  group by g.name
  having count(g.producer) = 2
) x; -- result 7
