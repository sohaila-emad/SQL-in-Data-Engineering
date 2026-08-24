--Indeces
--============================================================================================================================


--CLUSTERED vs NONCLUSTERED 
-- when you create a primary key , sql will autumatically create a clustered index by default 
SELECT *
FROM Sales.DBCs
WHERE CustomerID = 1 -- now its a HEAP cluster

CREATE CLUSTERED INDEX idx_DBCs_CustomerID ON Sales.DBCs (CustomerID) --CLUSTERED ROW STORE INDEX
--only one clustered index can be done per table 
DROP INDEX idx_DBCs_CustomerID ON Sales.DBCs

SELECT *
FROM Sales.DBCs
WHERE LastName = 'Brown'

--if your table are getting bigger and bigger by time and u wanna make a good performance when u search by some column and u already have the 
-- one clustered index , so u gotta make the non_clustered index by this column 

CREATE NONCLUSTERED INDEX idx_DBCs_LastName ON Sales.DBCs (LastName)
CREATE INDEX idx_DBCs_FirstName ON Sales.DBCs (FirstName)

SELECT *
FROM Sales.DBCs
WHERE Country = 'USA' AND Score >500 -- just like order on the index

CREATE INDEX idx_DBCs_CountryScore ON Sales.DBCs (Country, Score) -- watch out for the order of queries (columns)
-- if u skipped left col in the where (country only) the index will work (left part rule)
--=============================================================================================================================================

--COLUMN STORE vs ROW STORE 
-- if the column store is clustered then it wil replace the real table but if nonclustered it won't 
--so u can choose which cols in the nonclustered but not the same in clustered 
--u cannot specify the column when creating a CLUSTERED COLUMN STORE

CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCs_CS ON Sales.DBCs
--u canNOT create more than one CS index (clust /nonclust)
