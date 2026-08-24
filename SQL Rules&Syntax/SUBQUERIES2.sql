--NON_CORRELATED SUBQUERY : can run INDEPENDENTLY from main query
--CORRELATED: sub that relys on thhe results (values )of main query
--MAIN-->row by row-->PASS to SUB-->result-->check for result-if exists so the row is included, if doesn't exist this row will be execluded
--so CORRELATED SUBQUERY getss executed as many times as the number of rows

SELECT *,
(SELECT COUNT(*) FROM Sales.Orders o WHERE c.CustomerID =o.CustomerID) AS totalOrders
FROM Sales.Customers c

SELECT *
FROM Sales.Orders o
WHERE EXISTS( SELECT 1 FROM Sales.Customers c WHERE Country='Germany' AND c.CustomerID =o.CustomerID )

SELECT *
FROM Sales.Orders o
WHERE NOT EXISTS( SELECT 1 FROM Sales.Customers c WHERE Country='Germany' AND c.CustomerID =o.CustomerID )
-- to test the correlated subs as they are depending on the main one u get a value (id for example) and 
--add it manually instead of o.CustomerID and test if it exists and right or not
