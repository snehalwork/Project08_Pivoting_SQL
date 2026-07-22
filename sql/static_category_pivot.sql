with sales_summary as(
SELECT
year(d.full_date) as sales_year,
month(d.full_date) as sales_month,
p.category,
round(sum(s.total_price),2) as total_sales
FROM fact_sales s
INNER JOIN dim_product p
ON s.product_key = p.product_key
INNER JOIN dim_date d
ON s.date_key = d.date_key
group by 
year(d.full_date),
month(d.full_date),
p.category
order by 
year(d.full_date),
month(d.full_date)
)
Select
sales_year,
sales_month,
 sum(case when category="Accessories" then total_sales else 0 end) Accessories,
sum(case when category="Appliances" then total_sales else 0 end) Appliances,
sum(case when category="Electronics" then total_sales else 0 end) Electronics,
sum(case when category="Furniture" then total_sales else 0 end) Furniture
from sales_summary
group by
sales_year,
 sales_month;