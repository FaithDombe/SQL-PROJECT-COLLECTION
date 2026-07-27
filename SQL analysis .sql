CREATE TABLE retail_sales
			(
		transactions_id int primary key,
		sale_date date,
		sale_time time,
		customer_id int,
		gender varchar (15),
		age int, 
		category varchar (20),
		quantity int,
		price_per_unit int,
		cogs float,
		total_sale float
			);
			
select * from retail_sales

-- Record Count: Determine the total number of records in the dataset.
SELECT
	COUNT(transactions_id)
FROM retail_sales;

--Customer Count: Find out how many unique customers are in the dataset.
SELECT
	COUNT(DISTINCT customer_id)
FROM retail_sales;

--Category Count: Identify all unique product categories in the dataset.
SELECT
	COUNT( DISTINCT category)
FROM retail_sales;

--Null Value Check: Check for any null values in the dataset and delete records with missing data.

SELECT * 

---write a sql query to retrieve all columns for sales made on 22-11-05
select *
from retail_sales
where sale_date = '2022-11-05';
--limit 10;

---write a sql query to retrievve all transaction where the category is clothing and the quantity sold is more than 4 in the month of november 2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND
	quantity >= 4
AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

---write a sql query to calculate the total sales of each category
SELECT category,
		sum(total_sale) as net_sales
FROM retail_sales
GROUP BY category;


--- write a sql query to find the average age of customers who purchased items from the beauty category
SELECT avg(age)
FROM retail_sales
WHERE category = 'Beauty'

--- write a sql query to find all transactions where the total sales is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

--- write a sql query to find the total number of transaction made by each gender in each category
SELECT category,
		gender,
		count(transactions_id) as total_transaction
FROM retail_sales
GROUP BY category,
		gender;
---write a sql query to calculate the average sales of each month find out the best selling month of each year
SELECT *
FROM (  
	SELECT	
		EXTRACT(YEAR FROM sale_date) as year, 
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_Sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)  ORDER BY AVG(total_Sale) DESC) AS rank
	FROM retail_sales
	GROUP BY year, month
	ORDER BY year, avg_sale Desc
	) as t2
WHERE rank = 1 

---write a sql query to find the top 5 customers based on the highest total sales
SELECT 
		customer_id,
		sum(total_sale) AS sum_of_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY sum_of_sales DESC
LIMIT 5;

---write a sql query to find the number of unique customers who purchased items from each category
SELECT	
		category,
		COUNT(DISTINCT(customer_id))
FROM retail_sales
GROUP BY category

---write a sql query to create each shift and number of orders( example Morning<=12, Afternoon Between 12&17, Evening >17)
WITH sale_duration
as (
SELECT *,
		CASE 
			WHEN EXTRACT (hour FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT (hour FROM sale_time) BETWEEN  12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
			END as Shift
FROM retail_sales
	)
	SELECT Shift,
		count(transactions_id)
	FROM sale_duration
	GROUP BY Shift
