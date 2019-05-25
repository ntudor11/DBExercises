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
