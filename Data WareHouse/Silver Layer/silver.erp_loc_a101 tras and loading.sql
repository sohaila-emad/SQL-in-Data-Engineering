TRUNCATE TABLE silver.erp_loc_a101;
INSERT INTO silver.erp_loc_a101(cid, cntry)
SELECT 
	REPLACE(cid, '-', '') AS cid,
	CASE  
		WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		WHEN TRIM(cntry) IN ('US', 'United States') THEN 'USA'
		WHEN TRIM(cntry) ='' or cntry IS NULL THEN 'n/a'
		ELSE TRIM(cntry)
	END AS cntry
FROM bronze.erp_loc_a101



SELECT DISTINCT cntry FROM (SELECT 
	REPLACE(cid, '-', '') AS cid,
	CASE  
		WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		WHEN cntry IN ('US', 'United States') THEN 'USA'
		WHEN TRIM(cntry) ='' or cntry IS NULL THEN 'n/a'
		ELSE cntry
	END AS cntry
FROM bronze.erp_loc_a101)t