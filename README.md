# SQL-in-Data-Engineering

---

## 📂 Repository Structure

| Folder / File | Description |
| :--- | :--- |
| `Data WareHouse/` | Contains DDL, DML, and ETL procedures for the Bronze, Silver, and Gold layers. |
| `Data Analysis/` | Business intelligence scripts, ad-hoc KPI queries, and executive metric summaries. |
| `SQL Rules&Syntax/` | Reference scripts covering data modeling rules, window functions, and SQL best practices. |
| `EDA.sql` | Exploratory Data Analysis queries used to inspect raw source file structures and data quality. |

---

## 🛠️ Data Warehouse Layers

### 1. Bronze Layer (Raw Ingestion)
* **Goal:** Direct ingestion of raw CSV files from CRM and ERP systems.
* **Implementation:** Built resilient bulk-loading stored procedures (`bronze.load_bronze`) with error handling, logging, and runtime execution metrics.

### 2. Silver Layer (Cleansing & Standardization)
* **Goal:** Cleaning, scrubbing, and enriching raw data into reliable datasets.
* **Key Operations:**
  * **Deduplication:** Used `ROW_NUMBER() OVER (PARTITION BY ...)` to remove duplicate entities.
  * **Normalization:** Standardized categories, product lines, and gender fields using `CASE` statements.
  * **Data Enrichment:** Applied `LEAD()` window functions to derive effective historical date ranges (`prd_end_dt`).
  * **Data Quality Checks:** Handled missing/invalid prices and replaced `NULL` values using conditional math (`sls_sales / NULLIF(sls_quantity, 0)`).

### 3. Gold Layer (Presentation & Analytics)
* **Goal:** Star schema design optimized for reporting and BI tools.
* **Key Components:**
  * **Dimensions:** `gold.dim_customers` and `gold.dim_products` featuring `ROW_NUMBER()` surrogate keys.
  * **Fact Table:** `gold.fact_sales` linking transactional measures back to Gold dimensions via business keys.
  * **Consolidated Reports:** `gold.report_customers` and `gold.report_products` views computing RFM metrics, customer lifespan, age groups, and revenue performance tiers (High/Mid/Low Performers).

---

## 📊 Key Business Reports Generated

* **Executive Dashboard:** Total Sales, Total Quantities, Average Order Value, Unique Order & Customer counts.
* **Customer Behavior Analytics:** Customer Lifetime Value (CLV), recency analysis, age demographic segmentation, and RFM grouping (VIP, Regular, New).
* **Product Performance Analytics:** Category/subcategory performance, top 5 best sellers, bottom 5 worst performers, and average order revenue (AOR).

---

## 🛠️ Tech Stack & Prerequisites

* **Database Engine:** Microsoft SQL Server (Local / Docker)
* **SQL Tools:** Azure Data Studio / SQL Server Management Studio (SSMS)
* **Language:** T-SQL
