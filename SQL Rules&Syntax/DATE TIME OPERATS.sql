SELECT 
	CONCAT(FirstName ,' ' , LastName) AS FullName
FROM Sales.Customers

SELECT 
	UPPER(CONCAT(FirstName ,' ' , LastName)) AS FullName
FROM Sales.Customers

SELECT 
	TRIM(FirstName) AS FirstName
FROM Sales.Customers
--it removes any spaces from the name so it won't hurt the data (removes it from any place at the string)
SELECT 
	FirstName
FROM Sales.Customers
WHERE FirstName != TRIM(FirstName)
--to see the bad ones (with spaces ones )
SELECT 
	FirstName , 
	LEN(FirstName) AS len_name ,
	LEN(FirstName) - LEN(TRIM(FirstName)) AS flag
FROM Sales.Customers

SELECT 
	'1234-567-89' ,
	REPLACE('1234-567-89', '-', '')
--REPLACE can remove a char by making the replacing char a blank 

SELECT 
	'SOHAILA',
	LEFT('SOHAILA' , 2) AS leftones ,
	RIGHT('SOHAILA' , 2) AS rightones

SELECT 
	FirstName , 
	SUBSTRING(TRIM(FirstName) , 2 , LEN(FirstName)) AS SUBNAME , 
	LEN (SUBSTRING(TRIM(FirstName) , 2 , LEN(FirstName))) AS LENGTHOFSUBNAME
FROM Sales.Customers
--this one SUBSTRING takes the str and retrieves the chars at specific places (idx) like form char 2 to char 7 and so on 
--if SUBSTRING found that the word ends before the space u given it then it stops , doesn't add spaces or naything its safe 

SELECT 
	123.456,
	ROUND(123.456,0) AS ZERO,
	ROUND(123.456,1)AS ONE,
	ROUND(123.456,2) AS TWO

SELECT 
	-1271,
	ABS(-1271),
	ABS(1271)

SELECT 
	OrderID,
	CreationTime,
	'2026-06-25' AS today_date,
	GETDATE() AS TimeAndDate,
	DAY(CreationTime) AS dayofCT,
	MONTH(CreationTime) AS monofCT,
	YEAR(CreationTime) AS YEAR,
	DATEPART(week,CreationTime)  AS WEEK, --its an integer u can make integer operations on it 
	DATEPART(week,CreationTime) +6*3 AS WEEKmanipulated , 
	DATEPART(hour,CreationTime)  AS hour,
	DATEPART(WEEKDAY,CreationTime)  AS WEEKday --from 1 to 7
FROM Sales.Orders
--all of them are numbers(integers)

SELECT 
	OrderID,
	CreationTime,
	DATENAME(month,CreationTime) AS monthname,
	DATENAME(weekday,CreationTime) AS dayname, --weekday not day only
	DATENAME(year,CreationTime) AS yname
FROM Sales.Orders
--returns strings

SELECT 
	OrderID,
	CreationTime,
	DATETRUNC(month,CreationTime) AS monthlevel, --resets day to 01 as there is no 00 in days 
	DATETRUNC(day,CreationTime) AS daylevel, 
	DATETRUNC(year,CreationTime) AS yearlevel , --resets day to 01 as there is no 00 in days and also same with months 
	DATETRUNC(MINUTE,CreationTime) AS minutelevel
FROM Sales.Orders

SELECT 
    DATETRUNC(month, CreationTime) AS OrderMonth,
    COUNT(*) AS TotalOrders
FROM Sales.Orders
GROUP BY DATETRUNC(month, CreationTime)
ORDER BY COUNT(*); -- Sorts the final groups from smallest count to largest

SELECT 
    EOMONTH(CreationTime) EOM,
    COUNT(*) AS TotalOrders
FROM Sales.Orders
GROUP BY EOMONTH(CreationTime)
ORDER BY COUNT(*); -- Sorts the final groups from smallest count to largest
--use COUNT with GROUP BY to count rows at each category and without GROUP BY  to count the total num of rows in table 

SELECT 
	DATENAME( MONTH ,CreationTime) AS date,
	COUNT(*) AS NORPM
FROM Sales.Orders
GROUP BY DATENAME( MONTH ,CreationTime)
ORDER BY COUNT(*)

SELECT 
	*,
	DATENAME( MONTH ,CreationTime) AS date
FROM Sales.Orders
WHERE DATENAME(MONTH ,CreationTime) = 'February'
--BAD PRACTICE as searching for integers is way more faster than for strings 

SELECT 
	*,
	DATENAME( MONTH ,CreationTime) AS date
FROM Sales.Orders
WHERE MONTH (OrderDate) = 2

SELECT 
	OrderID,
	'DAY' + FORMAT(OrderDate , 'dd MM') + 'Q' + DATENAME( quarter ,OrderDate) +FORMAT(OrderDate , 'yyyy hh mm ss tt') AS wieredformat
FROM SALES.Orders

-- USE CASE 1 : AGGREGATION
SELECT 
	FORMAT(OrderDate , 'yyyy MM' ),
	COUNT(*)
FROM Sales.Orders
GROUP BY FORMAT(OrderDate , 'yyyy MM' )

SELECT 
	CONVERT(VARCHAR , OrderDate ),
	CONVERT(VARCHAR , OrderDate , 34 ) -- default of style(format) is 0 
FROM Sales.Orders

SELECT 
	CONVERT(VARCHAR , CreationTime ),
	CONVERT(VARCHAR , CreationTime , 34 ) as ws , -- default of style(format) is 0 
	CONVERT(DATE ,CREATIONTIME ,32)
FROM Sales.Orders

SELECT 
	CAST('123' AS INT),
	CAST('2005-12-8' AS date),
	CAST('7-2-2009' AS DATETIME)--will always return the default of format in sql

SELECT 
	MONTH(OrderDate) AS orderdate,
	AVG(DATEDIFF(DAY ,OrderDate ,ShipDate)) AS avgShippingDays
FROM Sales.Orders
GROUP BY MONTH(OrderDate)

SELECT 
	OrderDate AS currdate,
	LAG(OrderDate) OVER (ORDER BY OrderDate) AS prevDate,
	DATEDIFF(day , LAG(OrderDate) OVER (ORDER BY OrderDate) , OrderDate)
FROM Sales.Orders
--WHERE (LAG(OrderDate) OVER (ORDER BY OrderDate)) IS NOT NULL---it cannot work as the log window function cannot be done before the clauses like where 

SELECT 
	ISDATE('123') AS FSTWRONG ,
	ISDATE('23-7-2025') AS FORMATVARY,
	ISDATE('9-7-2025') AS RIGHTONE

SELECT 
	OrderDate,
	CASE 
		WHEN ISDATE(OrderDate) =1 THEN CAST(OrderDate AS DATE)
		ELSE NULL
	END newOrderDate --name of the casted date 
FROM 
(
	SELECT '2025-08-4' AS OrderDate UNION
	SELECT '2025-07-4' UNION
	SELECT '2025-08-1' UNION
	SELECT '2025-08' 
	) AS myquery; --important to give a name to the query
--case when then is like if statement




