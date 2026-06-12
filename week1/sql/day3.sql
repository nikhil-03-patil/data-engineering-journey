CREATE TABLE countries (
    country_code VARCHAR(2) PRIMARY KEY,
    country_name VARCHAR(50),
    continent    VARCHAR(20)
);

CREATE TABLE cities (
    city_id      SERIAL PRIMARY KEY,
    city_name    VARCHAR(50),
    country_code VARCHAR(2),
    category     VARCHAR(20),
    rating       DECIMAL(3,1),
    cost_per_day INT,
    visitors_m   DECIMAL(4,1)
);


-- Insert countries
INSERT INTO countries VALUES
('IN', 'India',    'Asia'),
('IT', 'Italy',    'Europe'),
('FR', 'France',   'Europe'),
('JP', 'Japan',    'Asia'),
('ES', 'Spain',    'Europe'),
('TH', 'Thailand', 'Asia'),
('US', 'USA',      'Americas');

-- Insert cities
INSERT INTO cities VALUES
(1,  'Mumbai',    'IN', 'Food',     4.1, 30,  20.7),
(2,  'Delhi',     'IN', 'History',  3.9, 25,  18.6),
(3,  'Rome',      'IT', 'History',  4.5, 120, 10.1),
(4,  'Milan',     'IT', 'Fashion',  4.2, 130,  8.2),
(5,  'Naples',    'IT', 'Food',     4.0, 90,   5.1),
(6,  'Florence',  'IT', 'History',  4.4, 115,  6.3),
(7,  'Paris',     'FR', 'Culture',  4.7, 150, 19.1),
(8,  'Lyon',      'FR', 'Food',     4.3, 100,  4.2),
(9,  'Tokyo',     'JP', 'Food',     4.8, 170, 14.0),
(10, 'Kyoto',     'JP', 'Culture',  4.6, 160,  8.5),
(11, 'Osaka',     'JP', 'Food',     4.7, 140, 11.2),
(12, 'Barcelona', 'ES', 'Culture',  4.6, 110, 12.0),
(13, 'Madrid',    'ES', 'Food',     4.3, 100,  9.9),
(14, 'Bangkok',   'TH', 'Food',     4.4, 45,  22.8),
(15, 'NYC',       'US', 'Culture',  4.5, 250, 13.6);


-- How many cities per country?
select country_code, count(*) as city_count
from cities
group by country_code;

-- Average rating per country
select country_code, round(avg(rating), 2) as avg_country_rating
from cities
group by country_code;

-- Multiple aggregations at once
select country_code,
count(*) as city_cnt,
round(avg(rating), 2) as avg_rating,
max(cost_per_day) as max_cost,
min(cost_per_day) as min_cost,
sum(visitors_m) as total_visitors
from cities
group by country_code
order by total_visitors desc;


-- WHERE: filter individual rows first, then group
-- Only consider cities with rating > 4.0, then count per country
select country_code, count(*) as city_count
from cities
where rating > 4.0
group by country_code;

-- HAVING: filter the groups themselves
-- Only show countries with more than 2 cities
select country_code, count(*) as city_count
from cities
group by country_code
having count(*) > 2;

-- Combine both WHERE and HAVING together
-- Countries with more than 1 high-rated city (rating > 4.2)
select country_code, count(*) as high_rated_cnt
from cities
where rating > 4.2
group by country_code
having count(*) > 1
order by high_rated_cnt desc;

-- INNER JOIN: cities with their country name
-- Only cities whose country_code exists in countries table
select c.city_name, c.rating, c.cost_per_day, co.country_name, co.continent
from cities c
inner join countries co on c.country_code = co.country_code
order by c.rating desc;
-- LEFT JOIN: all countries, even those with no cities
-- USA has cities, but what about a country with none?
select co.country_name,
count(c.city_id) as city_cnt
from countries co
left join cities c on co.country_code = c.country_code
group by co.country_name
order by city_cnt desc;


-- Practical join: cities in Europe only
select c.city_name, c.rating, co.continent
from cities c
inner join countries co on c.country_code = co.country_code
where co.continent = 'Europe'
order by c.rating desc;

-- Combining everything 
-- Average rating per continent (needs a join to get continent)
select 
co.continent,
count(c.city_id) as city_count,
round(avg(c.rating),2) as avg_rating,
round(avg(c.cost_per_day), 2) as avg_cost
from cities c
inner join countries co on c.country_code = co.country_code
group by co.continent
order by avg_rating desc;

-- show where Average rating is above 4.3 
select 
co.continent,
round(avg(c.rating),2) as avg_rating,
round(avg(c.cost_per_day), 2) as avg_cost
from cities c
inner join countries co on c.country_code = co.country_code
group by co.continent
having avg(c.rating) > 4.3
order by avg_rating desc;



-- Q1. Which category of city (Food, Culture, History, Fashion) has the highest average rating?
select category,
round(avg(rating), 2) as avg_rating
from cities
group by category
order by avg_rating desc;


--  List all continents and how many cities each has — but only show continents with more than 3 cities.
select co.continent,
count(c.city_id) as city_cnt
from cities c
inner join countries co on c.country_code = co.country_code
group by co.continent
having count(c.city_id) > 3
order by city_cnt desc;


-- Q3. Write a query that returns each city name, its country name, 
-- its continent, and its rating — for only Asian cities, sorted by rating highest first.
select 
c.city_name,
c.rating,
co.country_name,
co.continent
from cities c
inner join countries co on c.country_code = co.country_code
where co.continent = 'Asia'
order by c.rating desc;