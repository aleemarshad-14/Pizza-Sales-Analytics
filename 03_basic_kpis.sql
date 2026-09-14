/*
====================================================
Pizza Sales Analysis
File: 03_basic_kpis.sql
Purpose: Core business KPIs
====================================================

KPIs:
- Total Revenue
- Total Orders
- Total Pizzas Sold
- Average Order Value
- Average Pizzas per Order
*/

-- 1. Total Revenue
SELECT
    CAST(SUM(total_price) AS DECIMAL(14,2)) AS total_revenue
FROM [dbo].[vw_pizza_sales_clean];


-- 2. Total Orders
SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM [dbo].[vw_pizza_sales_clean];


-- 3. Total Pizzas Sold
SELECT
    SUM(quantity) AS total_pizzas_sold
FROM [dbo].[vw_pizza_sales_clean];


-- 4. Average Order Value (AOV)
SELECT
    CAST(
        SUM(total_price) / NULLIF(COUNT(DISTINCT order_id), 0)
        AS DECIMAL(12,2)
    ) AS average_order_value
FROM [dbo].[vw_pizza_sales_clean];


-- 5. Average Pizzas per Order
SELECT
    CAST(
        SUM(quantity) * 1.0 / NULLIF(COUNT(DISTINCT order_id), 0)
        AS DECIMAL(10,2)
    ) AS average_pizzas_per_order
FROM [dbo].[vw_pizza_sales_clean];


-- 6. One KPI summary
SELECT
    CAST(SUM(total_price) AS DECIMAL(14,2)) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_pizzas_sold,
    CAST(
        SUM(total_price) / NULLIF(COUNT(DISTINCT order_id), 0)
        AS DECIMAL(12,2)
    ) AS average_order_value,
    CAST(
        SUM(quantity) * 1.0 / NULLIF(COUNT(DISTINCT order_id), 0)
        AS DECIMAL(10,2)
    ) AS average_pizzas_per_order
FROM [dbo].[vw_pizza_sales_clean];


-- 7. Revenue per pizza sold
SELECT
    CAST(
        SUM(total_price) / NULLIF(SUM(quantity), 0)
        AS DECIMAL(10,2)
    ) AS revenue_per_pizza
FROM [dbo].[vw_pizza_sales_clean];
