-- ── DIMENSION TABLES ──────────────────────────────────

CREATE TABLE users (
    user_id     SERIAL PRIMARY KEY,
    email       VARCHAR(100) NOT NULL UNIQUE,
    name        VARCHAR(100),
    created_at  TIMESTAMP DEFAULT NOW(),
    is_active   BOOLEAN DEFAULT TRUE
);

CREATE TABLE categories (
    category_id   SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE  -- Food, Culture, History, etc.
);

CREATE TABLE places (
    place_id      SERIAL PRIMARY KEY,
    place_name    VARCHAR(200) NOT NULL,
    city          VARCHAR(100),
    country       VARCHAR(100),
    latitude      DECIMAL(9,6),
    longitude     DECIMAL(9,6),
    category_id   INT REFERENCES categories(category_id),
    avg_rating    DECIMAL(3,1),
    created_at    TIMESTAMP DEFAULT NOW()
);

CREATE TABLE content_sources (
    source_id     SERIAL PRIMARY KEY,
    url           TEXT NOT NULL UNIQUE,
    source_type   VARCHAR(20) CHECK (source_type IN ('reel', 'youtube', 'blog', 'manual')),
    parsed_at     TIMESTAMP,
    parse_status  VARCHAR(20) DEFAULT 'pending'
                  CHECK (parse_status IN ('pending', 'success', 'failed')),
    raw_content   TEXT,        -- original scraped text
    created_at    TIMESTAMP DEFAULT NOW()
);

-- ── FACT TABLES ───────────────────────────────────────

CREATE TABLE extracted_places (
    extraction_id  SERIAL PRIMARY KEY,
    source_id      INT REFERENCES content_sources(source_id),
    place_id       INT REFERENCES places(place_id),
    confidence     DECIMAL(3,2),  -- LLM confidence score 0.00-1.00
    extracted_at   TIMESTAMP DEFAULT NOW()
);

CREATE TABLE itineraries (
    itinerary_id   SERIAL PRIMARY KEY,
    user_id        INT REFERENCES users(user_id),
    title          VARCHAR(200),
    destination    VARCHAR(100),
    created_at     TIMESTAMP DEFAULT NOW(),
    is_public      BOOLEAN DEFAULT FALSE
);

CREATE TABLE saved_places (
    save_id        SERIAL PRIMARY KEY,
    user_id        INT REFERENCES users(user_id),
    place_id       INT REFERENCES places(place_id),
    itinerary_id   INT REFERENCES itineraries(itinerary_id),
    saved_at       TIMESTAMP DEFAULT NOW(),
    notes          TEXT
);

-- ── EVENT / ANALYTICS TABLES ──────────────────────────
-- These power EightyDays' product analytics

CREATE TABLE user_events (
    event_id      SERIAL PRIMARY KEY,
    user_id       INT REFERENCES users(user_id),
    event_type    VARCHAR(50),  -- 'view_place','save_place','share_itinerary'
    place_id      INT REFERENCES places(place_id),
    itinerary_id  INT REFERENCES itineraries(itinerary_id),
    occurred_at   TIMESTAMP DEFAULT NOW(),
    metadata      JSONB        -- flexible: device, session_id, etc.
);


-- Exercise 2 — Insert sample data (20 mins)
INSERT INTO categories (category_name) VALUES
('Food'), ('Culture'), ('History'), ('Fashion'), ('Nature');

INSERT INTO users (email, name) VALUES
('rahul@gmail.com', 'Rahul'),
('priya@gmail.com', 'Priya'),
('alex@gmail.com', 'Alex');

INSERT INTO places (place_name, city, country, latitude, longitude, category_id, avg_rating) VALUES
('Tsukiji Fish Market', 'Tokyo', 'Japan', 35.6654, 139.7707, 1, 4.7),
('Colosseum', 'Rome', 'Italy', 41.8902, 12.4922, 3, 4.8),
('Sagrada Familia', 'Barcelona', 'Spain', 41.4036, 2.1744, 2, 4.9),
('Le Marais', 'Paris', 'France', 48.8566, 2.3522, 2, 4.5),
('street food tour', 'Bangkok', 'Thailand', 13.7563, 100.5018, 1, 4.6);

INSERT INTO content_sources (url, source_type, parse_status) VALUES
('https://instagram.com/reel/abc123', 'reel', 'success'),
('https://youtube.com/watch?v=xyz789', 'youtube', 'success'),
('https://travelblog.com/tokyo-guide', 'blog', 'pending');

INSERT INTO itineraries (user_id, title, destination) VALUES
(1, 'Tokyo Food Trip', 'Tokyo'),
(2, 'Europe Culture Tour', 'Europe');


INSERT INTO saved_places (user_id, place_id, itinerary_id) VALUES
(1, 1, 1),
(2, 2, 2),
(2, 3, 2),
(3, 4, NULL),
(1, 5, 1);


-- Q1. List all places with their category name. (JOIN places + categories)
select p.place_name, p.city, c.category_name
from places p
inner join categories c on p.category_id = c.category_id;


-- Q2. How many places has each user saved? Show user name + count, sorted highest first.
select u.name,
count(s.place_id) as savedCnt
from users u
inner join saved_places s on u.user_id = s.user_id
group by u.name
order by savedCnt desc;

-- Q3. Which itinerary has the most saved places? Show itinerary title + count.
select i.title,
count(s.itinerary_id) as itineraryCnt
from itineraries i
inner join saved_places s on i.itinerary_id = s.itinerary_id
group by i.title
order by itineraryCnt desc
LIMIT 1;

-- Q4. List all content sources that are still 'pending' parse status.
select * from content_sources 
where parse_status = 'pending';

-- Q5 — For each category, show how many places exist and the average rating. 
--Only show categories that have at least 1 place.
select c.category_name,
avg(p.avg_rating) as avg_rating,
count(p.place_id) as total_places
from places p
inner join categories c on p.category_id = c.category_id
group by c.category_name;