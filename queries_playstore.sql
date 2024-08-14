-- 1. Find the app with an ID of 1880
SELECT * 
FROM analytics 
WHERE id = 1880;

-- 2. Find the ID and app name for all apps updated on August 01, 2018
SELECT id, app_name
FROM analytics
WHERE last_updated = '2018-08-01';

-- 3. Count the number of apps in each category
SELECT category, COUNT(*) AS app_count
FROM analytics
GROUP BY category;

-- 4. Find the top 5 most-reviewed apps and the number of reviews
SELECT app_name, reviews
FROM analytics
ORDER BY reviews DESC
LIMIT 5;

-- 5. Find the app with the most reviews and a rating >= 4.8
SELECT app_name, reviews
FROM analytics
WHERE rating >= 4.8
ORDER BY reviews DESC
LIMIT 1;

-- 6. Find the average rating for each category, ordered from highest to lowest
SELECT category, AVG(rating) AS average_rating
FROM analytics
GROUP BY category
ORDER BY average_rating DESC;

-- 7. Find the name, price, and rating of the most expensive app with a rating < 3
SELECT app_name, price, rating
FROM analytics
WHERE rating < 3
ORDER BY price DESC
LIMIT 1;

-- 8. Find all apps with min installs <= 50, ordered by highest rating
SELECT app_name, rating
FROM analytics
WHERE min_installs <= 50000
ORDER BY rating DESC;

-- 9. Find names of all apps rated < 3 with at least 10,000 reviews
SELECT app_name
FROM analytics
WHERE rating < 3 AND reviews >= 10000;

-- 10. Find the top 10 most-reviewed apps that cost between $0.10 and $1.00
SELECT app_name, reviews
FROM analytics
WHERE price BETWEEN 0.10 AND 1.00
ORDER BY reviews DESC
LIMIT 10;

-- 11. Find the most out-of-date app
SELECT app_name, last_updated
FROM analytics
ORDER BY last_updated ASC
LIMIT 1;

-- 12. Find the most expensive app
SELECT app_name, price
FROM analytics
ORDER BY price DESC
LIMIT 1;

-- 13. Count all the reviews in the Google Play Store
SELECT SUM(reviews) AS total_reviews
FROM analytics;

-- 14. Find all categories with more than 300 apps
SELECT category
FROM analytics
GROUP BY category
HAVING COUNT(*) > 300;

-- 15. Find the app with the highest proportion of min_installs to reviews, installed at least 100,000 times
SELECT app_name, reviews, min_installs, (min_installs::FLOAT / reviews) AS proportion
FROM analytics
WHERE min_installs >= 100000
ORDER BY proportion DESC
LIMIT 1;

-- FS1: Find the name and rating of the top-rated apps in each category
-- among apps that have been installed at least 50,000 times.
WITH RankedApps AS (
    SELECT 
        app_name,
        category,
        rating,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY rating DESC) AS rank
    FROM analytics
    WHERE min_installs >= 50000
)
SELECT 
    app_name,
    category,
    rating
FROM RankedApps
WHERE rank = 1;

-- FS2: Find all the apps that have a name similar to “facebook”.
SELECT 
    app_name
FROM analytics
WHERE app_name ILIKE '%facebook%';

-- FS3: Find all the apps that have more than 1 genre.
SELECT 
    app_name
FROM analytics
WHERE array_length(genres, 1) > 1;

-- FS4: Find all the apps that have education as one of their genres.
SELECT 
    app_name
FROM analytics
WHERE genres @> ARRAY['Education'];

