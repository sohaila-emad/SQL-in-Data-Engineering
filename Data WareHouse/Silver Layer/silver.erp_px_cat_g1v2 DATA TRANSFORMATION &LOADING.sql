TRUNCATE TABLE silver.erp_px_cat_g1v2
INSERT INTO silver.erp_px_cat_g1v2(id, cat, subcat, maintenance)
SELECT * FROM bronze.erp_px_cat_g1v2

--quality checks
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE TRIM(cat) != cat
OR TRIM(subcat) != subcat
OR TRIM(maintenance) != maintenance
--no unwanted spaces 

SELECT DISTINCT cat FROM bronze.erp_px_cat_g1v2
SELECT DISTINCT maintenance FROM bronze.erp_px_cat_g1v2
--data normalized 

SELECT * FROM silver.erp_px_cat_g1v2