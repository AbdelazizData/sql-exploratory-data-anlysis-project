-- ======================================================================
-- Customer Report (Gold Layer View)
-- ======================================================================
/*
Purpose:
    This view consolidates customer-level analytics into a single dataset
    for reporting and dashboarding.

What it does:
    1. Combines sales and customer data into a unified base table.
    2. Aggregates customer behavior metrics such as:
        - Total orders
        - Total sales
        - Total quantity purchased
        - Product diversity (unique products bought)
        - Customer lifespan (in months)
    3. Enriches data with descriptive segmentation:
        - Age groups
        - Customer segments (VIP, Regular, New)
    4. Calculates key performance indicators (KPIs):
        - Recency (months since last purchase)
        - Average order value
        - Average monthly spend

This view is designed for customer analytics, segmentation, and reporting.
*/
-- ======================================================================

CREATE VIEW gold.report_customers AS

/* ---------------------------------------------------------------
1) Base Query: Retrieves core transactional and customer fields
---------------------------------------------------------------*/

WITH base_query AS (
SELECT 
    f.order_number,
    f.product_key,
    f.order_date,
    f.sales_amount,
    f.quantity,
    c.customer_key,
    c.customer_number,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    DATEDIFF(YEAR, c.birthdate, GETDATE()) AS age
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
WHERE f.order_date IS NOT NULL
),

/* ---------------------------------------------------------------
2) Customer Aggregation: Summarizes behavior at customer level
---------------------------------------------------------------*/

customer_aggregation AS (
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT product_key) AS total_products,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 
    customer_key,
    customer_number, 
    customer_name, 
    age
)

SELECT 
    customer_key,
    customer_number,
    customer_name,
    age,

    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 And Above'
    END AS age_group,

    CASE 
        WHEN total_sales > 5000 AND lifespan >= 12 THEN 'VIP'
        WHEN total_sales <= 5000 AND lifespan >= 12 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,

    total_orders,
    total_sales,
    total_quantity,
    total_products,
    last_order_date,

    DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency,
    lifespan,

    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_value,

    CASE 
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_spend

FROM customer_aggregation;
