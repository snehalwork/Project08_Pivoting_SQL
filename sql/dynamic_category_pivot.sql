USE retail_dw;

SET SESSION group_concat_max_len = 100000;

-- Step 1: Dynamically generate the full SQL string including the CTE
SELECT CONCAT(
  'WITH sales_summary AS (
    SELECT 
      dd.year, 
      dd.month,
      dd.month_name,
      dp.category,
      SUM(fs.total_price) AS total_sales
    FROM fact_sales fs
    JOIN dim_product dp ON fs.product_key = dp.product_key
    JOIN dim_date dd    ON fs.date_key = dd.date_key
    GROUP BY dd.year, dd.month, dd.month_name, dp.category
  )
  SELECT 
    year, 
    month_name, ',
    GROUP_CONCAT(
      DISTINCT CONCAT(
        'SUM(CASE WHEN category = ''', category, 
        ''' THEN total_sales ELSE 0 END) AS `', category, '`'
      ) 
      ORDER BY category 
      SEPARATOR ', '
    ),
  ' FROM sales_summary
    GROUP BY year, month, month_name
    ORDER BY year, month;'
) INTO @sql
FROM dim_product;

-- Step 2: Execute
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;