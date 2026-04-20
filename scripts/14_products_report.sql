-- ===============================================================================
-- Product Report (Gold Layer View)
-- ===============================================================================
/*
Purpose:
    This view consolidates product-level analytics into a structured dataset
    for reporting, dashboards, and performance analysis.

What it does:
    1. Combines sales and product master data into a unified base dataset.
    2. Aggregates product performance metrics such as:
        - Total orders
        - Total sales revenue
        - Total quantity sold
        - Unique customers per product
        - Product lifespan (in months)
    3. Adds performance segmentation based on revenue:
        - High-Performance
        - Mid-Range
        - Low-Performance
    4. Calculates key KPIs:
        - Recency (months since last sale)
        - Average selling price
        - Average order revenue (AOR)
        - Average monthly revenue

This view supports product performance tracking, inventory decisions,
and revenue optimization analysis.
*/
-- ===============================================================================

CREATE VIEW gold.report_products AS

/* ---------------------------------------------------------------
1) Base Query: Retrieves core product and sales attributes
---------------------------------------------------------------*/

WITH base_query AS (
SELECT
    f.order_number,
    f.order_date,
    f.customer_key,
    f.sales_amount,
    f.quantity,
    p.product_key,
    p.product_name,
    p.category,
    p.subcategory,
    p.cost
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
WHERE f.order_date IS NOT NULL
),

/* ---------------------------------------------------------------
2) Product Aggregation: Summarizes performance per product
---------------------------------------------------------------*/

product_aggregation AS (
SELECT 
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT customer_key) AS total_customers,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
    ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_selling_price
FROM base_query
GROUP BY 
    product_key,
    product_name,
    category,
    subcategory,
    cost
)

SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_order_date,

    DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency_in_month,

    CASE 
        WHEN total_sales > 50000 THEN 'High-Performance'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performance'
    END AS product_segment,

    lifespan,
    avg_selling_price,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,

    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_revenue,

    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_revenue

FROM product_aggregation;
