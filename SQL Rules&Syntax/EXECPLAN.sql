--EXECUTION PLAN is being done based on: THE QUERY and THE STATISTICS
--EXECUTION PLAN is being saved in the cache memory so if u used the query one more time it does not have to make the plan each time
SELECT * FROM Sales.Customers
Order by Score

/*
   Types of Scan
   
   - Table Scan: Reads every row in a table.
   - Index Scan: Reads all entries in an index to find results.
   - Index Seek: Quickly locates specific rows in an index.
*/

SELECT 
	o.Sales,
	c.Country
FROM Sales.Orders o
LEFT JOIN Sales.Customers c WITH (FORCESeek)  --forcing seek which maybe better for our query
ON c.CustomerID = o.CustomerID


SELECT 
	o.Sales,
	c.Country
FROM Sales.Orders o
LEFT JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
OPTION (HASH JOIN) --HINT for exec plan 
--sql still uses NESTED LOOPS even when tables are big

SELECT 
	o.Sales,
	c.Country
FROM Sales.Orders o
LEFT JOIN Sales.Customers c WITH (INDEX([PK_customers]))  --forcing specific index which maybe better for our query
ON c.CustomerID = o.CustomerID
