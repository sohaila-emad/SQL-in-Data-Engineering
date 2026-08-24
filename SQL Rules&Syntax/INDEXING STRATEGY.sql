-- DO NOT MAKE TOO MUCH INDEXES AS IT REQUIRES USUAL UPDATING AND MONITORING AND SORTED / REARRANGED SO IT WILL GET THE DATABASE SLOWER
--TOO MUCH INDEXES GETS THE PROCESS OF CREATING NEW EXEC PLAN TO E CONFUSED AND SLOWER 
--MAKES IT CHOOSE WRONG INDEX WHICH SLOWERING THE PERFORMANCE 
--=================================================================================================================================================
--OLAP (analytical)   ETL process                                 vs                                                     OLTP(transaction)
--to make aggregations to pud data on analysis tools (power BI)         to write and read from the data direcly like an app uses the db
--1- GOAL IS TO OPTIMIZE THE READ PERFORMANCE                             GOAL IS TO OPTIMIZE WRITE 
--COLUMN STORE INDEX                                               CLUSTERED INDEX ON PK (make sure not to make too much indexes as the write will be slower)

--2-get the most freuently used cols and tables 
--3-choose the rigth index 
--4-then choose the right index type 
--5-test the index
--get a list of slow queries and anlyze where is the pain point then create the right index and compare exec plan 
SELECT 
    TOP 10
    qs.total_elapsed_time AS TotalElapsedTime,
    qs.execution_count,
    qs.total_worker_time AS TotalCPUTime,
    qs.last_execution_time,
    qt.text AS QueryText
FROM 
    sys.dm_exec_query_stats qs
CROSS APPLY 
    sys.dm_exec_sql_text(qs.sql_handle) qt
ORDER BY 
    qs.total_elapsed_time DESC;

--6-MONITORING INDEX USAGE (sys schema)
--7-monitr missing indexes (sys recommendations)
--8-monitor duplicate indexes
SELECT
    tbl.name AS TableName,
    col.name AS IndexColumn,
    idx.name AS IndexName,
    idx.type_desc AS IndexType,
    COUNT(*) OVER (PARTITION BY tbl.name, col.name) ColumnCount
FROM sys.indexes idx
JOIN sys.tables tbl ON idx.object_id = tbl.object_id
JOIN sys.index_columns ic ON idx.object_id = ic.object_id AND idx.index_id = ic.index_id
JOIN sys.columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id
ORDER BY ColumnCount DESC
--9-UPDATE STATISTICS
SELECT
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName,
    s.name AS StatisticName,
    sp.last_updated As LastUpdate,
    DATEDIFF(day, sp.last_updated, GETDATE()) As LastUpdateDay,
    sp.rows AS 'Rows',
    sp.modification_counter AS ModificationsSinceLastUpdate
FROM sys.stats AS s
JOIN sys.tables t
ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
--10-MONITOR FRAGMNTATIONS
