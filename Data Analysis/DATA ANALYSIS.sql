
--Analysis for Change Over Time
SELECT
	DATETRUNC(month, order_date) AS order_date,
	SUM(Sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL 
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date)

--Comulative Analysis
SELECT 
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
	AVG(total_sales) OVER (ORDER BY order_date) AS moving_avg_price
FROM(
SELECT 
	DATETRUNC(month, order_date) AS order_date,
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL 
GROUP BY DATETRUNC(month, order_date)) t 

--Performance Analysis
WITH yearly_product_sales AS (
SELECT 
	YEAR(s.order_date) AS order_date,
	p.product_name,
	SUM(s.sales_amount) AS current_sales
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY 
	YEAR(s.order_date),
	p.product_name
 )
SELECT 
	order_date,
	product_name,
	current_sales,
	AVG (current_sales) OVER( PARTITION BY product_name) AS avg_sales,
	current_sales - AVG (current_sales) OVER( PARTITION BY product_name) AS diff_avg,
	CASE WHEN current_sales - AVG (current_sales) OVER( PARTITION BY product_name) > 0 THEN 'Above Avg'
		 WHEN current_sales - AVG (current_sales) OVER( PARTITION BY product_name) < 0 THEN 'Below Avg'
		 ELSE 'Avg'
	END avg_change,
	LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_date) AS prev_year_sales,
	current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_date) AS diff_prev_year,
	CASE WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_date) > 0 THEN 'Increase'
		 WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_date) < 0 THEN 'Decrease'
		 ELSE 'Same'
	END avg_change
FROM yearly_product_sales

--Part to Whole Analysis
WITH category_sales AS( 
SELECT 
	p.category ,
	SUM(s.sales_amount) AS total_sales
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON p.product_key = s.product_key
GROUP BY p.category )
SELECT 
	category ,
	total_sales,
	CONCAT(ROUND(CAST (total_sales AS FLOAT) / SUM(total_sales) OVER() *100,2),'%') AS category_percentage
FROM category_sales
ORDER BY total_sales DESC

--Data Segmentation
WITH products_segment AS(
SELECT 
	product_key,
	product_name,
	cost,
	CASE WHEN cost < 100 THEN 'Below 100'
		 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
		 WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
		 ELSE 'Above 1000'
	END cost_range
	FROM gold.dim_products
)
SELECT 
	cost_range,
	COUNT( product_key) AS total_products
FROM products_segment
GROUP BY cost_range
ORDER BY COUNT( product_key) DESC

WITH customer_segment AS(
SELECT 
    c.customer_key,
    SUM(s.sales_amount) AS total_spending,
    DATEDIFF(MONTH, MIN(s.order_date), MAX(s.order_date)) AS months_of_history
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
    ON s.customer_key = c.customer_key
GROUP BY 
    c.customer_key
)
SELECT 
	customer_key,
	customer_category,
	total_spending,
	months_of_history,
	COUNT(*) OVER(PARTITION BY customer_category) AS num_of_customers
FROM(
SELECT 
	customer_key,
	total_spending,
	months_of_history,
	CASE WHEN months_of_history >=12 AND total_spending > 5000 THEN 'VIP'
		 WHEN months_of_history >=12 AND total_spending <= 5000 THEN 'Regular'
		 WHEN months_of_history <12 THEN 'New'
	END customer_category
FROM customer_segment)t
ORDER BY total_spending DESC


