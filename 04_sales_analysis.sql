/*
====================================================
Pizza Sales Analysis
File: 04_sales_analysis.sql
Purpose: Revenue, quantity and order analysis
====================================================

Business questions:
- Which categories generate the most revenue?
- Which sizes sell the most?
- Which pizzas are the top revenue generators?
- What percentage of revenue comes from each segment?
*/

-- 1. Revenue by pizza category
SELECT
    pizza_category,
    CAST(SUM(total_price) AS DECIMAL(14,2)) AS revenue,
    SUM(quantity) AS pizzas_sold,
    COUNT(DISTINCT order_id) AS orders,
    CAST(
        100.0 * SUM(total_price) /
        NULLIF(SUM(SUM(total_price)) OVER (), 0)
        AS DECIMAL(6,2)
    ) AS revenue_percentage
FROM [dbo].[vw_pizza_sales_clean]
GROUP BY pizza_category
ORDER BY revenue DESC;


-- 2. Revenue by pizza size
SELECT
    pizza_size,
    CAST(SUM(total_price) AS DECIMAL(14,2)) AS revenue,
    SUM(quantity) AS pizzas_sold,
    COUNT(DISTINCT order_id) AS orders,
    CAST(
        100.0 * SUM(total_price) /
        NULLIF(SUM(SUM(total_price)) OVER (), 0)
        AS DECIMAL(6,2)
    ) AS revenue_percentage
FROM [dbo].[vw_pizza_sales_clean]
GROUP BY pizza_size
ORDER BY revenue DESC;


-- 3. Top 10 pizzas by revenue
SELECT TOP 10
    pizza_name,
    CAST(SUM(total_price) AS DECIMAL(14,2)) AS revenue,
    SUM(quantity) AS pizzas_sold,
    COUNT(DISTINCT order_id) AS orders
FROM [dbo].[vw_pizza_sales_clean]
GROUP BY pizza_name
ORDER BY revenue DESC;


-- 4. Bottom 10 pizzas by revenue
SELECT TOP 10
    pizza_name,
    CAST(SUM(total_price) AS DECIMAL(14,2)) AS revenue,
    SUM(quantity) AS pizzas_sold,
    COUNT(DISTINCT order_id) AS orders
FROM [dbo].[vw_pizza_sales_clean]
GROUP BY pizza_name
ORDER BY revenue ASC;


-- 5. Top 10 pizzas by quantity sold
SELECT TOP 10
    pizza_name,
    SUM(quantity) AS pizzas_sold,
    CAST(SUM(total_price) AS DECIMAL(14,2)) AS revenue
FROM [dbo].[vw_pizza_sales_clean]
GROUP BY pizza_name
ORDER BY pizzas_sold DESC;


-- 6. Top 10 pizzas by number of orders
SELECT TOP 10
    pizza_name,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS pizzas_sold,
    CAST(SUM(total_price) AS DECIMAL(14,2)) AS revenue
FROM [dbo].[vw_pizza_sales_clean]
GROUP BY pizza_name
ORDER BY orders DESC;


-- 7. Revenue by pizza name and category
SELECT
    pizza_category,
    pizza_name,
    CAST(SUM(total_price) AS DECIMAL(14,2)) AS revenue,
    SUM(quantity) AS pizzas_sold
FROM [dbo].[vw_pizza_sales_clean]
GROUP BY pizza_category, pizza_name
ORDER BY pizza_category, revenue DESC;


-- 8. Average unit price by category
SELECT
    pizza_category,
    CAST(AVG(unit_price) AS DECIMAL(10,2)) AS average_unit_price,
    CAST(SUM(total_price) / NULLIF(SUM(quantity),0) AS DECIMAL(10,2))
        AS realized_price_per_pizza
FROM [dbo].[vw_pizza_sales_clean]
GROUP BY pizza_category
ORDER BY realized_price_per_pizza DESC;
