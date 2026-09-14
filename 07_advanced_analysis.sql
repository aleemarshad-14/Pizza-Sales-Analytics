/*
====================================================
Pizza Sales Analysis
File: 07_advanced_analysis.sql
Purpose: Advanced SQL analysis and business insights
====================================================

Concepts demonstrated:
- CTEs
- Window functions
- RANK / DENSE_RANK
- LAG
- Running totals
- Pareto analysis
- Order-level analysis
*/

-- 1. Order-level summary
WITH order_summary AS (
    SELECT
        order_id,
        MIN(order_date) AS order_date,
        MIN(order_time) AS order_time,
        SUM(quantity) AS pizzas_in_order,
        SUM(total_price) AS order_value
    FROM [dbo].[vw_pizza_sales_clean]
    GROUP BY order_id
)
SELECT
    COUNT(*) AS total_orders,
    SUM(pizzas_in_order) AS total_pizzas,
    CAST(AVG(CAST(pizzas_in_order AS DECIMAL(10,2))) AS DECIMAL(10,2))
        AS avg_pizzas_per_order,
    CAST(AVG(CAST(order_value AS DECIMAL(12,2))) AS DECIMAL(12,2))
        AS avg_order_value,
    MAX(pizzas_in_order) AS max_pizzas_in_single_order,
    MAX(order_value) AS max_order_value
FROM order_summary;


-- 2. Orders grouped by number of pizzas
WITH order_summary AS (
    SELECT
        order_id,
        SUM(quantity) AS pizzas_in_order
    FROM [dbo].[vw_pizza_sales_clean]
    GROUP BY order_id
)
SELECT
    pizzas_in_order,
    COUNT(*) AS number_of_orders,
    CAST(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER ()
        AS DECIMAL(6,2)
    ) AS order_percentage
FROM order_summary
GROUP BY pizzas_in_order
ORDER BY pizzas_in_order;


-- 3. Daily revenue with running total
WITH daily_sales AS (
    SELECT
        order_date,
        SUM(total_price) AS revenue
    FROM [dbo].[vw_pizza_sales_clean]
    GROUP BY order_date
)
SELECT
    order_date,
    CAST(revenue AS DECIMAL(14,2)) AS daily_revenue,
    CAST(
        SUM(revenue) OVER (
            ORDER BY order_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )
        AS DECIMAL(14,2)
    ) AS running_revenue
FROM daily_sales
ORDER BY order_date;


-- 4. Best-selling pizza by month
WITH monthly_product_sales AS (
    SELECT
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,
        pizza_name,
        SUM(quantity) AS pizzas_sold
    FROM [dbo].[vw_pizza_sales_clean]
    GROUP BY
        YEAR(order_date),
        MONTH(order_date),
        pizza_name
),
ranked AS (
    SELECT
        order_year,
        order_month,
        pizza_name,
        pizzas_sold,
        RANK() OVER (
            PARTITION BY order_year, order_month
            ORDER BY pizzas_sold DESC
        ) AS product_rank
    FROM monthly_product_sales
)
SELECT
    order_year,
    order_month,
    pizza_name,
    pizzas_sold,
    product_rank
FROM ranked
WHERE product_rank = 1
ORDER BY order_year, order_month;


-- 5. Revenue by size and category
SELECT
    pizza_category,
    pizza_size,
    CAST(SUM(total_price) AS DECIMAL(14,2)) AS revenue,
    SUM(quantity) AS pizzas_sold,
    COUNT(DISTINCT order_id) AS orders
FROM [dbo].[vw_pizza_sales_clean]
GROUP BY pizza_category, pizza_size
ORDER BY revenue DESC;


-- 6. Category ranking by revenue
WITH category_sales AS (
    SELECT
        pizza_category,
        SUM(total_price) AS revenue
    FROM [dbo].[vw_pizza_sales_clean]
    GROUP BY pizza_category
)
SELECT
    pizza_category,
    CAST(revenue AS DECIMAL(14,2)) AS revenue,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM category_sales
ORDER BY revenue_rank;


-- 7. Compare weekdays vs weekends
SELECT
    CASE
        WHEN DATENAME(WEEKDAY, order_date) IN ('Saturday', 'Sunday')
            THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS pizzas_sold,
    CAST(SUM(total_price) AS DECIMAL(14,2)) AS revenue,
    CAST(
        SUM(total_price) / NULLIF(COUNT(DISTINCT order_id),0)
        AS DECIMAL(12,2)
    ) AS average_order_value
FROM [dbo].[vw_pizza_sales_clean]
GROUP BY
    CASE
        WHEN DATENAME(WEEKDAY, order_date) IN ('Saturday', 'Sunday')
            THEN 'Weekend'
        ELSE 'Weekday'
    END
ORDER BY revenue DESC;


-- 8. Identify pizzas responsible for the first 80% of revenue
WITH product_sales AS (
    SELECT
        pizza_name,
        SUM(total_price) AS revenue
    FROM [dbo].[vw_pizza_sales_clean]
    GROUP BY pizza_name
),
ranked AS (
    SELECT
        pizza_name,
        revenue,
        SUM(revenue) OVER (
            ORDER BY revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue,
        SUM(revenue) OVER () AS total_revenue
    FROM product_sales
)
SELECT
    pizza_name,
    CAST(revenue AS DECIMAL(14,2)) AS revenue,
    CAST(
        100.0 * cumulative_revenue / NULLIF(total_revenue,0)
        AS DECIMAL(6,2)
    ) AS cumulative_revenue_percentage
FROM ranked
WHERE cumulative_revenue <= total_revenue * 0.80
ORDER BY revenue DESC;


-- 9. Revenue by hour with percentage contribution
WITH hourly_sales AS (
    SELECT
        DATEPART(HOUR, order_time) AS order_hour,
        SUM(total_price) AS revenue,
        COUNT(DISTINCT order_id) AS orders
    FROM [dbo].[vw_pizza_sales_clean]
    GROUP BY DATEPART(HOUR, order_time)
)
SELECT
    order_hour,
    CAST(revenue AS DECIMAL(14,2)) AS revenue,
    orders,
    CAST(
        100.0 * revenue / NULLIF(SUM(revenue) OVER (),0)
        AS DECIMAL(6,2)
    ) AS revenue_percentage
FROM hourly_sales
ORDER BY order_hour;
