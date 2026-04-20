-- ==============================================================
-- Ranking Analysis
-- ==============================================================
-- This script ranks products and customers based on their performance.
-- It identifies top-performing and worst-performing products by revenue,
-- as well as the highest-value customers. It also highlights customers
-- with the lowest engagement based on the number of orders placed.
-- Ranking is implemented using both TOP clauses and window functions
-- (ROW_NUMBER) for flexible analysis and comparison.
-- ==============================================================

-- Which 5 products generate the highest revenue ?
SELECT TOP 5
	p.product_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- OR

SELECT *
FROM (
	SELECT 
		p.product_name,
		SUM(f.sales_amount) total_revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount) DESC) product_rank
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
		ON p.product_key = f.product_key
	GROUP BY p.product_name
) t 
WHERE product_rank <= 5;

-- What are the 5 worst-performance products in terms of sales ?
SELECT TOP 5
	p.product_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC;

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(f.sales_amount) AS total_revenue_per_customer
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY 
	c.customer_key, 
	c.first_name, 
	c.last_name
ORDER BY total_revenue_per_customer DESC;

-- OR

SELECT * 
FROM (
	SELECT
		c.customer_key,
		c.first_name,
		c.last_name,
		SUM(f.sales_amount) AS total_revenue_per_customer,
		ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount) DESC) customer_rank
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
		ON c.customer_key = f.customer_key
	GROUP BY 
		c.customer_key, 
		c.first_name, 
		c.last_name
) T 
WHERE customer_rank <= 10;

-- The 3 customers with the fewest orders placed
SELECT TOP 3
	c.customer_key,
	c.first_name,
	c.last_name,
	COUNT(DISTINCT f.order_number) AS placed_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY 
	c.customer_key, 
	c.first_name, 
	c.last_name
ORDER BY placed_orders ASC;
