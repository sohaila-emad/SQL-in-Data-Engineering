--IF U HAVE DUPLICATES IN ROWWS OF THE COMBINED DATA UNION WILL REMOVE IT AS IT RETURNS DISTINCT ONES 
--(IT WILL RETURN THE DUPLICATED VALUE BUT ONLY ONE TIME SO IT WON'T DELETE IT COMPLETELY IT WILL RETURN IT ONCE )
SELECT * FROM Sales.Customers
SELECT * FROM Sales.Employees

--union will return mary and kevin only one time 

SELECT 
	FirstName ,
	LastName,
	EmployeeID AS ID
FROM Sales.Employees
UNION
SELECT 
	FirstName ,
	LastName,
	CustomerID
FROM Sales.Customers

--UNION  passes on the first table and check if duplicates then goes to each row at second table and check if duplicated with any one of the fst one 
--O(N+N^2) complexity 

-- to include DUPLICATES use the UNION ALL 
--UNION ALL is so much FASTER and BETTER PERFORANCE 
--so if u know that data doesn't contain duplicates so go and use UNION ALL

SELECT 
	FirstName ,
	LastName,
	CustomerID AS ID
FROM Sales.Customers
UNION ALL
SELECT 
	FirstName ,
	LastName,
	EmployeeID 
FROM Sales.Employees

--EXCEPT operator is the one that we use when we want the first query but without the common between it and the seccond query 
--so it means I want all the first query MINUS the second one 

SELECT 
	FirstName ,
	LastName,
	CustomerID AS ID
FROM Sales.Customers
EXCEPT
SELECT 
	FirstName ,
	LastName,
	EmployeeID 
FROM Sales.Employees

-- intersect operator take only the common between 2 queries 
SELECT 
	FirstName ,
	LastName,
	CustomerID AS ID
FROM Sales.Customers
INTERSECT
SELECT 
	FirstName ,
	LastName,
	EmployeeID 
FROM Sales.Employees

SELECT * FROM Sales.Orders
SELECT * FROM Sales.OrdersArchive
/*this is  a BAD PRACTICE (the STAR to select all cols), instead type all cols names 
so u can see if there are something that changed at the orders that wasn't done on the archive like altering cols 
or adding a new one instead of old one so type it better to not be foolen blindely */
SELECT 
	  'orders'AS SourceTable
	  ,[OrderID]
	  ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.Orders
UNION
SELECT 
	  'orders archive'AS SourceTable
	  ,[OrderID]
	  ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.OrdersArchive
ORDER BY OrderID

SELECT * FROM Sales.Orders
EXCEPT
SELECT * FROM Sales.OrdersArchive

/*one usecase for the Except that if u have 2 databases and u are doing data migration so u wanna make ssure that 
all the data was transfered so u gotta make the except 2 times altering the order of the DBs (tables) to make sure 
that each one of them contains everyhting named DATA COMPLETENESS CHECK nad u gotta see the result as EMPTY both times */



