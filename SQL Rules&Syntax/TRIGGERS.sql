CREATE TABLE Sales.EmployeeLogs(
	LogID INT IDENTITY(1, 1) PRIMARY KEY,
	EmployeeID INT,
	LogMessage VARCHAR(255),
	LogDate DATETIME
	                            )

CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT
AS 
BEGIN
	INSERT INTO Sales.EmployeeLogs(EmployeeID, LogMessage, LogDate)
	SELECT
		EmployeeID,
		'New Employee Added = '+ CAST(EmployeeID AS varchar),
		GETDATE()
	FROM INSERTED
END
--INSERTED is avirtual table that holds a copy of rows being inserted into the target table (Employees)

INSERT INTO Sales.Employees 
VALUES(
	6, 'MARIA', 'DOE', 'HR', '12-6-2005', 'F', 8000, 3 )

SELECT * FROM Sales.EmployeeLogs