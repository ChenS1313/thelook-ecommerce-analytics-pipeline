# 🛒 TheLook E-Commerce: End-to-End Analytics Engineering & Business Intelligence

## Executive summary:

This project demonstrates an end-to-end analytics engineering pipeline using Google BigQuery and dbt to model raw e-commerce data into a Star Schema for downstream analytics.


## 📋 Table of Contents
* [🏗️ Architecture & Data Pipeline](#-architecture--data-pipeline)
* [🧪 Data Quality & Governance](#-data-quality--governance)



## 🛠️ The Tech Stack

- **Data Warehouse:** Google BigQuery
- **Data Transformation & Modeling:** dbt Cloud (SQL)


## 🏗️ Architecture & Data Pipeline
The data pipeline processes raw e-commerce transaction data stored in Google BigQuery in the following layers:
* **Raw Layer (source):** Transactional source data in BigQuery.
* **Staging (`stg_`):** Cleans, renames, and standardizes raw data while maintaining the original table granularity (1:1).
* **Marts (`fct_`, `dim_`):** Transforms clean staging data into easy-to-use business tables following Kimball methodology.


## 🧪 Data Quality & Governance
### Raw Layer (source)
 To ensure data integrity, automated tests and freshness checks are applied directly at the source layer:
* **Source Testing:** Applied `unique` and `not_null` on primary keys, and `not_null` on foreign keys.
* **Source Freshness:** Used `dbt source freshness` to detect delayed or missing sources. 
### Staging Layer (`stg_`)
#### Standardized raw data using SQL
* **Renamed Columns:** Used clear `snake_case` names (e.g., `id` to `user_id`).
* **Reordered Columns:** Arranged columns logically (category -> brand -> product_name)
* **Fixed Data Types:** Converted columns using `CAST()` (e.g., IDs to `STRING`, numbers to `NUMERIC`).
* **Cleaned Values:** Removed extra spaces with `TRIM()` and replaced missing values using `COALESCE()`.

#### Created automated tests on the staging layer
* **Keys:** Applied `unique` and `not_null` on primary keys, and `not_null` on foreign keys.
* **Core Fields:** Set `not_null` on critical business fields like dates, cost, and prices and used `accepted_values` to make sure categorical fields only contain allowed values.
* **Edge Case (`stg_products`):** Fixed 2 sold products with missing names using `COALESCE(name, CAST(id AS STRING))` in SQL while leaving a `not_null` test to catch future issues.



### Marts Layer (`fct_`, `dim_`):
#### Transformed clean data into structured business models for analysis
 **Fact Tables (`fct_`):** Tables that store key metrics and numbers to measure business performance:
  * `fct_order_items`: Tracks sold items, revenue, and profit for every item in an order.
  * `fct_sessions`: Tracks web traffic sources (like YouTube or Search) and conversion funnels per user session.
  * `fct_inventory_items`: Tracks inventory status and how many days items stay in the warehouse.

**Dimension Tables (`dim_`):** Tables that provide details and context around the business entities:
 * `dim_users`: Contains customer profiles and overall spending habits.
  * `dim_products`: Holds product details like category, brand, and retail price.
  * `dim_orders`: Summarizes total order amounts and total items to avoid heavy group-by queries.
 [IN PROGRESS...]