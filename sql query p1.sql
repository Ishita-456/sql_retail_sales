-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p1;

-- CREATE TABLE
CREATE TABLE retail_sales
(
   transactions_id INT PRIMARY KEY,
   sale_date DATE,	
   sale_time TIME,
   customer_id INT,
   gender VARCHAR(15),
   age INT,
   category VARCHAR(15),	
   quantiy	INT,
   price_per_unit FLOAT,	
   cogs	FLOAT,
   total_sale FLOAT

);

SELECT * FROM retail_sales
LIMIT 10

SELECT
   COUNT(*)
FROM retail_sales

-- Data Cleaning
-- null values
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE customer_id IS NULL

SELECT * FROM retail_sales
WHERE gender IS NULL

SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR 
	total_sale IS NULL

-- remove null values
DELETE FROM retail_sales
WHERE 
    transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR 
	total_sale IS NULL

-- Data Exploration
-- HOW many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

SELECT DISTINCT category FROM retail_sales

--Data Analysis and Buisness Key Problems & Answers

--Q1. Write a sql query to retrieve all columns for sales made on '2022-11-05'

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05':


--Q2 Write a sql query to retrieve all transactions where the category is 'clothing' and quantity sold is more than 4 in the month of Nov-2022

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity >= 4
  AND TO_CHAR(sale_date,'YYYY-MM') = '2022-11';


--Q3. Calculate total sales and total orders for each category.

SELECT
    category,
    SUM(total_sale) AS net_sales,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;


--Q4. Find the average age of customers who purchased from the Beauty category.

SELECT
    ROUND(AVG(age),2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';


--Q5. Find all transactions where total_sale > 1000.

SELECT *
FROM retail_sales
WHERE total_sale >= 1000;


--Q6. Count the number of transactions made by each gender in each category.

SELECT
    category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY 1


--Q7. Calculate average sales per month and rank them within each year.

SELECT *
FROM (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank_
    FROM retail_sales
    GROUP BY
        EXTRACT(YEAR FROM sale_date),
        EXTRACT(MONTH FROM sale_date)
) as t
WHERE rank_ = 1;


--Q8. Find the top 5 customers based on total sales.

SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;


--Q9. Write a sql query to find the number of unique customers who purchased items from each category

SELECT
  category,
  COUNT(DISTINCT customer_id) as cnt_unique_customers
FROM retail_sales
GROUP BY category


--Q10. Write a sql query to create each shift and number of orders.

SELECT *,
   CASE
     WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
	 WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	 ELSE 'Evening'
   END as shift
FROM retail_sales

---END---