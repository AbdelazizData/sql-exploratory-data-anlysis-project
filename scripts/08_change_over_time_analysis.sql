-- ================================================================
-- Sales Performance Over Time (Trend Analysis / Change Over Time)
-- ================================================================
-- This script analyzes sales performance trends over time.
-- It aggregates key business metrics such as total sales, total quantity sold,
-- and number of unique customers on a monthly and yearly basis.
-- The goal is to understand how the business evolves over time and identify
-- seasonal patterns or long-term growth trends.
-- ================================================================

SELECT 
	YEAR(order_date) AS order_year,
	MONTH(order_date) AS order_month,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

-- OR

SELECT 
	DATETRUNC(month, order_date) AS order_date,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);
