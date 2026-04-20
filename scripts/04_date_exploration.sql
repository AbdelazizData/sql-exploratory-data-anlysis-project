-- ==============================================================
-- Date Exploration
-- ==============================================================
-- This script analyzes date-related information in the database.
-- It identifies the time range of sales data by finding the first
-- and last order dates and calculating the total number of years covered.
-- It also examines customer demographics by determining the oldest
-- and youngest customers based on their birth dates.
-- ==============================================================

-- Find the date of the first and last order
-- How many years of sales are available
SELECT 
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS order_range_years
FROM gold.fact_sales;

-- Find the youngest & oldest customer
SELECT	
	MIN(birth_date) AS oldest_customer,
	DATEDIFF(YEAR, MIN(birth_date), GETDATE()) AS oldest_customer_age,
	MAX(birth_date) AS youngest_customer,
	DATEDIFF(YEAR, MAX(birth_date), GETDATE()) AS youngest_customer_age
FROM gold.dim_customers;
