/* we cannot SET two tables (add the tables' rows together ) and put 
ORDER BY at each query its only optional one time at the last of the whole query */
--YOU MUST HAVE THE SAME NUM OF COLUMNS to do the SET operator 
-- data types of both tables (thier cols ) MUST BE CAMPATIBLE

SELECT 
	FirstName ,
	LastName,
	customerID
FROM Sales.Customers
UNION
SELECT 
	FirstName ,
	LastName,
	--EmployeeID
FROM Sales.Employees

SELECT 
	FirstName ,
	LastName,
	customerID
FROM Sales.Customers
UNION
SELECT 
	FirstName ,
	LastName,
	EmployeeID
FROM Sales.Employees

SELECT 
	FirstName ,
	LastName,
	EmployeeID
FROM Sales.Employees
UNION
SELECT 
	FirstName ,
	LastName,
	CustomerID
FROM Sales.Customers

--THE NAMING OF different named cols take the first table name 

--the oredr of cols should be exactly the same as it doessn't know whicch one to combine with which one 

SELECT 
	FirstName ,
	LastName,
	EmployeeID AS ID
FROM Sales.Employees
UNION
SELECT 
	FirstName ,
	LastName,
	CustomerID AS ID --no need to do so as its already on the first query 
FROM Sales.Customers

--not getting errpr doesn't mean u have correct information (data) , u ned to check 
SELECT 
	FirstName ,
	LastName,
	EmployeeID
FROM Sales.Employees
UNION
SELECT 
	LastName ,
	FirstName ,
	CustomerID
FROM Sales.Customers

