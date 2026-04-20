-- ==============================================================
-- Database Exploration Script
-- ==============================================================
-- This script is used to explore the structure of the database.
-- It retrieves a list of all tables available in the database
-- and inspects the columns of a specific table (dim_customers).
-- Useful for understanding database schema and metadata.
-- ==============================================================

-- Explore All Objects in the Database
SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- Explore All Columns in the Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';

-- 
