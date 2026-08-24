SELECT *
FROM sys.indexes
select * from sys.tables
--to MONITOR THE INDECES USAGE :
SELECT 
tbl.name AS TabeName,
idx.name AS IndexName,
idx.type_desc AS IndexType,
idx.is_unique AS ISUnique,
idx.is_disabled AS IsDisabled,
idx.is_primary_key AS IsPK,
s.last_system_lookup AS LastSysLookup,
s.last_system_scan AS LastSysScan,
s.last_system_update AS LastSysUpdates,
s.user_seeks AS UserSeeks,
s.user_updates AS UserUpdates,
s.system_scans AS sysScans,
COALESCE(s.last_user_scan, last_user_seek) LastUserUpdate
FROM sys.indexes idx
JOIN sys.tables tbl
ON idx.object_id = tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats s
ON s.object_id = idx.object_id
ORDER BY TabeName, IndexName

SELECT * from sys.dm_db_index_usage_stats

--ALWAYS START THE PROJECT BY LOOKING THROUGH THE USAGE OF THE INDEXES , AND IF THEY ARE UNUSEFULL DROP THEM , LIKE THAT U HAVE SAVED WAY STORAGE AND 
--OPTIMIZED THE WRITE PERFOMANCE SO MUCH 

--to MONITOR MISSING INDECES :
SELECT * from sys.dm_db_missing_index_details

--last executed queries in the cache that contains where or joins and so on and the system is recommending indexes
-- but u gotta watch out from making indexes for everythig that u donnot really need 

--to MONITOR DDUPLICATE INDECES :
SELECT 
tbl.name AS TableName,
idx.name AS IndexName,
col.name AS IndexColumn,
idx.type_desc AS IndexType,
COUNT(*) OVER (PARTITION BY tbl.name,col.name) AS ColumnCount
FROM sys.indexes idx
JOIN sys.tables tbl 
    ON idx.object_id = tbl.object_id
JOIN sys.index_columns ic 
    ON idx.object_id = ic.object_id 
   AND idx.index_id = ic.index_id   
JOIN sys.columns col 
    ON ic.object_id = col.object_id 
   AND ic.column_id = col.column_id
ORDER BY ColumnCount DESC
-- to update statistics :
SELECT 
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName,
    s.name AS StatisticName,
    sp.last_updated AS LastUpdate,
    DATEDIFF(day, sp.last_updated, GETDATE()) AS LastUpdateDay,
    sp.rows AS 'Rows',
    sp.modification_counter AS ModificationsSinceLastUpdate
FROM sys.stats AS s
JOIN sys.tables t 
    ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
ORDER BY 
    sp.modification_counter DESC;

UPDATE STATISTICS Sales.DBCs
--this takes too much time but for the whole database:
EXEC sp_updatestats
--on weekends or after so much new data 

--DATA FREGMETATION :
SELECT 
    tbl.name AS TableName,
    idx.name AS IndexName,
    s.avg_fragmentation_in_percent,
    s.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS s
INNER JOIN sys.tables tbl
    ON s.object_id = tbl.object_id
INNER JOIN sys.indexes AS idx
    ON idx.object_id = s.object_id
   AND idx.index_id = s.index_id
ORDER BY s.avg_fragmentation_in_percent DESC;
--if percentage is more than 30% go and rebuild thee whole index but if less try to fix by :
ALTER INDEX idx_DBCs_CS ON Sales.DBCs REORGANIZE
--if moret than 50% :
ALTER INDEX idx_DBCs_CS ON Sales.DBCs REBUILD --Takes long time