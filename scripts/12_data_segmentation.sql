-- ================================================================
-- Data Segmentation Analysis
-- ================================================================
-- This script performs segmentation analysis on both products and customers.
-- It groups products into cost-based ranges to understand product distribution,
-- and classifies customers into behavioral segments (VIP, Regular, New)
-- based on spending patterns and customer lifespan.
-- This helps in identifying high-value customers and understanding product pricing structure.

-- Segment products into cost ranges and 
-- count how many products fall into each segment

WITH product_segments AS (
	SELECT 
		product_key,
		product_name,
		cost,
		CASE 
			WHEN cost < 100 THEN 'Below 100'
			WHEN cost BETWEEN 100 AND 500 THEN '100-500'
			WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
			ELSE 'Above 1000'
		END AS cost_range
	FROM gold.dim_products
)

SELECT
	cost_range,
	COUNT(product_key) AS total_products
FROM product_segments 
GROUP BY cost_range 
ORDER BY total_products DESC;


-- Group customers into three segments based on their spending behavior:
-- VIP: Customers with at least 12 months of history and spending > $5,000
-- Regular: Customers with at least 12 months of history and spending ≤ $5,000
-- New: Customers with a lifespan less than 12 months
-- And find the total number of customers by each group

WITH customers_spending AS (
	SELECT 
		c.customer_key,
		SUM(s.sales_amount) AS total_spending,
		MIN(order_date) AS first_order,
		MAX(order_date) AS last_order,
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_customers c
		ON s.customer_key = c.customer_key
	GROUP BY c.customer_key
)

-- Detailed view per customer
SELECT 
	customer_key,
	total_spending,
	lifespan,
	CASE 
		WHEN total_spending > 5000 AND lifespan >= 12 THEN 'VIP'
		WHEN total_spending <= 5000 AND lifespan >= 12 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment
FROM customers_spending
ORDER BY customer_segment;

-- OR (Segment summary)

SELECT 
	CASE 
		WHEN total_spending > 5000 AND lifespan >= 12 THEN 'VIP'
		WHEN total_spending <= 5000 AND lifespan >= 12 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,
	COUNT(customer_key) AS total_customers
FROM customers_spending
GROUP BY 
	CASE 
		WHEN total_spending > 5000 AND lifespan >= 12 THEN 'VIP'
		WHEN total_spending <= 5000 AND lifespan >= 12 THEN 'Regular'
		ELSE 'New'
	END
ORDER BY total_customers DESC;
