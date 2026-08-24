SELECT 
	*
FROM (
	SELECT 
		OrderID,
		COUNT (Sales) OVER(PARTITION BY CustomerID,OrderID) repeatedCID
	FROM Sales.OrdersArchive)t
	WHERE repeatedCID>1

SELECT
	DISTINCT(ProductID) AS PID,
	ROUND(CAST(totalProductSales AS FLOAT)/TotalSales *100,1 )AS Percentage
FROM(
SELECT 
	ProductID,
	Sales,
	SUM(Sales)OVER (PARTITION BY ProductID) totalProductSales,
	SUM(Sales)OVER()TotalSales
FROM Sales.Orders)t

SELECT 
	*
FROM(
	SELECT 
		OrderID,
		ProductID,
		Sales,
		AVG(Sales) OVER(PARTITION BY ProductID) avgProductSales,
		AVG(Sales) OVER() avgSales
	FROM Sales.Orders)t WHERE avgProductSales>avgSales

SELECT 
	OrderID,
	Sales -minSales AS devFromMin
FROM(
	SELECT
		OrderID,
		ProductID,
		Sales,
		MAX(Sales)OVER()maxSales,
		MIN(Sales)OVER() minSales
	FROM Sales.Orders)t

SELECT
	OrderID,
	ProductID,
	Sales,
	MAX(Sales)OVER(ORDER BY OrderDate)maxSales,
	MIN(Sales)OVER(ORDER BY OrderDate) minSales
FROM Sales.Orders
--MOVING PROGRESS OF MAX AND MIN VALS ---> ORDER BY + FRAME EFFECT
--RUNNING TOTAL 
--ROLLING TOTAL is by using FRAMES
