SELECT * FROM customers;
SELECT * FROM orders;
--no join

SELECT * FROM customers
INNER JOIN orders
ON id = customer_id
--INNER JOIN (the intersect only )
SELECT 
	customers.id,
	customers.first_name,
	customers.country,
	customers.score,
	orders.order_id,
	orders.sales
FROM customers
INNER JOIN orders
ON id = customer_id
--better to specify the table and choose which cols to join 

SELECT 
	c.id,
	c.first_name,
	c.country,
	c.score,
	ord.order_id,
	ord.sales
FROM customers AS c
INNER JOIN orders AS ord
ON c.id = ord.customer_id
--for ABBREVIATION

--sql does the joining as a neted loop that it tests the matching for each id in c for each customer id in ord so its like O(N^2) complexity
--even after it finds the match it keeps looking for the next ones till the last element 
--use INNER to recombine or filter 

SELECT 
	c.id,
	c.first_name,
	c.country,
	c.score,
	ord.order_id,
	ord.sales
FROM customers AS c
LEFT JOIN orders AS ord
ON id = customer_id
--get all customers and also add the cols related to orders that is for people who has orders ids 
--(showing all Cs and adding cols of orders and typing null for peopl who doesn't have ordesr)
--gets the Cs data wwithout checking then when adding ord's  data cols it checks the key

SELECT 
	c.id,
	c.first_name,
	c.country,
	c.score,
	ord.order_id,
	ord.sales
FROM customers AS c
RIGHT JOIN orders AS ord
ON id = customer_id

SELECT 
	c.id,
	c.first_name,
	c.country,
	c.score,
	ord.order_id,
	ord.sales
FROM orders AS ord
LEFT JOIN customers AS c
ON id = customer_id
--litteraly the same right join

SELECT 
	c.id,
	c.first_name,
	c.country,
	c.score,
	ord.order_id,
	ord.sales
FROM orders AS ord
FULL JOIN customers AS c
ON id = customer_id
-- FULL join is like union --combines all data of all tables 

SELECT 
	c.id,
	c.first_name,
	c.country,
	c.score,
	ord.order_id,
	ord.sales
FROM customers AS c
LEFT JOIN orders AS ord
ON id = customer_id
WHERE ord.customer_id IS NULL
--left anti join where u get all data in customers and execlude the ones with orders 

SELECT 
	c.id,
	c.first_name,
	c.country,
	c.score,
	ord.order_id,
	ord.sales
FROM orders AS ord
LEFT JOIN customers AS c
ON id = customer_id
WHERE ord.customer_id IS NULL 
--this one not joining it takes itself all then execludes itself also by putting customer id is null cond which doesn't happen--COMMON MISTAKE

SELECT 
	c.id,
	c.first_name,
	c.country,
	c.score,
	ord.order_id,
	ord.sales
FROM orders AS ord
LEFT JOIN customers AS c
ON id = customer_id
WHERE c.id IS NULL
--this is the alternative for right anti join which gets the orders with no customers which is bad for the business

SELECT 
	c.id,
	c.first_name,
	c.country,
	c.score,
	ord.order_id,
	ord.sales
FROM orders AS ord
FULL JOIN customers AS c
ON id = customer_id
WHERE ord.customer_id IS NULL OR c.id IS NULL
--that is the unmaching ones in either tables which is the FULL ANTI JOIN

SELECT 
	c.id,
	c.first_name,
	c.country,
	c.score,
	ord.order_id,
	ord.sales
FROM customers AS c
LEFT JOIN orders AS ord
ON id = customer_id
WHERE ord.customer_id IS NOT NULL

SELECT * FROM customers
CROSS JOIN orders
--cross(cartesian ) join where u need to combine all from a to all from b 

