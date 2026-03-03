# Northwind Analytics Warehouse  
## Dimensional Modeling with dbt & Databricks

---

## 📌 Project Overview

This project implements a production-style dimensional data warehouse using the Northwind dataset.

The objective was to design and deploy a clean **star schema architecture** using modern data engineering tooling, with proper separation of layers, surrogate key management, CI/CD automation, and Unity Catalog integration.

The stack includes:

- Airbyte for ingestion
- Databricks (Unity Catalog + Delta)
- dbt for transformation & modeling
- Databricks Asset Bundles for deployment
- GitHub Actions for CI/CD

This project focuses on architecture discipline and dimensional modeling best practices rather than simple SQL transformations.

---

## 🏗 Architecture

The pipeline follows a layered medallion-style approach:

Bronze (Raw Ingestion)  
→ Staging (Cleaned & standardized models)  
→ Serving (Star Schema: facts + dimensions)

Airbyte lands raw data into Databricks.  
dbt builds structured models on top of that raw layer.

---

## 📂 Data Layers

### Bronze Layer
Raw tables ingested by Airbyte.

- No transformations
- Full fidelity of source data
- Used as the foundation for staging models

---


### Serving Layer (Star Schema)

Materialization: `table`

This layer contains the dimensional warehouse.

---

## ⭐ Dimensional Model

### 🎯 Fact Table

#### `fact_sales`

**Grain:**  
1 row per order line (`order_id + product_id`)

**Measures:**
- quantity
- unit_price
- discount
- gross_sales
- total_sales

**Foreign Keys (Surrogate):**
- product_key
- customer_key
- employee_key

Fact table stores surrogate keys from dimension tables.  
It does not regenerate surrogate keys for dimensions.

---

### 📦 Dimension Tables

#### `dim_customers`
- customer_key (surrogate key)
- customer_id (natural key)
- company_name
- region
- country

#### `dim_products`
- product_key
- product_id
- product_name
- category
- supplier

#### `dim_employees`
- employee_key
- employee_id
- employee_name

---

## 🔑 Surrogate Key Strategy

Surrogate keys are generated using:

Properties:

- Deterministic (same input → same output)
- Stable across runs
- Safe for incremental merges
- Prevents dependency on source system keys

Fact tables reference dimension surrogate keys via joins.  
Surrogate keys are owned by dimension models.

---

## 🧪 Data Quality & Testing

dbt tests implemented:

- not_null
- unique
- relationships (referential integrity)

Examples:

- customer_key must be unique
- product_key must not be null
- fact_sales.customer_key must exist in dim_customers

Testing ensures structural integrity before serving layer is built.

---

## ⚙️ CI/CD Pipeline

GitHub Actions workflow:

- Triggered on push (excluding main)
- Runs `databricks bundle validate`
- Runs `databricks bundle deploy`
- Deploys to dev environment

Deployment does not automatically execute jobs to avoid unnecessary compute costs.

---

## 🚀 Deployment

Databricks Asset Bundles used for environment management.

Commands:
- databricks bundle validate
- databricks bundle deploy
## 🔮 Potential Improvements

- Incremental fact table (merge strategy)
- Slowly Changing Dimensions (Type 2)
- Date dimension
- Freight allocation logic
- Production deployment target
- Metrics layer / semantic model

---

## 🧰 Technology Stack

- SQL
- dbt
- Databricks
- Unity Catalog
- Airbyte
- GitHub Actions

---
