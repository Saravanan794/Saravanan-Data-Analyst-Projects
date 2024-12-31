CREATE TABLE alex (
    id INT PRIMARY KEY,
    title_name VARCHAR(255),
    publishing_date DATE,
    views INT,
    comments INT,
    likes INT,
    month INT,
    year INT,
    yearmonth VARCHAR(7)
);

SELECT * FROM alex
WHERE title_name LIKE '%SQL%'


SELECT * FROM alex
ORDER BY views DESC
LIMIT 1

SELECT *,(likes/views) as likesratio
FROM alex
ORDER BY likesratio DESC
LIMIT 3 

SELECT DISTINCT yearmonth
FROM alex

SELECT  case when title_name like '%ython%' then 'Python'
 when title_name like '%SQL%' then 'SQL'
 when title_name like '%ablea%' then 'Tableau'
 when title_name like '%xcel%' then 'Excel'
 when title_name like '%ower%' then 'Power BI'
else 'other' end as type,count(*)
 FROM `sqlcsv.youtubeproject.Alexdata`
group by type


SELECT  yearmonth,count(*)
 FROM `sqlcsv.youtubeproject.Alexdata`
group by yearmonth
order by count(*) desc


SELECT  yearmonth,sum(views)
 FROM `sqlcsv.youtubeproject.Alexdata`
group by yearmonth
having sum(views)>1000000
order by yearmonth


with final as (
SELECT  yearmonth,sum(views) as totalviews
 FROM `sqlcsv.youtubeproject.Alexdata`
where year=2020 and month in (10,11)
group by yearmonth
order by yearmonth desc)
select yearmonth, totalviews,lag(totalviews) over (order by yearmonth desc)
from final
