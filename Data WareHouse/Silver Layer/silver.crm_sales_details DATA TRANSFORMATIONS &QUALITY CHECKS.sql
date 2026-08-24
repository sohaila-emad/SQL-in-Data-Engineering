SELECT 
       sls_ord_num
      ,sls_prd_key
      ,sls_cust_id
      ,sls_order_dt
      ,sls_ship_dt
      ,sls_due_dt
      ,sls_sales
      ,sls_quantity
      ,sls_price
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)

SELECT 
       sls_ord_num
      ,sls_prd_key
      ,sls_cust_id
      ,sls_order_dt
      ,sls_ship_dt
      ,sls_due_dt
      ,sls_sales
      ,sls_quantity
      ,sls_price
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info)
--CONNECTIONS are right 

SELECT
NULLIF (sls_order_dt,0) AS sls_order_dt
FROM silver.crm_sales_details
WHERE sls_order_dt <= 0 OR LEN(sls_order_dt) != 8
--32154 AND 5489

SELECT 
NULLIF (sls_order_dt,0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt > 20301229 OR sls_order_dt < 19001229

SELECT
NULLIF (sls_order_dt,0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 
    OR LEN(sls_order_dt) != 8
    OR sls_order_dt > 20301229 
    OR sls_order_dt < 19001229

SELECT 
       sls_ord_num
      ,sls_prd_key
      ,sls_cust_id
      ,CASE WHEN sls_order_dt <=0 OR LEN(sls_order_dt) != 8 THEN NULL 
          ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
        END AS sls_order_dt
      ,CASE WHEN sls_ship_dt <=0 OR LEN(sls_ship_dt) != 8 THEN NULL 
          ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
        END AS sls_ship_dt
      ,CASE WHEN sls_due_dt <=0 OR LEN(sls_due_dt) != 8 THEN NULL 
          ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
        END AS sls_due_dt
      ,sls_sales
      ,sls_quantity
      ,sls_price
FROM bronze.crm_sales_details

SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_due_dt OR sls_order_dt > sls_ship_dt

SELECT *
FROM silver.crm_sales_details
WHERE sls_sales != sls_price * sls_quantity 
    OR (sls_sales* sls_price * sls_quantity ) <=0
    OR sls_sales IS NULL OR sls_price IS NULL OR sls_quantity IS NULL

SELECT 
       sls_ord_num
      ,sls_prd_key
      ,sls_cust_id
      ,CASE WHEN sls_order_dt <=0 OR LEN(sls_order_dt) != 8 THEN NULL 
          ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
        END AS sls_order_dt
      ,CASE WHEN sls_ship_dt <=0 OR LEN(sls_ship_dt) != 8 THEN NULL 
          ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
        END AS sls_ship_dt
      ,CASE WHEN sls_due_dt <=0 OR LEN(sls_due_dt) != 8 THEN NULL 
          ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
        END AS sls_due_dt
      ,CASE WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales!= sls_quantity * sls_price THEN sls_quantity * ABS(sls_price)
            ELSE sls_sales
       END AS sls_sales
      ,sls_quantity
      ,CASE 
            WHEN sls_price <= 0 THEN ABS(sls_price)
            WHEN sls_price IS NULL THEN sls_sales / NULLIF (sls_quantity ,0)
            ELSE sls_price
        END AS sls_price
FROM bronze.crm_sales_details



