-- ==============================================================
-- Dimensions Exploration
-- ==============================================================
-- This script explores key dimension tables in the database.
-- It retrieves unique values to better understand the data distribution,
-- including customer countries and product categories, subcategories,
-- and product names.
-- ==============================================================

-- Explore All Countries our customers come from
SELECT DISTINCT country
FROM gold.dim_customers;

-- Explore All Categories "The major Divisions"
SELECT DISTINCT 
	categroy,
	sub_category,
	product_name
FROM gold.dim_products
ORDER BY 1, 2, 3;

-- 
