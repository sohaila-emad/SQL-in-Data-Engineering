--RANKING WINDOW FUNCs takes the rows and ssort them based on one certain coloumn then give a rank(number to each of them) 
--it can be DISCRETE or CONTINOUS so u can use the both cases (top 3 of data or top 20% of data) and each type has its own funcs 

SELECT 
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC ) AS RANKED_SALES 
FROM Sales.Orders
--ROW NUMBER IT DOESN'T SKIP OR DUPLICATES , IT DOESN'T HANDLE TIES (same sales at more than one row ) it gives them diff ranks 

SELECT 
	OrderID,
	ProductID,
	Sales,
	Rank() OVER(ORDER BY Sales DESC ) AS RANKED_SALES 
FROM Sales.Orders
--RANK HAVE DUPLICATES AND SKIPPING WITH TIES AS IT GIVES THE DUPLICAED SALES THE SAME RANK 
--AND AFTER THE DUPLICATES FINISH IT GIVES THEM THE RANK OF THE ROW NUMBER IT HAS (LIKE THE MEDALS IN COMPETITIONS)

SELECT 
	OrderID,
	ProductID,
	Sales,
	DENSE_RANK () OVER(ORDER BY Sales DESC ) AS RANKED_SALES 
FROM Sales.Orders
--DENSE RANK IS SAME AS RANK BUT WITHOUT SKIPPING 

SELECT 
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC ) AS ROWNUM ,
	Rank() OVER(ORDER BY Sales DESC ) AS RANKED,
	DENSE_RANK () OVER(ORDER BY Sales DESC ) AS DENSEDRANK
FROM Sales.Orders

SELECT * 
FROM(
	SELECT 
		OrderID,
		ProductID,
		Sales,
		ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC ) AS ROWNUM 
	FROM Sales.Orders)t 
WHERE ROWNUM=1

SELECT *
FROM(
SELECT 
	CustomerID,
	SUM(Sales) AS SUMofSales,
	RANK () OVER (ORDER BY SUM(Sales) ASC) AS ranked_sales 
FROM Sales.Orders
GROUP BY CustomerID)t WHERE ranked_sales<=2
--coloumns used in the window functions must exist in the group by 

SELECT  
	ROW_NUMBER () OVER(ORDER BY OrderID , OrderDate ASC) AS ID,
	*
FROM Sales.OrdersArchive
--PAGINATING is when deviding data by rownum /ID to make faster retrieval 


SELECT * 
FROM (
SELECT 
ROW_NUMBER () OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) AS ID,
*
FROM Sales.OrdersArchive)t WHERE ID =1

SELECT DISTINCT OrderID 
FROM Sales.OrdersArchive;

--NTILE devides the data rows to n of tiles so it gets the whole size of data dev by number of tile then gets this as the size of tile 
-- if its float like 5/2 it will give the fst tile the bigger size like it will be 3 then tile 2 will hold 2 
SELECT 
	OrderID,
	ProductID,
	Sales,
	NTILE (3) OVER ( ORDER BY Sales DESC) AS THREE_TILES,
	NTILE (2) OVER ( ORDER BY Sales DESC) AS TWO_TILES,
	NTILE (1) OVER ( ORDER BY Sales DESC) AS ONE_TILES
FROM Sales.Orders;

--some use case for NTILE is to split the load and balance the processing , ie is to load a big table from DB1 to DB2 so to make it easier 
--and safer u devide the table into ties then use UNION to combine it back (load balancing of the ETL)--EQUALIZE LOAD PROCESSING

SELECT 
	OrderID,
	ProductID,
	Sales,
	CUME_DIST() OVER(ORDER BY Sales DESC ) AS RANKED_SALES,
	PERCENT_RANK() OVER (ORDER BY Sales DESC ) AS PERCENTAGES
FROM Sales.Orders
--CUME_DIST = POSITION NUMBER / NUMBER OF ROWS
--TIE RULE: THE POSITION NUMBER OF SOME REPEATED VALUE IS THE LAST POSITION NUMBER OF THAT REPEATED VALUE 
--SO ALL TIES WILL TAKE THE SAME CUME_DIST WHICH IS THE PERCENTAGE OF LAST ONE OF THEM 

--PERCENT_RANK = (POSITION NUMBER-1) / (NUMBER OF ROWS-1) so fst value will be 0 
SELECT 
	Product,
	Price,
	CONCAT(PERCENTAGE*100 ,'%') AS PERC
FROM(
SELECT 
	Product,
	Price,
	CUME_DIST() OVER (ORDER BY Price) AS PERCENTAGE
FROM Sales.Products)t WHERE PERCENTAGE>=0.4