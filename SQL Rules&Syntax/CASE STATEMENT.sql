--in case  when , when some case is not covered u will get a null for it ,if u are not fulfilling any condition in some case u get NULL for it 
--ifi it fulfills 2 conditions it wiill perform only the first one and stop (f it passes by true it executes it and stops
SELECT 
	Category,
	SUM(Sales) AS totalSales
FROM(
	SELECT 
		Sales,
		OrderID,
		CASE 
			WHEN Sales>50 THEN 'High'
			WHEN Sales>20 THEN 'Meduim'
			ELSE 'Low'
		END AS Category
	FROM Sales.Orders)t
GROUP BY Category
ORDER BY totalSales ASC
-- same thing diff way 
SELECT 
		CASE 
			WHEN Sales>50 THEN 'High'
			WHEN Sales>20 THEN 'Meduim'
			ELSE 'Low'
		END AS Category,
	SUM(Sales) AS totalSales
FROM Sales.Orders
GROUP BY CASE 
			WHEN Sales>50 THEN 'High'
			WHEN Sales>20 THEN 'Meduim'
			ELSE 'Low'
		END

--the data types returned form the case when must be matching so I cannot rreturn integer n some case and str in another 

--case statement can be used in any query --the select /from/group by ...

--case staement can be used also in mappng like from 0/1 to the active//inactive form 

SELECT 
	EmployeeID,
	Gender,
	FirstName,
	LastName,
	CASE 
		WHEN Gender ='F' THEN 'female'
		WHEN Gender ='M' THEN 'male'
		ELSE 'NOT AVAILABLE'
	END AS GenderFullText
FROM Sales.Employees
--for abbreviation
SELECT 
	EmployeeID,
	Gender,
	FirstName,
	LastName,
	CASE Gender
		WHEN 'F' THEN 'female'
		WHEN 'M' THEN 'male'
		ELSE 'NOT AVAILABLE'
	END AS GenderFullText
FROM Sales.Employees

SELECT 
	CustomerID,
	--conditional Aggregation
	SUM(CASE 
			WHEN Sales >30 then 1
			ELSE 0
		END )AS TotalSalesHigh,
	COUNT(*) AS Totals
FROM Sales.Orders
GROUP BY CustomerID