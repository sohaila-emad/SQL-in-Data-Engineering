--intermediate subqeries are only accesible from the main query
--diff types based on RESULTS
--OVERALL; WHEN HAVING SUBQUERY IN THE SELECT OR THE WHERE (when needing the sub to be just a scaler) it executes it then takes the 
--scaler value of it then compare it or add it to the others while applying the main query
--SCALAR SUBQUERY:
SELECT
	AVG(Sales)
FROM Sales.Orders

--ROW SUBQUERY:
SELECT
	CustomerID
FROM Sales.Customers

--TABLE SUBQUERY:
SELECT
	OrderID,
	OrderDate
FROM Sales.Orders

--another type is the CONDITIONAL SUBQERY; USED IN THE FORM CLAUSE
SELECT*
FROM (
	SELECT 
		ProductID,
		Price,
		AVG(Price) OVER () AS AVERAGE
	FROM Sales.Products
	)t WHERE Price>AVERAGE

SELECT 
	CustomerID,
	SUM(Sales) AS SalesSUM,
	RANK()OVER (ORDER BY SUM(Sales)DESC) AS RankedCustomers
FROM Sales.Orders
Group by CustomerID

--same as the following one 
SELECT*,
	RANK() OVER(ORDER BY SalesSUM DESC) AS CustomerRank
FROM(
	SELECT 
		CustomerID,
		SUM(Sales) AS SalesSUM
	FROM Sales.Orders
	Group by CustomerID)t

--RESULT OF A SUBQUERY IS TEMPORARY AND STORED IN THE CACHE 

--SELECT SUBQUERY:###it MUST be A SINGLE VALUE (not a whole column)

SELECT
	EmployeeID,
	Salary,
	(SELECT SUM(Sales) FROM Sales.Orders) SUMofOrders
FROM Sales.Employees

--JOIN SUBQUERY:

SELECT 
	c.*,
	o.NofOrders
FROM Sales.Customers c
LEFT JOIN(
	SELECT
		CustomerID,
		COUNT(*) NofOrders
	FROM Sales.Orders
	GROUP BY CustomerID)o
ON c.CustomerID =o.CustomerID

--WHERE SUBQUERY

SELECT 
	Product,
	Price
FROM Sales.Products
WHERE Price>(SELECT AVG(Price) FROM Sales.Products)
--IN OPERATOR
SELECT *
FROM Sales.Orders
WHERE CustomerID IN (
					SELECT 
						CustomerID
					FROM Sales.Customers
					WHERE Country ='Germany')
SELECT *
FROM Sales.Orders
WHERE CustomerID NOT IN (
					SELECT 
						CustomerID
					FROM Sales.Customers
					WHERE Country ='Germany')

--ANY/ALL
--if we want to take the female emp that salary is at least higher than any (even one) of the male emps
SELECT *
FROM Sales.Employees
WHERE Gender='F'
AND Salary>ANY (
				SELECT Salary FROM Sales.Employees WHERE Gender='M' )
--if we want to take the female emp that salary is higher than all of the male emps
SELECT *
FROM Sales.Employees
WHERE Gender='F'
AND Salary>All (
				SELECT Salary FROM Sales.Employees WHERE Gender='M' )