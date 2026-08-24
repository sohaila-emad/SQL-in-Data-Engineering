--WINDOW VALUE FUNCTIIONS ARE TO ACCESS A VALUE FROM ANOTHER 
-- LEAD ( SALARY    ,    3   ,     0      ) OVER(ORDER BY             )
--CLAUSE (EXPRESSION,OFFSET  ,DEFAULT VALUE)OVER( ORDER BY IS REQUIRED)
-- EXPRESSION IS THE COLUMN AND OFFSET IS THE NUM OF ROWS FORRWARD FROM CURRENT ONE AND DEFAULT IS THE VALUE RETURNED WHEN NO VALUE FOUND
--LAG IS FOR BACKWARD (PREVIOUS VALUE)
SELECT *,
(CAST(monSales - PrevSale AS FLOAT) / NULLIF(maxSale - minSale, 0))*100 AS percDiff
FROM(
	SELECT 
		MONTH(OrderDate) AS mon,
		SUM (Sales) AS monSales,
		LAG(SUM (Sales), 1, 0) OVER(ORDER BY MONTH(OrderDate)) AS PrevSale,
		MIN(SUM (Sales)) OVER() AS minSale,
		MAX(SUM (Sales)) OVER() AS maxSale
	FROM Sales.Orders
	GROUP BY MONTH(OrderDate))t


SELECT
    CustomerID,
    RANK() OVER(ORDER BY COALESCE(AVG(DaysBetweenOrders) ,99999)) AVGRANK
FROM (
    SELECT 
        CustomerID,
        OrderDate,
        DATEDIFF(
            day, 
            LAG(OrderDate, 1) OVER (PARTITION BY CustomerID ORDER BY OrderDate), 
            OrderDate
        ) AS DaysBetweenOrders
    FROM Sales.Orders
) t 
GROUP BY CustomerID;

