# Retail EDA: Sales, Product & Customer Insights on Olist E-Commerce

SQL-based EDA project built on top of the **Gold layer** of the [Olist Retail Data Warehouse](https://github.com/lawira/olist-data-warehouse). Analyzes a Brazilian e-commerce dataset across customers, products, orders, and payments using a Galaxy Schema.

---

## 📁 Project Structure

```
├── business_key_metrics.sql   # High-level KPIs of the business
├── magnitude_analysis.sql     # Distribution and grouping analysis
├── ranking_analysis.sql       # Top/bottom performers (products & customers)
└── summary_statistics.sql     # Statistical summary of payment/sales data
```

---

## 🗄️ Data Source

All queries consume **Gold layer views** from the `gold` schema of the [olist-data-warehouse](https://github.com/lawira/olist-data-warehouse) project, which implements a **Galaxy Schema** (Fact Constellation) built on top of the [Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

### Gold Layer Schema

**Dimension Views**

| View | Description | Surrogate Key |
|---|---|---|
| `gold.dim_customers` | Customer info enriched with geolocation (state, city) | `customer_key` |
| `gold.dim_sellers` | Seller info enriched with geolocation | `seller_key` |
| `gold.dim_products` | Product details with English category translation | `product_key` |
| `gold.dim_dates` | Calendar dimension (2016–2018), sourced from Silver | `date_key` (YYYYMMDD INT) |

**Fact Views**

| View | Granularity | Key Columns Used in EDA |
|---|---|---|
| `gold.fact_orders` | One row per order | `order_key`, `customer_key` |
| `gold.fact_order_items` | One row per item per order | `order_key`, `product_key`, `price`, `freight_value` |
| `gold.fact_payments` | One row per payment per order | `order_key`, `payment_value` |
| `gold.fact_reviews` | One row per review per order | `order_key`, `review_score` |

**Schema Relationships**

```
               dim_customers
                    │
dim_dates ────── fact_orders ────── fact_order_items ──── dim_products
                    │                                  └── dim_sellers
                    ├── fact_payments
                    └── fact_reviews
```

---

## 🔍 Analysis Breakdown

### 1. `business_key_metrics.sql` — Key Performance Indicators

Produces a single unified KPI report using `UNION ALL`:

| Measure | Logic |
|---|---|
| Total Sales | `SUM(payment_value)` from `fact_payments` |
| Total Items Sold | `COUNT(order_key)` from `fact_order_items` |
| Average Price | `AVG(price)` from `fact_order_items` |
| Total Orders | `COUNT(order_key)` from `fact_orders` |
| Total Products | `COUNT(DISTINCT product_key)` from `fact_order_items` |
| Total Customers | `COUNT(customer_key)` from `dim_customers` |
| Total Customer Orders | `COUNT(DISTINCT customer_key)` from `fact_orders` |

---

### 2. `magnitude_analysis.sql` — Distribution & Grouping

Explores how key metrics are distributed across dimensions:

| Query | Dimensions | Tables Joined |
|---|---|---|
| Customers by state | `state` | `dim_customers` |
| Customers by city | `city` | `dim_customers` |
| Products by category | `category_name` | `dim_products` |
| Average price by category | `category_name` | `fact_order_items` → `dim_products` |
| Average freight by category | `category_name` | `fact_order_items` → `dim_products` |
| Revenue by category | `category_name` | `fact_payments` → `fact_order_items` → `dim_products` |
| Revenue by customer | `unique_id` | `fact_payments` → `fact_orders` → `dim_customers` |
| Items sold by state | `state` | `fact_orders` → `dim_customers` → `fact_order_items` |
| Items sold by city | `city` | `fact_orders` → `dim_customers` → `fact_order_items` |

---

### 3. `ranking_analysis.sql` — Rankings

Identifies top and bottom performers using `TOP N` queries (T-SQL):

| Query | N | Ranked By |
|---|---|---|
| Top products by revenue | 5 | `SUM(payment_value)` DESC |
| Worst products by revenue | 5 | `SUM(payment_value)` ASC |
| Top customers by spending | 10 | `SUM(payment_value)` DESC |
| Customers with fewest orders | 3 | `COUNT(order_id)` ASC |

---

### 4. `summary_statistics.sql` — Statistical Summary of Sales

Computes a full descriptive statistics profile for `payment_value` across all transactions:

| Statistic | Method |
|---|---|
| Total Sales | `SUM` |
| Minimum Sale | `MIN` |
| Maximum Sale | `MAX` |
| Mean | `AVG` |
| Median | Manual CTE using `ROW_NUMBER()` for even/odd row handling |
| Standard Deviation | `STDEVP` (population) |
| Coefficient of Variation | `(STDEVP / AVG) * 100` |

> **Note:** The median is computed via a multi-step CTE chain — `rowCTE` assigns row positions, `formulaCTE` identifies the middle index, and `medianCTE` resolves the value for both even and odd record counts.

---

## ⚙️ Prerequisites

| Requirement | Detail |
|---|---|
| SQL Engine | Microsoft SQL Server or Azure SQL Database (T-SQL syntax) |
| Data Warehouse | [olist-data-warehouse](https://github.com/lawira/olist-data-warehouse) Gold layer deployed |
| Schema | `gold` schema with all 4 fact views and 4 dimension views created |

> The Gold layer is **view-only** (no physical tables except `dim_dates` which is materialized in Silver). No ETL load is required before running these queries.

---

## 🚀 How to Use

1. Deploy the [olist-data-warehouse](https://github.com/lawira/olist-data-warehouse) project and ensure the `gold` schema is available
2. Connect to your SQL Server instance via SSMS, Azure Data Studio, or similar
3. Run each `.sql` file independently — they are self-contained and have no dependencies on each other
4. Use the outputs as a foundation for dashboards (Power BI, Tableau) or further analytical work

---

## 🔗 Related

- [Olist Data Warehouse](https://github.com/lawira/olist-data-warehouse) — upstream data warehouse this project queries
- [Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — original source data on Kaggle

---

## 🛡️ License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.

---

## 🤖 About Me

Hi there! I'm **Ari Wira Putra**, also known as **Wira**. I’m a Data Analyst.
