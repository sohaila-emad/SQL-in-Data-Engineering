--WINDOW FUNCTIONS take the same func as GROUP  BY but wth higher level if detail 
--like putting all the rows jusr they are but only the aggregated column gets affected 
--has exactly the same funcs in aggregation as group by but more ones in analytical functions
/*====================================================
GROUP BY                 vs           WINDOWING
for simple aggregations     ADVANCED DATA ANALYSIS
*/

SELECT 
	SUM(Sales) AS TotalSales
FROM Sales.Orders

SELECT 
	SUM(Sales) AS TotalSalesByProduct
FROM Sales.Orders 
GROUP BY ProductID

SELECT
	ProductID,
	OrderID,
	OrderDate,
	SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSalesByProductDevidedOnEachRow
FROM Sales.Orders 

--FUCTION EXPRESSION is the ARGUMENT value u pass to some fuction

--PARTION BY CLAUSE is just like the group by as it deviides data to partitions so it makess calculations over each partition individually
--we can use multiple dimensions (columns) in the partitions by clause 

SELECT
	ProductID,
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER() AS TSales,
	SUM(Sales) OVER(PARTITION BY ProductID) AS TSalesByProduct,
	SUM(Sales) OVER(PARTITION BY ProductID,OrderStatus ORDER BY Sales ASC) AS TSalesByProductandStatus
FROM Sales.Orders 

SELECT
	ProductID,
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	RANK( ) OVER( ORDER BY Sales ASC) AS RankSales
FROM Sales.Orders 
--u can use partition by clause in thee rank func 

/*FRAME clause is filtering or u can say selecting which rows u applying the calculations on each time (each row ) 
and u are selecting the boundaries from where to where to apply the calcs*/

SELECT
	ProductID,
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER( PARTITION BY OrderStatus ORDER BY Sales ASC 
					 ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS SUMSales
FROM Sales.Orders 
/*when using pertition by it ends at the end of the partition so if its unbounded for example 
so it will be till the end of the category its in it not the end of all rows */

SELECT
	ProductID,
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER( PARTITION BY OrderStatus ORDER BY Sales ASC 
					 ROWS 2 PRECEDING) AS SUMSales
FROM Sales.Orders 
--abbreviation that only works with precedding 

/*===========================================================
when u use ORDER BY it by DEFAULT uses A FRAME UNBOUNDED PRECEDING AND CURRENT ROW 
if u removed the ORDER BY clause without FRAME so u are aggregating the whole window (partition)
THE 4*RULES:
1- u cannot use a windowed func inside another one 
2- window func can be used only in 2 queries :SELECT and ORDER BY 
3-SQL executes the window only after filtering the data using where clause
4-window func can be used with the group by only if used with same columns (this one is best for scenario that u need to use 2 windows 
  so u canuse group by aggregate funcs for simple aggregations)*/

SELECT 
	CustomerID,
	SUM(Sales) AS totalSales,
	RANK() OVER (ORDER BY SUM(Sales)) AS RankCustomers 
FROM Sales.Orders
GROUP BY CustomerID