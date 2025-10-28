# 🛍️ Retail Sales Analysis — SQL Project

**Database:** `p1_retail_db`  
**Language:** SQL (PostgreSQL)

This project demonstrates practical SQL skills used by data analysts to explore, clean, and analyze retail sales data.  
You’ll set up a database, run exploratory data analysis (EDA), and answer business questions with well-structured queries.

---

## 🎯 Objectives

1. **Database Setup:** Create and populate a clean retail sales schema.  
2. **Data Quality:** Enforce constraints and sanitize data.  
3. **EDA:** Understand data structure and key metrics.  
4. **Business Analysis:** Solve common stakeholder questions with SQL.

---

## 🧱 1) Database Setup

### Create Database and Table
```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales (
    transaction_id      BIGINT PRIMARY KEY,
    sale_date           DATE        NOT NULL,
    sale_time           TIME        NOT NULL,
    customer_id         BIGINT      NOT NULL,
    gender              VARCHAR(10) NOT NULL,
    age                 INT         NOT NULL CHECK (age BETWEEN 0 AND 120),
    category            VARCHAR(35) NOT NULL,
    quantity            INT         NOT NULL CHECK (quantity >= 0),
    price_per_unit      NUMERIC(12,2) NOT NULL CHECK (price_per_unit >= 0),
    cogs                NUMERIC(12,2) NOT NULL CHECK (cogs >= 0),
    total_sale          NUMERIC(14,2) GENERATED ALWAYS AS (quantity * price_per_unit) STORED
);

CREATE INDEX idx_retail_sales_date      ON retail_sales (sale_date);
CREATE INDEX idx_retail_sales_category  ON retail_sales (category);
CREATE INDEX idx_retail_sales_customer  ON retail_sales (customer_id);
```

---

## 🧹 2) Data Exploration & Cleaning

### Basic Counts
```sql
SELECT COUNT(*) AS row_count FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales;
SELECT DISTINCT category FROM retail_sales ORDER BY category;
```

### Null / Invalid Checks
```sql
SELECT *
FROM retail_sales
WHERE sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL;

DELETE FROM retail_sales
WHERE sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL;
```

### Light Standardization
```sql
UPDATE retail_sales SET gender = INITCAP(TRIM(gender));
UPDATE retail_sales SET category = TRIM(category);
```

---

## 📊 3) Business Analysis & Queries

### 1️⃣ Sales on a Specific Date
```sql
SELECT * FROM retail_sales
WHERE sale_date = DATE '2022-11-05';
```

### 2️⃣ Clothing Sales > 4 Units (Nov 2022)
```sql
SELECT * FROM retail_sales
WHERE category = 'Clothing'
  AND sale_date >= DATE '2022-11-01'
  AND sale_date <  DATE '2022-12-01'
  AND quantity > 4;
```

### 3️⃣ Total Sales per Category
```sql
SELECT category,
       SUM(total_sale) AS net_sales,
       COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category
ORDER BY net_sales DESC;
```

### 4️⃣ Average Age (Beauty Category)
```sql
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
```

### 5️⃣ High-Value Transactions
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000;
```

### 6️⃣ Transactions by Gender and Category
```sql
SELECT category,
       gender,
       COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY category, gender;
```

### 7️⃣ Best-Selling Month per Year
```sql
WITH monthly AS (
    SELECT
        EXTRACT(YEAR FROM sale_date)::INT AS year,
        EXTRACT(MONTH FROM sale_date)::INT AS month,
        SUM(total_sale) AS total_sales
    FROM retail_sales
    GROUP BY 1, 2
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY year ORDER BY total_sales DESC) AS rnk
    FROM monthly
)
SELECT year, month, total_sales
FROM ranked
WHERE rnk = 1
ORDER BY year;
```

### 8️⃣ Top 5 Customers by Sales
```sql
SELECT customer_id,
       SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

### 9️⃣ Unique Customers per Category
```sql
SELECT category,
       COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
ORDER BY unique_customers DESC;
```

### 🔟 Orders by Shift (Morning, Afternoon, Evening)
```sql
WITH hourly_sale AS (
    SELECT *,
           CASE
             WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
             WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 16 THEN 'Afternoon'
             ELSE 'Evening'
           END AS shift
    FROM retail_sales
)
SELECT shift,
       COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift
ORDER BY total_orders DESC;
```

---

## 📈 4) Key Findings

- **Demographics:** Broad age range; Clothing and Beauty dominate mid-age segments.  
- **Premium Orders:** Several high-value (> $1000) transactions indicate upscale demand.  
- **Seasonality:** Sales peak in specific months—useful for forecasting and inventory planning.  
- **Customer Value:** Top buyers drive a significant share of revenue.  
- **Category Reach:** Beauty and Clothing attract the most unique customers.

---

## 📑 5) Reports Generated

- **Sales Summary:** Total sales, average order value, and category performance.  
- **Trend Analysis:** Monthly and shift-level sales patterns.  
- **Customer Insights:** Top customers and category reach.

---

## ⚙️ 6) How to Use

1. **Clone the Repository.**  
2. **Set Up the Database:** Run `01_schema.sql` then `02_seed.sql`.  
3. **Run Queries:** Execute `03_analysis.sql`.  
4. **Explore:** Modify queries or visualize results in your BI tool.

---

## 💡 Future Enhancements

- Add profit margin column (`gross_margin = total_sale - (quantity * cogs_per_unit)`)  
- Normalize database (dim_customer, dim_product, fact_sales)  
- Implement views for dashboards  
- Integrate with Power BI or Tableau

---

## 👤 Author

**Pamvuabaw Masheni**  
*This project is part of my data analytics portfolio, showcasing SQL expertise for retail business insights.*

📩 Feel free to connect or share feedback!
