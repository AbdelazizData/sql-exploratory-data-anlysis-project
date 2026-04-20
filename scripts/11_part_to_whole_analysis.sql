-- ================================================================
-- Category Contribution to Total Sales (Part-to-Whole Analysis)
-- ================================================================
-- This script analyzes how each product category contributes to
-- the overall sales performance of the business.
-- It calculates total sales per category and expresses each category's
-- contribution as a percentage of total sales, helping to identify
-- the most and least influential categories in revenue generation.
-- ================================================================

SELECT 
	category,
	total_sales,
	SUM(total_sales) OVER() AS overall_sales,
	CONCAT(
		ROUND(
			(CAST(total_sales AS FLOAT) / SUM(total_sales) OVER()) * 100, 2
		), '%'
	) AS percentage
FROM (
	SELECT 
		p.category,
		SUM(s.sales_amount) AS total_sales
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
		ON s.product_key = p.product_key
	GROUP BY p.category
) T
ORDER BY total_sales DESC;
