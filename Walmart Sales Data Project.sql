CREATE DATABASE walmart_sales_data;

USE walmart_sales_data;

CREATE TABLE IF NOT EXISTS sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10, 2),
quantity INT NOT NULL,
VAT FLOAT(6, 4) NOT NULL,
total DECIMAL(12, 4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL,
cogs DECIMAL(10, 2) NOT NULL,
gross_margin_pct FLOAT(11, 9),
gross_income DECIMAL(12, 4) NOT NULL,
rating FLOAT(2, 1)
);


-- -------------------------------------------------------------------------------------------
-- ---------------------------------- Feature Engineering ------------------------------------

-- creating new column time_of_day --

SELECT
   time,
   (CASE 
        WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END    
   ) AS time_of_day
FROM sales;   

ALTER TABLE sales 
ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
CASE 
        WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

-- creating new column day_name -- 

SELECT
   date,
   DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- creating new column month_name --

SELECT 
   date,
   MONTHNAME(date) AS month_name
FROM sales;

ALTER TABLE sales
ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- -------------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------------
-- --------------------------------- Generic Q's -------------------------------------------------

-- How many unique cities are present in the dataset?

SELECT 
    DISTINCT city
FROM sales;    

-- In which city is each branch?

SELECT 
    DISTINCT city,
    branch
FROM sales;    

-- --------------------------------------------------------------------------------------------
-- --------------------------------- Product --------------------------------------------------

-- How many unique product lines does the data have?

SELECT 
    COUNT(DISTINCT product_line)
FROM sales;    
     
-- What is the most common payment method?

SELECT 
   payment_method,
   COUNT(payment_method) AS cnt
FROM sales
GROUP BY payment_method
ORDER BY 2 DESC;   

-- What is the most selling product line?

SELECT 
   product_line,
   COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY 2 DESC;  

-- What is the Total Revenue by month?

SELECT
   month_name AS month,
   ROUND(SUM(total),2) AS Total_Revenue
FROM sales
GROUP BY month_name
ORDER BY 2 DESC;   

-- What month had the largest COGS?

SELECT
   month_name AS month,
   ROUND(SUM(cogs),2) AS Total_COGS
FROM sales
GROUP BY month_name
ORDER BY 2 DESC; 

-- What product line had the largest revenue??

SELECT
   product_line,
   ROUND(SUM(total),2) AS Total_Revenue
FROM sales
GROUP BY product_line
ORDER BY 2 DESC; 

-- What is the city with largest revenue?

SELECT
   city,
   ROUND(SUM(total),2) AS Total_Revenue
FROM sales
GROUP BY city
ORDER BY 2 DESC
-- need only largest revenue for city so for that set limit to 1
LIMIT 1;

-- What product line had the largest VAT?

SELECT
   product_line,
   ROUND(AVG(vat),2) AS vat
FROM sales
GROUP BY product_line
ORDER BY 2 DESC
-- need only largest VAT so for that set limit to 1
LIMIT 1; 

-- Fetch each product line add a column to those product line showing "Good", "Bad".
-- Good if its greater than average sales

WITH ProductLineSales AS (
    SELECT 
        product_line,
        SUM(total) AS total_sales,
        AVG(SUM(total)) OVER () AS avg_sales
    FROM sales
    GROUP BY product_line
)
SELECT 
    pl.invoice_id,
    pl.product_line,
    CASE 
        WHEN pls.total_sales > pls.avg_sales THEN 'Good'
        ELSE 'Bad'
    END AS sales_rating
FROM sales pl
JOIN ProductLineSales pls
ON pl.product_line = pls.product_line;


-- Which branch sold more products than average product sold?

SELECT
    branch,
    SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING qty > (SELECT AVG(quantity) FROM sales);   

-- What is the most common product line by gender?

SELECT
   gender,
   product_line,
   COUNT(gender) AS gender_cnt
   FROM sales
   GROUP BY 1, 2
   ORDER BY 3 DESC;
   
-- What is the average rating of each product line?   
 
 SELECT
    product_line,
    ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY 1
ORDER BY 2 DESC    
   
-- ----------------------------------------------------------------------------------------------
-- ------------------------------- Sales --------------------------------------------------------

-- Number of sales made in each time of the day per weekday   

SELECT
   time_of_day,
   COUNT(*) AS total_sales
FROM sales
WHERE day_name NOT IN ("Saturday", "Sunday")
GROUP BY time_of_day
ORDER BY total_sales DESC;


-- Number of sales made in each time of the day per weekend  


SELECT
   time_of_day,
   COUNT(*) AS total_sales
FROM sales
WHERE day_name IN ("Saturday", "Sunday")
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Which of the customer types brings the most revenue?

SELECT
   customer_type,
   ROUND(SUM(total), 2) AS Revenue
FROM sales
GROUP BY 1
ORDER BY 2 DESC
-- need only most revenue per customer type set a limit to 1
LIMIT 1;		
-- Which city has the largest tax pct/VAT ?

SELECT 
  city,
  ROUND(AVG(VAT), 2) AS vat
FROM sales
GROUP BY city
ORDER BY 2 DESC
-- need only the largest city in terms of VAt, so for that use limit 1
LIMIT 1;  

-- -- Which customer_type has the largest tax pct/VAT ?

SELECT 
  customer_type,
  ROUND(AVG(VAT), 2) AS vat
FROM sales
GROUP BY customer_type
ORDER BY 2 DESC
-- need only the most customer_type in terms of VAt, so for that use limit 1
LIMIT 1; 

-- -----------------------------------------------------------------------------------------------
-- ----------------------------------------- Customer --------------------------------------------

-- How many unique customer types does the dataset have?

SELECT
    DISTINCT customer_type
FROM sales;    

-- How many unique payment method does the dataset have?

SELECT
    DISTINCT payment_method
FROM sales;    

-- What is the most common customer type?

SELECT
   customer_type,
   COUNT(*) AS Total_Customer_type
FROM sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;   

-- What is the gender of most of the customers?

SELECT
   gender,
   COUNT(*) AS gender_count
FROM sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;   

-- What is the gender distribution per branch?

SELECT 
    branch,
    gender,
    COUNT(*) AS gender_count,
    ROUND((COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY branch)) * 100, 2) AS percentage
FROM sales
GROUP BY branch, gender
ORDER BY 4 DESC;

-- Which time of the day do customers give most ratings per branch?

SELECT 
    branch,
    time_of_day,
    ratings_count
FROM (
    SELECT 
        branch,
        time_of_day,
        COUNT(rating) AS ratings_count,
        RANK() OVER (PARTITION BY branch ORDER BY COUNT(rating) DESC) AS rnk
    FROM sales
    GROUP BY branch, time_of_day
) AS RankedRatings
WHERE rnk = 1;

-- Which day has the most ratings per branch?

SELECT 
    branch,
    day_name,
    ratings_count
FROM (
    SELECT 
        branch,
        day_name,
        COUNT(rating) AS ratings_count,
        RANK() OVER (PARTITION BY branch ORDER BY COUNT(rating) DESC) AS rnk
    FROM sales
    GROUP BY branch, day_name
) AS RankedRatings
WHERE rnk = 1;


