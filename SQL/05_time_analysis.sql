/*
====================================================
Pizza Sales Analysis
File: 05_time_analysis.sql
Purpose: Time-based sales analysis
====================================================

Business questions:
- Which months generate the most revenue?
- Which days are busiest?
- What are the peak ordering hours?
*/

-- 1. Revenue by year
SELECT
    YEAR(order_date) AS order_year,
    CAST(SUM(total_price) AS DECIMAL(14,2)) AS revenue,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS pizzas_sold
FROM [dbo].[vw_pizza_sales_clean]
GROUP BY YEAR(order_date)
ORDER BY order_year;


-- 2. Revenue by year and month
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    DATENAME(MONTH, order_date) AS month_name,
    CAST(SUM(total_price) AS DECIMAL(14,2)) AS revenue,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS pizzas_sold
FROM [dbo].[vw_pizza_sales_clean]
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    DATENAME(MONTH, order_date)
ORDER BY order_year, order_month;


-- 3. Monthly revenue with month-over-month growth
WITH monthly_sales AS (
    SELECT
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,
        CAST(SUM(total_price) AS DECIMAL(14,2)) AS revenue
    FROM [dbo].[vw_pizza_sales_clean]
    GROUP BY YEAR(order_date), MONTH(order_date)
),
with_previous AS (
    SELECT
        order_year,
        order_month,
        revenue,
        LAG(revenue) OVER (
            ORDER BY order_year, order_month
        ) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    order_year,
    order_month,
    revenue,
    previous_month_revenue,
    CAST(
        100.0 * (revenue - previous_month_revenue) /
        NULLIF(previous_month_revenue, 0)
        AS DECIMAL(8,2)
    ) AS mom_growth_percentage
FROM with_previous
ORDER BY order_year, order_month;


-- 4. Revenue by day of week
SELECT
    DATEPART(WEEKDAY, order_date) AS weekday_number,
    DATENAME(WEEKDAY, order_date) AS weekday_name,
    CAST(SUM(total_price) AS DECIMAL(14,2)) AS revenue,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS pizzas_sold
FROM [dbo].[vw_pizza_sales_clean]
GROUP BY
    DATEPART(WEEKDAY, order_date),
    DATENAME(WEEKDAY, order_date)
ORDER BY weekday_number;


-- 5. Revenue by hour
SELECT
    DATEPART(HOUR, order_time) AS order_hour,
    CAST(SUM(total_price) AS DECIMAL(14,2)) AS revenue,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS pizzas_sold
FROM [dbo].[vw_pizza_sales_clean]
GROUP BY DATEPART(HOUR, order_time)
ORDER BY order_hour;


-- 6. Peak ordering hours ranked by orders
SELECT
    DATEPART(HOUR, order_time) AS order_hour,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS pizzas_sold,
    CAST(SUM(total_price) AS DECIMAL(14,2)) AS revenue,
    RANK() OVER (
        ORDER BY COUNT(DISTINCT order_id) DESC
    ) AS order_volume_rank
FROM [dbo].[vw_pizza_sales_clean]
GROUP BY DATEPART(HOUR, order_time)
ORDER BY order_volume_rank;


-- 7. Weekday + hour analysis
SELECT
    DATENAME(WEEKDAY, order_date) AS weekday_name,
    DATEPART(HOUR, order_time) AS order_hour,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS pizzas_sold,
    CAST(SUM(total_price) AS DECIMAL(14,2)) AS revenue
FROM [dbo].[vw_pizza_sales_clean]
GROUP BY
    DATENAME(WEEKDAY, order_date),
    DATEPART(HOUR, order_time)
ORDER BY orders DESC;
