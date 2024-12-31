CREATE TABLE olympics_history
(
id INT,
name VARCHAR,
sex VARCHAR,
age VARCHAR,
height VARCHAR,
weight VARCHAR,
team VARCHAR,
noc VARCHAR,
games VARCHAR,
year INT,
season VARCHAR,
city VARCHAR,
sport VARCHAR,
event VARCHAR,
medal VARCHAR
);

CREATE TABLE olympics_history_noc
(
noc VARCHAR,
region VARCHAR,
notes VARCHAR
);


SELECT * FROM olympics_history
SELECT * FROM olympics_history_noc

-- 1 Write a SQL query to find the total no of Olympic Games held as per the dataset.

SELECT COUNT(distinct games) as total_olympic_games FROM olympics_history

-- 2. List down all Olympics games held so far.

SELECT DISTINCT oh.year,oh.season,oh.city
FROM olympics_history oh
ORDER BY year

--3 Mention the total no of nations who participated in each olympics game?

 with all_countries as
        (select games, nr.region
        from olympics_history oh
        join olympics_history_noc nr ON nr.noc = oh.noc
        group by games, nr.region)
    select games, count(1) as total_countries
    from all_countries
    group by games
    order by games;

SELECT * FROM olympics_history

-- 4. Which year saw the highest and lowest no of countries participating in olympics
with all_countries as
              (select games, nr.region
              from olympics_history oh
              join olympics_history_noc nr ON nr.noc=oh.noc
              group by games, nr.region),
          tot_countries as
              (select games, count(1) as total_countries
              from all_countries
              group by games)
      select distinct
      concat(first_value(games) over(order by total_countries)
      , ' - '
      , first_value(total_countries) over(order by total_countries)) as Lowest_Countries,
      concat(first_value(games) over(order by total_countries desc)
      , ' - '
      , first_value(total_countries) over(order by total_countries desc)) as Highest_Countries
      from tot_countries
      order by 1;
-- 5 Which nation has participated in all of the olympic games
with tot_games as
              (select count(distinct games) as total_games
              from olympics_history),
          countries as
              (select games, nr.region as country
              from olympics_history oh
              join olympics_history_noc nr ON nr.noc=oh.noc
              group by games, nr.region),
          countries_participated as
              (select country, count(1) as total_participated_games
              from countries
              group by country)
      select cp.*
      from countries_participated cp
      join tot_games tg on tg.total_games = cp.total_participated_games
      order by 1;

--6. Identify the sport which was played in all summer olympics.

WITH t1 as
(select count(distinct games) as total_summer_games
from olympics_history
where season = 'Summer'),
t2 as
(select distinct sport,games
from olympics_history
where season = 'Summer' order by games),
t3 as
(select sport,count(games) as no_of_games
from t2
group by sport)
select * from t3 JOIN t1 ON t1.total_summer_games=t3.no_of_games;

-- 7. Which Sports were just played only once in the olympics.
SELECT * FROM olympics_history
with t1 as
(select distinct games,sport from olympics_history),
t2 as 
(select sport,count(1) as no_of_games 
from t1 group by sport)
 select t2.*, t1.games
      from t2
      join t1 on t1.sport = t2.sport
      where t2.no_of_games = 1
      order by t1.sport;

-- 8. Fetch the total no of sports played in each olympic games.
WITH t1 as 
(SELECT distinct games,sport from olympics_history),
t2 as
(SELECT games,COUNT(1) as no_of_sports from t1 group by games)
select * from t2 order by no_of_sports desc

-- 9. Fetch oldest athletes to win a gold medal
    with temp as
            (select name,sex,cast(case when age = 'NA' then '0' else age end as int) as age
              ,team,games,city,sport, event, medal
            from olympics_history),
        ranking as
            (select *, rank() over(order by age desc) as rnk
            from temp
            where medal='Gold')
    select *
    from ranking
    where rnk = 1;
