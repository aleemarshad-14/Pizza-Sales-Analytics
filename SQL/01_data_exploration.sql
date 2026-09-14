/*
====================================================
Pizza Sales Analysis
File: 01_data_exploration.sql
Purpose: Initial data exploration and validation
Database: SQL Server
====================================================

IMPORTANT:
Replace [dbo].[pizza_sales] below if your actual table name is different.
*/

-- 1. Preview the dataset
SELECT TOP 20 *
FROM [dbo].[pizza_sales];


-- 2. Total number of rows
SELECT COUNT(*) AS total_rows
FROM [dbo].[pizza_sales];


-- 3. Number of unique orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM [dbo].[pizza_sales];


-- 4. Number of unique pizza products
SELECT COUNT(DISTINCT pizza_name_id) AS unique_pizza_products
FROM [dbo].[pizza_sales];


-- 5. Number of unique pizza names
SELECT COUNT(DISTINCT pizza_name) AS unique_pizzas
FROM [dbo].[pizza_sales];


-- 6. Number of pizza categories
SELECT COUNT(DISTINCT pizza_category) AS pizza_categories
FROM [dbo].[pizza_sales];


-- 7. Number of pizza sizes
SELECT COUNT(DISTINCT pizza_size) AS pizza_sizes
FROM [dbo].[pizza_sales];


-- 8. Date range
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM [dbo].[pizza_sales];


-- 9. Basic numeric statistics
SELECT
    MIN(quantity) AS min_quantity,
    MAX(quantity) AS max_quantity,
    AVG(CAST(quantity AS DECIMAL(10,2))) AS avg_quantity,
    MIN(unit_price) AS min_unit_price,
    MAX(unit_price) AS max_unit_price,
    AVG(CAST(unit_price AS DECIMAL(10,2))) AS avg_unit_price,
    MIN(total_price) AS min_total_price,
    MAX(total_price) AS max_total_price,
    AVG(CAST(total_price AS DECIMAL(10,2))) AS avg_total_price
FROM [dbo].[pizza_sales];


-- 10. Distinct categories
SELECT DISTINCT pizza_category
FROM [dbo].[pizza_sales]
ORDER BY pizza_category;


-- 11. Distinct sizes
SELECT DISTINCT pizza_size
FROM [dbo].[pizza_sales]
ORDER BY pizza_size;


-- 12. Check NULL values across important columns
SELECT
    SUM(CASE WHEN pizza_id IS NULL THEN 1 ELSE 0 END) AS null_pizza_id,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN pizza_name_id IS NULL THEN 1 ELSE 0 END) AS null_pizza_name_id,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS null_quantity,
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS null_order_date,
    SUM(CASE WHEN order_time IS NULL THEN 1 ELSE 0 END) AS null_order_time,
    SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS null_unit_price,
    SUM(CASE WHEN total_price IS NULL THEN 1 ELSE 0 END) AS null_total_price,
    SUM(CASE WHEN pizza_size IS NULL THEN 1 ELSE 0 END) AS null_pizza_size,
    SUM(CASE WHEN pizza_category IS NULL THEN 1 ELSE 0 END) AS null_pizza_category,
    SUM(CASE WHEN pizza_ingredients IS NULL THEN 1 ELSE 0 END) AS null_pizza_ingredients,
    SUM(CASE WHEN pizza_name IS NULL THEN 1 ELSE 0 END) AS null_pizza_name
FROM [dbo].[pizza_sales];


-- 13. Check duplicate rows across all business columns
SELECT
    pizza_id,
    order_id,
    pizza_name_id,
    quantity,
    order_date,
    order_time,
    unit_price,
    total_price,
    pizza_size,
    pizza_category,
    pizza_ingredients,
    pizza_name,
    COUNT(*) AS duplicate_count
FROM [dbo].[pizza_sales]
GROUP BY
    pizza_id,
    order_id,
    pizza_name_id,
    quantity,
    order_date,
    order_time,
    unit_price,
    total_price,
    pizza_size,
    pizza_category,
    pizza_ingredients,
    pizza_name
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- 14. Orders containing multiple pizza line items
SELECT
    order_id,
    COUNT(*) AS line_items,
    SUM(quantity) AS pizzas_in_order,
    SUM(total_price) AS order_value
FROM [dbo].[pizza_sales]
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY line_items DESC;


-- 15. Check whether total_price agrees with quantity * unit_price
SELECT TOP 50
    pizza_id,
    quantity,
    unit_price,
    total_price,
    CAST(quantity * unit_price AS DECIMAL(12,2)) AS calculated_total,
    CAST(total_price - (quantity * unit_price) AS DECIMAL(12,2)) AS difference
FROM [dbo].[pizza_sales]
WHERE ABS(total_price - (quantity * unit_price)) > 0.01
ORDER BY ABS(total_price - (quantity * unit_price)) DESC;
