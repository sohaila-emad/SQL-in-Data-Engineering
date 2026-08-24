--unique indeces are unique that they can make search faster that when u see the idex (element u are searching for ) u stop as there are no other elements 
--like it , so they are faster in reading and slower in writing 
--they help u organize ur data that if u have to have some column unique then when u insert duplicates u get an error already 

SELECT * FROM Sales.Products

CREATE UNIQUE NONCLUSTERED INDEX idx_products_product ON Sales.Products(Product)

iNSERT INTO Sales.Products (ProductID ,Product) VALUES (104 ,'Caps')
--Violation of PRIMARY KEY constraint 'PK_products'. Cannot insert duplicate key in object 'Sales.Products'. The duplicate key value is (104).
DROP INDEX idx_products_product ON Sales.Products
--Violation of PRIMARY KEY constraint 'PK_products'. Cannot insert duplicate key in object 'Sales.Products'. The duplicate key value is (104).
/*SQL Server checks constraints in a specific hierarchy:

PRIMARY KEY / Clustered Index Constraints (Checked First)

UNIQUE Constraints / Nonclustered Unique Indexes (Checked Second)

FOREIGN KEY / CHECK Constraints*/
INSERT INTO Sales.Products (ProductID, Product) 
VALUES (999, 'Caps');
--Cannot insert duplicate key row in object 'Sales.Products' with unique index 'idx_products_product'. The duplicate key value is (Caps).
-- as we now didn't violate the pk column but the unique idx column only 
--=================================================================================================================================================
--Filtered INDEX
--less storage with targeted optimization
--MUST BE ROWSTORE AND NONCLUSTERED INDEX 
-- can be UNIQUE
SELECT * FROM Sales.Customers
WHERE Country = 'USA'

CREATE NONCLUSTERED INDEX idx_customers_country
ON Sales.Customers(Country)
WHERE Country = 'USA'

SELECT * FROM Sales.Customers
WHERE Country = 'USA'
--now its faster
DROP INDEX idx_DBCs_country ON Sales.Customers
sp_helpindex 'Sales.DBCs'