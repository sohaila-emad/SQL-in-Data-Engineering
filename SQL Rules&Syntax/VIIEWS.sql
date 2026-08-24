-- a VIEW is an abstraction to the actual TABLE , that is the layer that is shown when u write select .. from *** the *** is the view 
-- the data is not stored in the view , each time its retrieved from the real table to the view 
-- tables are where data is physically stored but view is just the abstraction so its easier to change the data in it 
-- but selecting (just selecting / ectracting) data from view is slower than table
-- views are read only u cannot write on them
-- views are important for data analysts so they vcan ue the asame view and do aggregations on it without redundancy from multiple queries

CREATE VIEW Sales.Monthly_Summary AS
(
	SELECT 
		DATETRUNC( month, OrderDate ) AS Month,
		SUM(Sales) AS SalesOfMonth,
		SUM(Quantity) AS QuantitySummed,
		COUNT(OrderID) AS totalOrders
	FROM Sales.Orders
	GROUP BY DATETRUNC( month, OrderDate ) 
)

DROP VIEW dbo.TOTAL_SALES
--its default is to be placed in the dbo schema and u can  change it by assigning the view to another one
--schema is the one between tables and the data_base
--we have not just the meta data of the view in catalog but also the query it has done by 
-- not like tables (the catalog contains the meta data of it only 
-- so we can retrieve it so that we can know what do these values represent
-- so its for analysts so they have an access to the view only wthout losing actual data 
DROP VIEW dbo.personsANDorders_details
CREATE VIEW Sales.personsANDorders_details AS
(
	SELECT 
		OrderID,
		Product,
		p.Price,
		p.Category,
		CONCAT(c.FirstName , ' ', c.LastName) AS CustomerName,
		Country AS CustomerCountry,
		CONCAT(e.FirstName , ' ', e.LastName) AS EmployeeName,
		e.Department AS EmployeeDepartement,
		o.Quantity,
		o.Sales
	FROM Sales.Orders o
	JOIN Sales.Products p
	ON p.ProductID = o.ProductID
	JOIN Sales.Customers c
	ON o.CustomerID = c.CustomerID
	JOIN Sales.Employees e
	ON o.SalesPersonID = e.EmployeeID		
)

-- VIEWS are used as a VIRTUAL LAYER between(DATA MARTS ) the DATA WAREHOUSE and REPORTING so its easier and faster and way less complex to 
--operate on them than the physical layer of data warehouse 