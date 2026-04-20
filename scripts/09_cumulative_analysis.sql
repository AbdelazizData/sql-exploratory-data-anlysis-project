-- ================================================================
-- Cumulative Sales Analysis (Running Totals Over Time)
-- ================================================================
-- This script calculates total sales per month and performs cumulative analysis
-- using window functions. It computes running totals of sales and the running
-- average price over time to help understand business growth trends and
-- how performance accumulates month by month.
-- ================================================================

SELECT 
	order_date,
	total_sales,
	SUM(total_sales) OVER(
		ORDER BY order_date
	) AS running_total_sales,
	AVG(avg_price) OVER(
		ORDER BY order_date
	) AS running_avg_price
FROM (
	SELECT 
		DATETRUNC(MONTH, order_date) AS order_date,
		SUM(sales_amount) AS total_sales,
		AVG(price) AS avg_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(MONTH, order_date)
) T;
