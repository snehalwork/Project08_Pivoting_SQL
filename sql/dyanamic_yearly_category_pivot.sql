USE retail_dw;
SET SESSION group_concat_max_len = 100000;

-- Step 1: Dynamically generate the SQL string pivoting by YEAR
SELECT CONCAT(
  'WITH yearly_category_sales AS (
    SELECT 
      dp.category,
      dd.year,
      SUM(fs.total_price) AS total_sales
    FROM fact_sales fs
    JOIN dim_product dp ON fs.product_key = dp.product_key
    JOIN dim_date dd    ON fs.date_key = dd.date_key
    GROUP BY dp.category, dd.year
  )
  SELECT 
    category, ',
    GROUP_CONCAT(
      DISTINCT CONCAT(
        'SUM(CASE WHEN year = ', year, 
        ' THEN total_sales ELSE 0 END) AS `Sales_', year, '`'
      ) 
      ORDER BY year 
      SEPARATOR ', '
    ),
  ' FROM yearly_category_sales
    GROUP BY category;'
) INTO @sql
FROM dim_date
WHERE year IS NOT NULL; -- Filters out any invalid keys if present

-- Step 2: Execute
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;