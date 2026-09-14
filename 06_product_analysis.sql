/*
====================================================
Pizza Sales Analysis
File: 06_product_analysis.sql
Purpose: Product performance analysis
====================================================

Focus:
- Top and bottom products
- Product contribution
- Category/product ranking
- Price vs volume
*/

-- 1. Complete product performance table
SELECT
    pizza_name_id,
    pizza_name,
    pizza_category,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS pizzas_sold,
    CAST(SUM(total_price) AS DECIMAL(14,2)) AS revenue,
    CAST(AVG(unit_price) AS DECIMAL(10,2)) AS average_unit_price,
    CAST(
        SUM(total_price) / NULLIF(SUM(quantity),0)
        AS DECIMAL(10,2)
    ) AS revenue_per_pizza
FROM [dbo].[vw_pizza_sales_clean]
GROUP BY
    pizza_name_id,
    pizza_name,
    pizza_category
ORDER BY revenue DESC;


-- 2. Rank pizzas within each category by revenue
WITH product_sales AS (
    SELECT
        pizza_category,
        pizza_name,
        CAST(SUM(total_price) AS DECIMAL(14,2)) AS revenue,
        SUM(quantity) AS pizzas_sold
    FROM [dbo].[vw_pizza_sales_clean]
    GROUP BY pizza_category, pizza_name
)
SELECT
    pizza_category,
    pizza_name,
    revenue,
    pizzas_sold,
    RANK() OVER (
        PARTITION BY pizza_category
        ORDER BY revenue DESC
    ) AS category_revenue_rank
FROM product_sales
ORDER BY pizza_category, category_revenue_rank;


-- 3. Revenue contribution of each pizza
WITH product_sales AS (
    SELECT
        pizza_name,
        SUM(total_price) AS revenue
    FROM [dbo].[vw_pizza_sales_clean]
    GROUP BY pizza_name
)
SELECT
    pizza_name,
    CAST(revenue AS DECIMAL(14,2)) AS revenue,
    CAST(
        100.0 * revenue / NULLIF(SUM(revenue) OVER (), 0)
        AS DECIMAL(6,2)
    ) AS revenue_percentage
FROM product_sales
ORDER BY revenue DESC;


-- 4. Cumulative revenue contribution (Pareto analysis)
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
        100.0 * revenue / NULLIF(total_revenue,0)
        AS DECIMAL(6,2)
    ) AS revenue_percentage,
    CAST(
        100.0 * cumulative_revenue / NULLIF(total_revenue,0)
        AS DECIMAL(6,2)
    ) AS cumulative_revenue_percentage
FROM ranked
ORDER BY revenue DESC;


-- 5. Products with high volume but lower revenue per pizza
SELECT TOP 10
    pizza_name,
    SUM(quantity) AS pizzas_sold,
    CAST(SUM(total_price) AS DECIMAL(14,2)) AS revenue,
    CAST(
        SUM(total_price) / NULLIF(SUM(quantity),0)
        AS DECIMAL(10,2)
    ) AS revenue_per_pizza
FROM [dbo].[vw_pizza_sales_clean]
GROUP BY pizza_name
ORDER BY pizzas_sold DESC, revenue_per_pizza ASC;


-- 6. Products with low volume but high revenue per pizza
SELECT TOP 10
    pizza_name,
    SUM(quantity) AS pizzas_sold,
    CAST(SUM(total_price) AS DECIMAL(14,2)) AS revenue,
    CAST(
        SUM(total_price) / NULLIF(SUM(quantity),0)
        AS DECIMAL(10,2)
    ) AS revenue_per_pizza
FROM [dbo].[vw_pizza_sales_clean]
GROUP BY pizza_name
ORDER BY revenue_per_pizza DESC, pizzas_sold DESC;
