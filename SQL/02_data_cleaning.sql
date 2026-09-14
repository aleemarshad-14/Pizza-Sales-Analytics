/*
====================================================
Pizza Sales Analysis
File: 02_data_cleaning.sql
Purpose: Data quality checks and cleaning logic
====================================================

NOTE:
This file intentionally uses SELECT-based cleaning checks first.
Do not UPDATE the source table until the results have been validated.
*/

-- 1. Check for leading/trailing spaces in text columns
SELECT
    COUNT(*) AS rows_with_text_spaces
FROM [dbo].[pizza_sales]
WHERE
    pizza_name <> LTRIM(RTRIM(pizza_name))
    OR pizza_category <> LTRIM(RTRIM(pizza_category))
    OR pizza_size <> LTRIM(RTRIM(pizza_size));


-- 2. Inspect category values after trimming
SELECT
    LTRIM(RTRIM(pizza_category)) AS cleaned_category,
    COUNT(*) AS row_count
FROM [dbo].[pizza_sales]
GROUP BY LTRIM(RTRIM(pizza_category))
ORDER BY row_count DESC;


-- 3. Inspect size values after trimming
SELECT
    LTRIM(RTRIM(pizza_size)) AS cleaned_size,
    COUNT(*) AS row_count
FROM [dbo].[pizza_sales]
GROUP BY LTRIM(RTRIM(pizza_size))
ORDER BY row_count DESC;


-- 4. Check invalid/non-positive quantities
SELECT *
FROM [dbo].[pizza_sales]
WHERE quantity <= 0;


-- 5. Check invalid/non-positive prices
SELECT *
FROM [dbo].[pizza_sales]
WHERE unit_price <= 0
   OR total_price < 0;


-- 6. Check impossible date/time values
SELECT *
FROM [dbo].[pizza_sales]
WHERE order_date IS NULL
   OR order_time IS NULL;


-- 7. Recommended cleaned view
-- Create only after validating the checks above.
CREATE OR ALTER VIEW [dbo].[vw_pizza_sales_clean] AS
SELECT
    pizza_id,
    order_id,
    pizza_name_id,
    quantity,
    CAST(order_date AS DATE) AS order_date,
    CAST(order_time AS TIME) AS order_time,
    CAST(unit_price AS DECIMAL(10,2)) AS unit_price,
    CAST(total_price AS DECIMAL(12,2)) AS total_price,
    UPPER(LTRIM(RTRIM(pizza_size))) AS pizza_size,
    LTRIM(RTRIM(pizza_category)) AS pizza_category,
    LTRIM(RTRIM(pizza_ingredients)) AS pizza_ingredients,
    LTRIM(RTRIM(pizza_name)) AS pizza_name
FROM [dbo].[pizza_sales];


-- 8. Validate the cleaned view
SELECT TOP 20 *
FROM [dbo].[vw_pizza_sales_clean];


-- 9. Confirm cleaned row count
SELECT COUNT(*) AS cleaned_rows
FROM [dbo].[vw_pizza_sales_clean];
