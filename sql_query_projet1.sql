--SQL Retail Sales Analysis -P1
CREATE DATABASE sql_project_p2;


-- Create Table
DROP TABLE IF EXISTS retails_sales;
Create Table retails_sales 
			(
	 			transactions_id INT PRIMARY KEY,
	 			sale_date	DATE,
	 			sale_time	TIME,
	 			customer_id	INT,
	 			gender	VARCHAR(15),
	 			age	INT,
	 			category VARCHAR(15),	
	 			quantiy INT,
	 			price_per_unit	FLOAT,
	 			cogs	FLOAT,
	 			total_sale FLOAT
				
				);
				
SELECT * From retails_sales;

SELECT 
count(*)
FROM retails_sales

SELECT * From retails_sales
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
  
--- Data cleanning
DELETE FROM retails_sales 
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
 -- How many sales we have 
SELECT COUNT(*) as total_sale FROM retails_sales
 -- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retails_sales
 
SELECT DISTINCT category  FROM retails_sales

-- Data analysis & Business key Problems & Answers
--Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * FROM retails_sales
WHERE sale_date='2022-11-05';
-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of nov-22
SELECT 
*
FROM retails_sales
WHERE category='Clothing'
AND
TO_CHAR(sale_date, 'YYYY-MM')='2022-11'
AND 
quantiy >=4

--Write a SQL query to calculate the total sales(total_sale) for each category
SELECT 
category ,
SUM(total_sale) as net_sale,
COUNT(*) as total_orders
FROM retails_sales
GROUP BY 1

--Write a SQL query to find the average age of customers who purchased items for the 'beauty' category
SELECT 

ROUND(AVG(age),2) as avg_age
FROM retails_sales
WHERE category='Beauty'

--Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT*
FROM retails_sales
WHERE total_sale >= 100
-- Write a SQL query to find the total number of transaction(transaction_id) made by each gender each category
SELECT
gender,
category,
COUNT(*) as  total_trans
FROM retails_sales
GROUP 
BY 
gender,
category
ORDER BY 1
-- Write a SQL query to calculate the average sale for each month. find out best selling in each year
SELECT
	year,
	month,
	avg_sale
FROM 
(
	SELECT
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale,
		RANK()OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale)DESC) as rank 
	FROM retails_sales
	GROUP BY 1, 2
) as t1
WHERE rank = 1
--ORDER BY 1, 3 DESC
-- Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
customer_id,
	SUM(total_sale) as total_sale
	FROM retails_sales
group by 1
ORDER BY 2 DESC
LIMIT 5
-- Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
category,
COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retails_sales
GROUP BY category

-- Write a SQL query to create each shift and number of orders (example Morning <=, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS(
SELECT *,
		CASE 
		WHEN EXTRACT(HOUR FROM sale_time)< 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retails_sales
)

SELECT
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift
--end of proejct 