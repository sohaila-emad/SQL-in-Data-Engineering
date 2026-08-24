SELECT 
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) >1 OR  prd_id IS NULL
--CLEAN PK
SELECT 
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key, 1,5),'-','_') AS cat_id,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
FROM bronze.crm_prd_info
WHERE REPLACE(SUBSTRING(prd_key, 1,5),'-','_') NOT IN 
(SELECT DISTINCT id FROM bronze.erp_px_cat_g1v2)
--CO_PE is not in the erp_px_cat_g1v2

SELECT DISTINCT id FROM bronze.erp_px_cat_g1v2

SELECT 
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key, 1,5),'-','_') AS cat_id,
SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
FROM bronze.crm_prd_info
WHERE SUBSTRING(prd_key, 7, LEN(prd_key)) NOT IN 
(SELECT DISTINCT id FROM bronze.erp_px_cat_g1v2)
--alot of prds donot have orders

SELECT 
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key, 1,5),'-','_') AS cat_id,
SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
FROM bronze.crm_prd_info

SELECT prd_nm 
FROM silver.crm_prd_info
WHERE TRIM(prd_nm) != prd_nm
--fine from unwanted spaces

SELECT
	prd_id,
	prd_cost
FROM silver.crm_prd_info
WHERE prd_cost <0 OR prd_cost IS NULL

SELECT 
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key, 1,5),'-','_') AS cat_id,
SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
prd_nm,
ISNULL (prd_cost,0) AS prd_cost,
CASE UPPER(TRIM(prd_line))
	WHEN 'M' THEN 'Mountain'
	WHEN 'R' THEN 'Road'
	WHEN 'T' THEN 'Touring'
	WHEN 'S' THEN 'Other Sales'
	ELSE 'n/a'
END AS prd_line,
prd_start_dt,
prd_end_dt
FROM bronze.crm_prd_info

SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt> prd_end_dt OR prd_start_dt IS NULL
--checking if the starting date is valid and smaller than the end one 

SELECT *,
	LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt ASC)-1 AS prd_end_dt_cor
FROM bronze.crm_prd_info
WHERE prd_start_dt> prd_end_dt OR prd_start_dt IS NULL

SELECT 
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1,5),'-','_') AS cat_id,
	SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
	prd_nm,
	ISNULL (prd_cost,0) AS prd_cost,
	CASE UPPER(TRIM(prd_line))
		WHEN 'M' THEN 'Mountain'
		WHEN 'R' THEN 'Road'
		WHEN 'T' THEN 'Touring'
		WHEN 'S' THEN 'Other Sales'
		ELSE 'n/a'
	END AS prd_line,
	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt ASC)-1 AS DATE) AS prd_start_dt
FROM bronze.crm_prd_info
