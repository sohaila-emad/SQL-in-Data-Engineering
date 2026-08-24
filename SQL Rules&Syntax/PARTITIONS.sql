--PARTITION FUNCTIONS benefits
--to devide a single table into partitions based on some column like the DATE so u get the most used ones in a partition and the others in aonther partitions 
--based on the usage for example 
--also to get the CPUs to process and do transactions in a parallel way 
-- aso it makes it easier to do transactions as it will search in some specific partition not in the whole table 

CREATE PARTITION FUNCTION PartitionByYear (DATE) --or reagion
AS RANGE LEFT FOR VALUES ('2023-12-31', '2024-12-31', '2025-12-31', '2026-12-31')

SELECT 
	name,
	function_id,
	type,
	type_desc,
	boundary_value_on_right
FROM sys.partition_functions
--always check it before doing new partition funcs 

ALTER DATABASE SalesDB ADD FILEGROUP FG_2023;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2024;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2025;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2026;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2027;
--adding folder-like logical containers in the database to contain whet u chooes from data base
--its like u devide the data base just as u want

SELECT *
FROM sys.filegroups
WHERE TYPE = 'FG'
--PRIMARY s the default logical container for all data files in the DB

ALTER DATABASE SalesDB 
ADD FILE (
    NAME = P_2023, -- Logical Name
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2023.ndf'
) 
TO FILEGROUP FG_2023;

ALTER DATABASE SalesDB 
ADD FILE (
    NAME = P_2024,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2024.ndf'
) 
TO FILEGROUP FG_2024;

ALTER DATABASE SalesDB 
ADD FILE (
    NAME = P_2025,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2025.ndf'
) 
TO FILEGROUP FG_2025;

ALTER DATABASE SalesDB 
ADD FILE (
    NAME = P_2026,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2026.ndf'
) 
TO FILEGROUP FG_2026;

ALTER DATABASE SalesDB 
ADD FILE (
    NAME = P_2027,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2027.ndf'
) 
TO FILEGROUP FG_2027;
GO
--DATA FILES are the actual PHYSICAL data container (the FG contains multiple data files)
SELECT SERVERPROPERTY('InstanceDefaultDataPath') AS DefaultDataPath;
--to get the path 

SELECT
    fg.name AS FilegroupName,
    mf.name AS LogicalFileName,
    mf.physical_name AS PhysicalFilePath,
    mf.size / 128 AS SizeInMB
FROM
    sys.filegroups fg
JOIN
    sys.master_files mf ON fg.data_space_id = mf.data_space_id
WHERE
    mf.database_id = DB_ID('SalesDB');
--to see details of the data files and monitor them

CREATE PARTITION SCHEME SchemePartitionByYear
AS PARTITION PartitionByYear
TO (FG_2023, FG_2024,FG_2025, FG_2026, FG_2027) 
-- to MAP PARTITIONS to the FGs
--3 BOUNDARIES = 4 PARTITIONS = 4 FGs

-- Query lists all Partition Scheme
SELECT
    ps.name AS PartitionSchemeName,
    pf.name AS PartitionFunctionName,
    ds.destination_id AS PartitionNumber,
    fg.name AS FilegroupName
FROM sys.partition_schemes ps
JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
JOIN sys.destination_data_spaces ds ON ps.data_space_id = ds.partition_scheme_id
JOIN sys.filegroups fg ON ds.data_space_id = fg.data_space_id

CREATE TABLE Sales.Orders_partitioned
(
    OrderID INT,
    OrderDate DATE,
    Sales INT
) ON SchemePartitionByYear (OrderDate)

INSERT INTO Sales.Orders_Partitioned VALUES 
    (1, '2023-05-15', 100),
    (2, '2023-11-20', 250),
    (3, '2024-02-10', 450),
    (4, '2024-08-05', 120),
    (5, '2025-01-18', 890),
    (6, '2025-09-30', 310),
    (7, '2026-03-12', 1500),
    (8, '2026-07-22', 620);

SELECT 
    p.partition_number AS PartitionNumber,
    fg.name AS FilegroupName,
    p.rows AS [RowCount],
    rv.value AS BoundaryValue
FROM sys.tables t
JOIN sys.indexes i 
    ON t.object_id = i.object_id
JOIN sys.partitions p 
    ON i.object_id = p.object_id AND i.index_id = p.index_id
JOIN sys.partition_schemes ps 
    ON i.data_space_id = ps.data_space_id
JOIN sys.destination_data_spaces dds 
    ON ps.data_space_id = dds.partition_scheme_id AND p.partition_number = dds.destination_id
JOIN sys.filegroups fg 
    ON dds.data_space_id = fg.data_space_id
LEFT JOIN sys.partition_range_values rv 
    ON ps.function_id = rv.function_id AND p.partition_number = rv.boundary_id + 1
WHERE t.name = 'Orders_Partitioned' 
  AND i.index_id < 2;
--to make sure all went rigth

SELECT *
INTO Sales.OrdersNoPartition
FROM Sales.Orders_partitioned

SELECT *
FROM Sales.Orders_partitioned
WHERE OrderDate = '2025-09-30'

SELECT *
FROM Sales.OrdersNoPartition
WHERE OrderDate = '2025-09-30'

SELECT *
FROM Sales.OrdersNoPartition
WHERE OrderDate IN( '2025-09-30', '2023-05-15')

SELECT *
FROM Sales.Orders_partitioned
WHERE OrderDate IN('2025-09-30', '2023-05-15')