-- CTE :a subquery that u can use multiple times within the main query 
--the condition is to use it in just thee main query not out of it as it will be removed from memory(cache)
--its like funcs in python --reusable more than one time and clean and each parrt has an independent small job 
--it returns a table not a column so to add it to ur query u gotta join it 
--sql executes the CTE in the beggining then it puts result int the cacj=he then exectes the main query then when it ends
--it removes it from the cache 
--it can be recursive or non_recursive; the STAND_ALONE CTE is non_recursive cte that is INDEPENDENT

WITH total_customer_sales AS 
	( SELECT 
			CustomerID,
			SUM(Sales) AS sales
	  FROM Sales.Orders
	  GROUP BY CustomerID
	 )
SELECT 
	c.CustomerID,
	c.FirstName,
	c.Score,
	tcs.sales
FROM Sales.Customers c
LEFT JOIN total_customer_sales tcs
ON tcs.CustomerID =c.CustomerID

--ORDER BY is NOT allowed in the CTEs, instead use it in the main query
--only the fst cte uses WITH clause then for multiple ones just use a comma
WITH 
	total_customer_sales AS 
		( SELECT 
				CustomerID,
				SUM(Sales) AS sales
		  FROM Sales.Orders
		  GROUP BY CustomerID
		 )
	, last_order_date AS
		 ( SELECT 
				MAX(OrderDate) AS last_order,
				CustomerID
		   FROM Sales.Orders
		   GROUP BY CustomerID
		  )
SELECT 
	c.CustomerID,
	c.FirstName,
	c.Score,
	tcs.sales,
	lod.last_order
FROM Sales.Customers c
LEFT JOIN total_customer_sales tcs
ON tcs.CustomerID =c.CustomerID
LEFT JOIN last_order_date lod
ON c.CustomerID =lod.CustomerID
--all cols in the CTE should have a name 

--NESTED CTE
WITH 
	total_customer_sales AS 
		( SELECT 
				CustomerID,
				SUM(Sales) AS sales
		  FROM Sales.Orders
		  GROUP BY CustomerID
		 )
	, last_order_date AS
		 ( SELECT 
				MAX(OrderDate) AS last_order,
				CustomerID
		   FROM Sales.Orders
		   GROUP BY CustomerID
		  )
	 , rank_customers_sales AS 
		  ( SELECT
				CustomerID,
				RANK() OVER ( ORDER BY sales DESC) ranked_customers
			FROM total_customer_sales
		  )
SELECT 
	c.CustomerID,
	c.FirstName,
	c.Score,
	tcs.sales,
	lod.last_order,
	rcs.ranked_customers
FROM Sales.Customers c
LEFT JOIN total_customer_sales tcs
ON tcs.CustomerID =c.CustomerID
LEFT JOIN last_order_date lod
ON c.CustomerID =lod.CustomerID
LEFT JOIN rank_customers_sales rcs
ON c.CustomerID =rcs.CustomerID
--U cannot run the nested CTE alone to see its result so u gotta comment all the main query and type a select * from it and run 
WITH 
	total_customer_sales AS 
		( SELECT 
				CustomerID,
				SUM(Sales) AS sales
		  FROM Sales.Orders
		  GROUP BY CustomerID
		 )
	, last_order_date AS
		 ( SELECT 
				MAX(OrderDate) AS last_order,
				CustomerID
		   FROM Sales.Orders
		   GROUP BY CustomerID
		  )
	 , rank_customers_sales AS 
		  ( SELECT
				CustomerID,
				RANK() OVER ( ORDER BY sales DESC) ranked_customers
			FROM total_customer_sales
		  )
	 , customers_sales_segmentation AS 
		  ( SELECT 
				CustomerID,
				CASE (NTILE(3) OVER(ORDER BY ranked_customers))
					WHEN 1 THEN 'VIP' 
					WHEN 2 THEN 'Normal'
					WHEN 3 THEN 'Low'
					ELSE 'UNKNOWN'
				END AS customer_type
		    FROM rank_customers_sales
		  )
SELECT 
	c.CustomerID,
	c.FirstName,
	c.Score,
	tcs.sales,
	lod.last_order,
	rcs.ranked_customers,
	css.customer_type
FROM Sales.Customers c
LEFT JOIN total_customer_sales tcs
ON tcs.CustomerID =c.CustomerID
LEFT JOIN last_order_date lod
ON c.CustomerID =lod.CustomerID
LEFT JOIN rank_customers_sales rcs
ON c.CustomerID =rcs.CustomerID
LEFT JOIN customers_sales_segmentation css
ON c.CustomerID = css.CustomerID
--DONNOT overuse CTEs so it doesn't get complex --maybe 3-5 is fine on each query

--================================================================================
--RECURSIVE QUERY: a LOOP that loops through the data till some codition (break condition) 
--starts with ANCHOR QUERY then a RECURSIVE ONE 
--==================================================================================

WITH Series AS (
SELECT 1 AS NUM
UNION ALL 
SELECT 
	NUM +1
FROM Series
WHERE NUM<20 
)
SELECT * 
FROM Series
--=================================================================
OPTION( MAXRECURSION 12)--to LIMIT the number of iterations u loop 
--=====================================================================
WITH hieghr AS(
SELECT 
	EmployeeID,
	ManagerID,
	1 AS LEVEL
FROM Sales.Employees
WHERE ManagerID IS NULL
UNION ALL 
SELECT 
	e.EmployeeID ,
	e.ManagerID ,
	h.LEVEL +1
FROM Sales.Employees e
INNER JOIN hieghr h
ON h.EmployeeID =e.ManagerID
)
SELECT * FROM hieghr
--================================================================================================================
--u must whatch out from the order , so when u union all , the columns must have the same order for both queries
--================================================================================================================


