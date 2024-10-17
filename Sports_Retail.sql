CREATE TABLE brands (
    product_id VARCHAR(100) PRIMARY KEY,
    brand VARCHAR(100)
);
CREATE TABLE finance (
    product_id VARCHAR(100) PRIMARY KEY,  
    listing_price FLOAT,
    sale_price FLOAT,
    discount FLOAT,
    revenue FLOAT
);
CREATE TABLE info (
product_name VARCHAR(100) ,
product_id VARCHAR(100) PRIMARY KEY,
descrip VARCHAR(1000) 
);
CREATE TABLE reviews (
product_id VARCHAR(100) PRIMARY KEY,
rating FLOAT,
reviews FLOAT
);
CREATE TABLE traffic (
product_id VARCHAR(100) PRIMARY KEY,
last_visited timestamp
);

-- ----------------------------------------------------------------- --

-- get a list of all products sorted alphabetically by their names
SELECT product_name, product_id
FROM info
WHERE product_name IS NOT NULL
ORDER BY product_name ASC;

-- count the total number of products in info table
SELECT COUNT(*) AS total_products
FROM info;

-- check for duplicate product IDs
SELECT product_id, COUNT(*) AS count
FROM info
GROUP BY product_id
HAVING COUNT(*) > 1;

-- ----------------------------------------------------------------- --

-- retrieve the total_revenue for each distinct product_id to identify top selling products
SELECT product_id, SUM(revenue) AS total_revenue 
FROM finance 
WHERE revenue IS NOT NULL
GROUP BY product_id 
ORDER BY total_revenue DESC;

-- identify which brands generate the most revenue
SELECT b.brand, SUM(f.revenue) AS total_revenue 
FROM brands b 
JOIN finance f ON b.product_id = f.product_id 
WHERE b.brand IS NOT NULL AND f.revenue IS NOT NULL
GROUP BY b.brand 
ORDER BY total_revenue DESC;

/*
SELECT b.brand, SUM(f.revenue) AS total_revenue 
FROM brands b, finance f
WHERE b.product_id = f.product_id
GROUP BY b.brand 
ORDER BY total_revenue DESC;
*/

-- retrieve the average_rating for each distinct product_id to show products with the highest average rating
SELECT product_id, AVG(rating) AS average_rating
FROM reviews 
WHERE rating IS NOT NULL
GROUP BY product_id
ORDER BY average_rating DESC ;

-- show most recently visited products
SELECT product_id, last_visited 
FROM traffic 
WHERE last_visited IS NOT NULL
ORDER BY last_visited DESC;

-- ----------------------------------------------------------------- --

-- identify products with the largest discount
SELECT product_id, discount
FROM finance
WHERE discount IS NOT NULL
ORDER BY discount DESC;
-- LIMIT 5;

-- show products where the sale_price is significantly lower than the listing_price
SELECT product_id, listing_price, sale_price, (listing_price - sale_price) AS price_difference
FROM finance
WHERE listing_price IS NOT NULL AND sale_price IS NOT NULL
ORDER BY price_difference DESC;

/*
SELECT 
    product_id, 
    discount, 
    listing_price, 
    sale_price, 
    (listing_price - sale_price) AS price_difference
FROM finance
ORDER BY  price_difference DESC;
*/

-- compare the listing_price for Adidas and Nike products
SELECT brand, listing_price , count(*) AS count
FROM finance
INNER JOIN brands
ON finance.product_id = brands.product_id
WHERE listing_price > 0  AND brand IS NOT NULL-- to remove null listing_price and brand
GROUP BY brand, listing_price
ORDER BY listing_price DESC;

-- find out the thresholds for price_category
SELECT b.brand, 
       AVG(f.listing_price) AS avg_listing_price,
       MAX(f.listing_price) AS max_listing_price
FROM brands b
JOIN finance f ON b.product_id = f.product_id
WHERE b.brand IS NOT NULL AND f.listing_price IS NOT NULL
GROUP BY b.brand;

-- label price ranges
SELECT brand, count(*) AS product_count_in_each_category, sum(revenue) AS total_revenue,
CASE WHEN listing_price < 42 THEN 'Budget'
     WHEN listing_price >= 42 AND listing_price < 76 THEN 'Average'
     WHEN listing_price >= 76 AND listing_price < 200 THEN 'Expensive'
     ELSE 'Elite' END AS price_category
FROM finance
INNER JOIN brands
ON finance.product_id = brands.product_id
WHERE listing_price IS NOT NULL AND brand IS NOT NULL
GROUP BY brand, price_category
ORDER BY total_revenue DESC;


