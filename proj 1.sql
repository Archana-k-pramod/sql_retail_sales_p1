# SQL Retail Sales Analysis Project
create database sql_project_1;

# Create table
drop table if exists retail_sales;
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

SELECT 
    *
FROM
    retail_sales
WHERE
    transactions_id IS NULL
        OR sale_date IS NULL
        OR sale_time IS NULL
        OR customer_id IS NULL
        OR gender IS NULL
        OR age IS NULL
        OR category IS NULL
        OR quantity IS NULL
        OR price_per_unit IS NULL
        OR cogs IS NULL
        OR total_sale IS NULL;

DELETE FROM retail_sales 
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

SELECT 
    COUNT(*) AS Count_of_Sales
FROM
    retail_sales;

-- How many customers we have ?

SELECT 
    COUNT(DISTINCT customer_id) AS Number_of_customers
FROM
    retail_sales;

-- How many categories we have ?

SELECT DISTINCT
    category AS Categories
FROM
    retail_sales;

-- 1. retreive all columns for sales made on 2022-11-05.

SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';

-- 2. Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of November 2022.

SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'Clothing' AND quantity > 3
        AND sale_date LIKE '2022-11%'
;

-- 3. Calculate the total sales (total_sale) for each catgory.

SELECT 
    category,
    SUM(total_sale) AS net_sales,
    COUNT(*) AS total_orders
FROM
    retail_sales
GROUP BY 1;

-- 4. Find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
    category, ROUND(AVG(age), 2) AS average_age_of_customers
FROM
    retail_sales
WHERE
    category = 'Beauty';

-- 5. Find all transactions where the total_sale is greater than 1000.

SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale > 1000;

-- 6. Find the total number of transactions (transacions_id) made by each gender in each category.

SELECT 
    category,
    gender,
    COUNT(transactions_id) number_of_transactions
FROM
    retail_sales
GROUP BY 1 , 2
ORDER BY 1;

-- 7. Calculate the average sale of each month. Find out best selling month in each year.

with CTE as
(
SELECT 
    YEAR(sale_date) AS `year`,
    MONTH(sale_date) AS `month`,
    ROUND(avg(total_sale), 2) AS avg_sale,
    dense_rank() over(partition by year(sale_date) order by avg(total_sale) desc ) as ranking
FROM
    retail_sales
GROUP BY 1,2
)
select `year`, `month` as best_selling_month, avg_sale from CTE
where ranking = 1;

-- 8. Find the top 5 customers based on the highest total sales.

SELECT 
    customer_id, SUM(total_sale) total_sales
FROM
    retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

-- 9. Find the number of unique customers who purchased items from each category. 

SELECT 
    category, COUNT(DISTINCT customer_id) count_of_unique_customers
FROM
    retail_sales
GROUP BY 1
order by 1;

-- 10. Write a SQL query to create each shift and number of orders(Example. Morning <12 , Aftenoon Betweeen 12 & 17 , Evening >17 )

with shift as (
select sale_time, hour(sale_time),
case
when hour(sale_time) <12 then "morning"
when hour(sale_time) >17 then "evening"
else "afternoon"
end as shift_time
from retail_sales
order by sale_time)
select shift_time, count(*) AS number_of_orders
from shift
group by shift_time;




