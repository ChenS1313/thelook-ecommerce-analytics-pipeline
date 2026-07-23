# 🛒 TheLook E-Commerce: End-to-End Analytics Engineering & Business Intelligence

## Executive summary:

This project demonstrates an end-to-end analytics engineering pipeline using Google BigQuery and dbt to model raw e-commerce data into a Star Schema for downstream analytics.

## 🛠️ The Tech Stack

- **Data Warehouse:** Google BigQuery
- **Data Transformation & Modeling:** dbt Cloud (SQL)


## 🏗️ Architecture & Data Pipeline
The data pipeline processes raw e-commerce transaction data stored in Google BigQuery
[IN PROGRESS..]


## 🧪 Data Quality & Governance
To ensure data integrity, automated tests and freshness checks are applied directly at the source layer:
* **Source Testing:** Applied `unique` and `not_null` tests to raw primary keys and validated relationships between tables.
* **Source Freshness:** Used `dbt source freshness` to detect delayed or missing source data.
[IN PROGRESS..]

