
# 🛒 TheLook E-Commerce: End-to-End Analytics Engineering & Business Intelligence

## Executive summary:

This project demonstrates an end-to-end analytics engineering pipeline using Google BigQuery and dbt to transform raw e-commerce data into a structured, production-ready data warehouse for downstream analytics.
[In progress..]

## 📋 Table of Contents
* [🛠️ The Tech Stack](#-the-tech-stack)
* [🏗️ Architecture & Data Pipeline](#-architecture--data-pipeline)
* [🧪 Data Quality & Governance](#-data-quality--governance)
* [🔎 Exploratory Data Analysis (EDA) & Insights](#-exploratory-data-analysis-eda--insights)
  
[In progress..]



## 🛠️ The Tech Stack

- **Data Warehouse:** Google BigQuery
- **Data Transformation & Modeling:** dbt Cloud (SQL)
- **Exploratory Data Analysis (EDA):** Python (Pandas, Matplotlib, Seaborn)
  
[In progress..]

## 🏗️ Architecture & Data Pipeline
The data pipeline processes raw e-commerce transaction data stored in **Google BigQuery** using **dbt (data build tool)** in the following layers:
* **Raw Layer (source):** Transactional source data in BigQuery.
* **Staging (`stg_`):** Cleans, renames and standardizes raw data while maintaining the original level of detail.
* **Intermediate (`int_`):**  Handles all heavy calculations and business logic in one place, so downstream models stay clean and easy to build.
* **Marts (`fct_`, `dim_`):** Transforms cleaned data into business-ready fact and dimension models for analytics and reporting.

<div align="center">
<img width="1000" height="500" alt="dbt_DAG" src="https://github.com/user-attachments/assets/d7d6f7bf-e88d-4385-9a61-8d792052529c" />
</div>


## 🧪 Data Quality & Governance
### Raw Layer (source)
 To ensure data integrity, automated tests and freshness checks are applied directly at the source layer:
* **Source Testing:** Applied `unique` and `not_null` on primary keys, and `not_null` on important foreign keys.
* **Source Freshness:** Used `dbt source freshness` to detect delayed or missing sources. 
### Staging Layer (`stg_`)
#### Standardized raw data using SQL
* **Renamed Columns:** Used clear `snake_case` names (e.g., `id` to `user_id`).
* **Reordered Columns:** Arranged columns logically (category -> brand -> product_name)
* **Fixed Data Types:** Converted columns using `CAST()` (e.g., IDs to `STRING`, numbers to `NUMERIC`).
* **Cleaned Values:** Removed extra spaces with `TRIM()` and replaced missing values using `COALESCE()`.
* **Edge Cases**:
  * **(`stg_products`):** Fixed 2 sold products with missing names using `COALESCE(name, CAST(id AS STRING))` in SQL while leaving a `not_null` test to catch future issues.
  * **(`stg_users`):** Standardized localized country names (e.g., `'España'` -> `'Spain'`).

#### Created automated tests on the staging layer
* **Keys:** Applied `unique` and `not_null` on primary keys, and `not_null` on important foreign keys (like `order_id` in `stg_order_items`).
* **Core Fields:** Set `not_null` on critical business fields like dates, cost, and prices and used `accepted_values` to make sure categorical fields only contain allowed values.

  
### Intermediate Layer (`int_`):
* **Financial Calculations**: Calculated item profit (sale_price - cost) in one place to ensure consistent logic while adding key columns for downstream models to inherit.
* **Automated tests**: Created automated tests on the intermediate layer such as `unique` and `not_null` on the primary key and `not_null` on foreign keys.

 > 💡**Note:** During the EDA phase, I realized that analyzing user demographics required standardized age segmentation. Instead of performing manual transformations in Pandas, I  went back and added the `age_group` logic directly into the Intermediate layer in **dbt**, so downstream models can inherit it. This ensures consistent data modeling across the warehouse and optimizes downstream query performance by eliminating redundant JOINs.


### Marts Layer (`fct_`, `dim_`):
#### Transformed clean data into structured business models for analysis while creating calculated attributes to minimize runtime by reducing JOINs and GROUP BY operations

 **Fact Tables (`fct_`):** Tables that store key metrics and numbers to measure business performance:
  * `fct_order_items`: Tracks sold items, revenue, and profit for every item in an order.
  * `fct_sessions`: Tracks web traffic sources (like YouTube or Search) and conversion funnels per user session.
  * `fct_inventory_items`: Tracks inventory status and how many days items stay in the warehouse.

**Dimension Tables (`dim_`):** Tables that provide details and context around the business entities:
  * `dim_users`: Contains customer profiles and overall spending habits.
  * `dim_products`: Holds product details like category, brand, and retail price.
  * `dim_orders`: Summarizes total order amounts and total items to avoid heavy group-by queries.

#### Created automated tests on the marts layer
* **Keys:**  Applied `unique` and `not_null` on primary keys to prevent duplicate or missing records.
* **Table Connections (`relationships`):** Verified that IDs in the fact tables (like `user_id` or `product_id`) exist in our main source tables (`stg_`), so we don't end up with orders linked to missing users or products.
* **Logical Checks (`dbt_utils`):** Added basic sanity checks (using `dbt_utils.expression_is_true`) to make sure the data makes sense - like ensuring prices and session lengths aren't negative, and that every session has at least one event.



## 🔎 Exploratory Data Analysis (EDA) & Insights
### 🎯 Main Business Question
> **"How can we grow company revenue and profits by focusing on the right countries and personalizing products for different customer groups?"**

In this section, i use Python (**Pandas**, **NumPy**, **Seaborn**, and **Matplotlib**) to analyze our data, test ideas, and find clear answers to this question.

*(The full step-by-step code execution is available in the [Google Colab Notebook](https://colab.research.google.com/drive/1A_9QnODzxgoPB1bAtr29iZjU3xE6st6m#scrollTo=L6gn22CVZgPX))*

#### 🧱 Tables Used for Analysis
I run this analysis using our cleaned dbt models loaded directly from **Google BigQuery**:
* **`dim_users`**: Information about customers (age, gender, country) and how much they spend.
* **`dim_products`**: Product details (category, brand, price).
* **`dim_orders`**: General order details and order statuses.
* **`fct_order_items`**: Detailed sales data, item prices, costs, and profit calculations.
*  
### 🛠️ Data Preparation 
Before diving into the analysis, i made sure the data was clean, correct, and ready to use:
- **Check Data Structure:** Used `.shape`, `.info()`, and `.head()` to verify table sizes, columns, and initial rows.
- **Fix Data Types:** Fixed BigQuery import issues by converting financial columns from `object` back to `float64` and standardizing dates to `datetime64[ns]`.

