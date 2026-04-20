-- ==============================================================
-- Measures Exploration
-- ==============================================================
-- This script calculates key business metrics from fact and dimension tables.
-- It includes total sales, total quantity sold, average selling price,
-- number of orders, products, and customers. It also identifies how many
-- customers have placed orders. Finally, it generates a consolidated report
-- combining all key performance indicators (KPIs) into a single result set
-- for easy analysis and reporting.
-- ==============================================================

-- Find the Total Sales  
SELECT SUM(sales_amount) AS total_sales 
FROM gold.fact_sales;

-- Find how many items are sold 
SELECT SUM(quantity) AS total_items_sold 
FROM gold.fact_sales;

-- Find the average selling price 
SELECT AVG(price) AS avg_selling_price 
FROM gold.fact_sales;

-- Find the total number of Orders
SELECT COUNT(order_number) AS total_orders_num
FROM gold.fact_sales;

SELECT COUNT(DISTINCT order_number) AS abs_total_orders_num
FROM gold.fact_sales;

-- Find the total number of products
SELECT COUNT(product_key) AS total_products 
FROM gold.dim_products;

-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers 
FROM gold.dim_customers;

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS customer_ordered
FROM gold.fact_sales;

-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL 
SELECT 'Total Quantity' AS measure_name, SUM(quantity) AS measure_value FROM gold.fact_sales
UNION ALL 
SELECT 'Average Selling Price' AS measure_name, AVG(price) AS measure_value FROM gold.fact_sales
UNION ALL 
SELECT 'Total Orders' AS measure_name, COUNT(DISTINCT order_number) AS measure_value FROM gold.fact_sales
UNION ALL 
SELECT 'Total Products' AS measure_name, COUNT(product_key) AS measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total Customers' AS measure_name, COUNT(customer_key) AS measure_value FROM gold.dim_customers 
UNION ALL
SELECT 'Customers Placed Orders' AS measure_name, COUNT(DISTINCT customer_key) AS measure_value FROM gold.fact_sales;
