-- ================================================================
-- Product Performance Analysis (Year-over-Year & Average Comparison)
-- ================================================================
-- This script evaluates yearly product performance by comparing each
-- product's sales against its historical average and its previous year's sales.
-- It highlights whether a product is performing above or below its average
-- and identifies year-over-year growth trends (increase, decrease, or no change).
-- This analysis helps track product performance consistency and detect trends over time.
-- ================================================================

SELECT 
	order_year,
	product_name,
	total_sales,
	AVG(total_sales) OVER(PARTITION BY product_name) AS avg_sales,
	total_sales - AVG(total_sales) OVER(PARTITION BY product_name) AS diff_avg,
	CASE 
		WHEN total_sales - AVG(total_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg' 
		WHEN total_sales - AVG(total_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
		ELSE 'Avg'
	END AS avg_change,
	COALESCE(LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year), 0) AS prev_year_sales,
	total_sales - COALESCE(LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year), 0) AS diff_prev_year,
	CASE 
		WHEN total_sales - COALESCE(LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year), 0) > 0 THEN 'Increase'
		WHEN total_sales - COALESCE(LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year), 0) < 0 THEN 'Decrease'
		ELSE 'No Change'
	END AS prev_change
FROM (
	SELECT
		YEAR(s.order_date) AS order_year,
		p.product_name,
		SUM(s.sales_amount) AS total_sales
	FROM gold.fact_sales s 
	LEFT JOIN gold.dim_products p 
		ON p.product_key = s.product_key
	WHERE order_date IS NOT NULL
	GROUP BY p.product_name, YEAR(s.order_date)
) T;

-- OR

WITH yearly_products_sales AS (
	SELECT
		YEAR(s.order_date) AS order_year,
		p.product_name,
		SUM(s.sales_amount) AS total_sales
	FROM gold.fact_sales s 
	LEFT JOIN gold.dim_products p 
		ON p.product_key = s.product_key
	WHERE order_date IS NOT NULL
	GROUP BY YEAR(s.order_date), p.product_name
)

SELECT 
	order_year,
	product_name,
	total_sales,
	AVG(total_sales) OVER(PARTITION BY product_name) AS avg_sales,
	total_sales - AVG(total_sales) OVER(PARTITION BY product_name) AS diff_avg,
	CASE 
		WHEN total_sales - AVG(total_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg' 
		WHEN total_sales - AVG(total_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
		ELSE 'Avg' 
	END AS avg_change,
	COALESCE(LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year), 0) AS prev_year_sales,
	total_sales - COALESCE(LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year), 0) AS diff_prev_year,
	CASE 
		WHEN total_sales - COALESCE(LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year), 0) > 0 THEN 'Increase'
		WHEN total_sales - COALESCE(LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year), 0) < 0 THEN 'Decrease'
		ELSE 'No Change'
	END AS prev_change
FROM yearly_products_sales
ORDER BY product_name, order_year;
