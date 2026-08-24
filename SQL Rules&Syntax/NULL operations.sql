--ISNULL and COALESCE returns static val or dynamic one 
--COALESCE returns the first non null value and if there isn't , it returns null 
-- COALESCE accepts more than 1 replacement , it accepts an array of vals u can put all dynamic ones and an 0 or 'unknown' at the end depending on the way ur business deals with it 

SELECT 
	AVG(ISNULL(Score , 0)) AS average_score --business deals with nulls as 0s here
FROM Sales.Customers

SELECT 
	AVG(Score) AS average_score --business deals with nulls as they diidn't exist so it will only deviide by 4 not 5 here
FROM Sales.Customers

--when summing ints or concate strs with nulls we get also nulls it means if the input is unknown then the output is also unknown 
SELECT 
	CustomerID,
	FirstName+' ' + COALESCE(LastName,'')AS full_name,
	COALESCE(Score,0) +10 AS new_score
FROM Sales.Customers

/*if u have nulls inside ur keys then sql will miiss those vals so its important 
to handle nulls in key like replacing them with static str or even dynamic val */
--if sorting the data asc u will get the null as the fst val as sql treats it as the lowest one 

SELECT
	CustomerID,
	COALESCE(Score ,999999) AS SCORE
FROM Sales.Customers
ORDER BY Score ASC


SELECT
	CustomerID,
	Score
	--CASE WHEN Score IS NULL THEN 1 ELSE 0 END FLAG
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score ASC
--so like this we forced the null to be at the last witout miissing with the data

--NULLIF is a func that goe sback from the ISNULL as it finds if there are 2 cols/ vals are identical it flags them by puuting null 

SELECT 
	OrderID,
	Sales,
	Quantity,
	CASE WHEN Quantity=0 THEN NULL ELSE Sales/Quantity END price 
FROM Sales.Orders
--equvalent to ===
SELECT 
	OrderID,
	Sales,
	Quantity,
	Sales / NULLIF(Quantity,0) AS price 
FROM Sales.Orders

SELECT 
	c.*,
	o.OrderID
FROM Sales.Orders o
LEFT JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
WHERE O.CustomerID IS NULL
--THHATS how u perform left anti joint , by including only the key that equlas null of right one 