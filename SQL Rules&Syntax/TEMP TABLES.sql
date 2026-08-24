--temporary table (TEMP TABLES) is where u can use them all session then its deleted by default 

SELECT 
	OrderID,
	OrderDate,
	OrderStatus
INTO #TEMP_TABLE
FROM Sales.Orders

SELECT 
* 
FROM #TEMP_TABLE
