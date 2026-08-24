--CTAs is where u create a table from a QUERY 
-- its difference between 
--if your views are very slow u can makee it a CTA but it will take long time to be ready but then it will be very fast 

SELECT 
	DATETRUNC(month, OrderDate) AS month ,
	SUM (Sales)AS sales
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATETRUNC(month, OrderDate)

SELECT * FROM Sales.MonthlyOrders

-- to update ur CTA 
IF OBJECT_ID('Sales.MonthlyOrders','U') IS NOT NULL 
	DROP TABLE Sales.MonthlyOrders
GO

--U can drop it if its found , then redo it 
-- u can use the CTAs in a way that u neep a snapshot of a data so u can analyze problems and fix it 
--as u cannot analyze when the updates are continues
-- also u can use ctas instead of views as virtual datamarts layer when views are very slow (but start with views as its better in this case)

