USE sales;

-- TABLE CREATION

CREATE TABLE retail(
        transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(255),
    age INT,
    category VARCHAR(255),
    quantity INT,
    price_per_unit FLOAT, 
    cogs FLOAT,
    total_sale FLOAT
)

-- DATA CLEANING

-- Finding and eliminating null values

SELECT * FROM retail
WHERE coalesce(transactions_id,sale_date,sale_time,customer_id,gender,age,category,quantity,price_per_unit,cogs,total_sale) IS NULL;

DELETE FROM retail
WHERE transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- DATA EXPLORATION

-- What is the total number of sales?

SELECT COUNT(*) as total_sales from retail;

-- How many customers do we have?

SELECT COUNT(DISTINCT customer_id) as customers from retail;

-- How many categories of products do we have?

SELECT COUNT(DISTINCT category) as cateogories from retail;

-- DATA ANALYSIS

-- Retrieving all sales made on December 24th (Christmas Eve)

SELECT  * FROM retail
Where sale_date = '2022-12-24';

-- All clothing transactions over 10 items

SELECT 
	*
FROM retail
where category = 'Clothing'
	AND 
    quantity >= 4;
    
-- Total sales figures for each category

SELECT
	category, 
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail
GROUP BY 1;

-- Average age of customers for each item category

SELECT 
	category,
	ROUND(AVG(age), 2)
FROM retail
GROUP BY category;

-- Average Age of each category where transaction amount was greater than $1000

SELECT
	category,
    AVG(age)
FROM retail
WHERE total_sale > 1000
GROUP BY category;

-- Total number of transactions made by each gender in each category

SELECT
	category,
    gender,
    COUNT(*) as total_transactions
FROM retail
GROUP BY
	category,
    gender
ORDER BY 1;

-- Average sales per month sorted by sales amounts descending.

SELECT
	YEAR(sale_date),
    MONTH(sale_date),
    SUM(total_sale) as total_sale
FROM retail
GROUP BY 1, 2
ORDER BY total_sale DESC;

-- Top 5 customers by dollar amount spent

SELECT 
	customer_id,
    SUM(total_sale)
FROM retail
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;

-- Number of unique customers in each item category

SELECT 
	category,
    COUNT(DISTINCT customer_id)as total_customers
FROM retail
GROUP BY category
ORDER BY 2 DESC;

-- Average number of orders per shift (Morning, Evening)

With hourly_sale
AS
(
	SELECT *,
		CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail
)
SELECT
	shift,
	COUNT(*) as total_sales
FROM hourly_sale
GROUP BY shift;

