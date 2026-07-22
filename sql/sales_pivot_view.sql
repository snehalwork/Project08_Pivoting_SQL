USE retail_dw;

CREATE OR REPLACE VIEW vw_sales_pivot AS

SELECT
    dd.year,
    dd.month_name,

    SUM(CASE WHEN dp.category='Electronics' THEN fs.total_price ELSE 0 END) Electronics,
    SUM(CASE WHEN dp.category='Furniture' THEN fs.total_price ELSE 0 END) Furniture,
    SUM(CASE WHEN dp.category='Accessories' THEN fs.total_price ELSE 0 END) Accessories,
    SUM(CASE WHEN dp.category='Appliances' THEN fs.total_price ELSE 0 END) Appliances

FROM fact_sales fs
JOIN dim_product dp
ON fs.product_key=dp.product_key

JOIN dim_date dd
ON fs.date_key=dd.date_key

GROUP BY
dd.year,
dd.month,
dd.month_name;