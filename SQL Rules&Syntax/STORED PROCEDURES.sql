-- stored procedures is a concept like oop its just a way to organize and make the work dynamic , and u donnot have to copy/ repeat the logic
--over and over so u put the logi in a dynamic part so u can execute where ever u need 
-- its NOT very good for the complex and big projects as it will get messy so u gotta do it with python instead in this case 
-- its advantage on python is that its already connected to the database server and that its already compiled on the data base 

ALTER PROCEDURE GET_CUSTOMER_DETAILS_BY_COUNTRY @Country NVARCHAR(20) ='USA' --ARGUMENT(PARAMETER) with its data type and usa is the default 
--value if there are no args passed
AS
BEGIN
	--==============================
	--ERROR HANDLING
	--==============================
	BEGIN TRY 
		DECLARE @NUM_OF_CUSTOMERS INT , @AVG_SALES FLOAT --DECLARING VARS TO ASSIGN VALUES IN THEM TO USE IT LATER (FINALLLLY)
		--===============================
		--STEP 1 :PREPARE AND CLEAN DATA
		--===============================
		IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL and Country = @Country)
			BEGIN
				PRINT 'UPDATING NULLS TO 0s in the SCORE'
				UPDATE Sales.Customers
				SET Score =0
				WHERE Score IS NULL AND Country = @Country
			END;
		ELSE 
			BEGIN
				PRINT' NO NULLS IN SCORE'
			END;

			SELECT 
				@NUM_OF_CUSTOMERS = COUNT(*) ,-- remove the AS when u assign vals as the query only has one job 
				@AVG_SALES = AVG(Score) 
			FROM Sales.Customers
			WHERE Country =@Country;
			PRINT 'NUMBER OF CUSTOMERS IN '+ @Country+ ' IS '+ CAST(@NUM_OF_CUSTOMERS AS NVARCHAR);
			PRINT 'AVERAGE OF SALES IN '+ @Country+ ' IS '+ CAST (@AVG_SALES AS NVARCHAR);

			SELECT 
				COUNT(o.OrderID) TotalOrders,
				SUM(o.Sales) SALES,
				1/0
			FROM Sales.Orders o 
			JOIN Sales.Customers c 
			ON c.CustomerID = o.CustomerID
			WHERE c.Country = @Country;
	END TRY
	--=======================
	--ERROR PRINTS
	--=======================
	BEGIN CATCH
		PRINT('AN ERROR OCCURED');
		PRINT('THE ERROR MESSAGE ' + ERROR_MESSAGE());
		PRINT('THE ERROR NUMBER ' + CAST(ERROR_NUMBER() AS NVARCHAR));
		PRINT('THE ERROR LINE ' + CAST(ERROR_LINE() AS NVARCHAR));
		PRINT('THE ERROR PROCEDURE ' + ERROR_PROCEDURE());
	END CATCH
END
GO
--to change the procedure later just type ALTER instead of CREATE 
EXEC GET_CUSTOMER_DETAILS_BY_COUNTRY 
EXEC GET_CUSTOMER_DETAILS_BY_COUNTRY @Country = 'Germany'



SELECT * FROM Sales.Customers