USE retail_dw;
SELECT
    dp.category,
    SUM(CASE WHEN dd.year=2024 THEN fs.total_price ELSE 0 END) AS Sales_2024,
    SUM(CASE WHEN dd.year=2025 THEN fs.total_price ELSE 0 END) AS Sales_2025,
    SUM(CASE WHEN dd.year=2026 THEN fs.total_price ELSE 0 END) AS Sales_2026
FROM fact_sales fs
JOIN dim_product dp
ON fs.product_key=dp.product_key
JOIN dim_date dd
ON fs.date_key=dd.date_key
GROUP BY dp.category;