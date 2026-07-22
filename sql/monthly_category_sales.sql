select 
year(d.full_date) as sales_year,
month(d.full_date) as sales_month,
d.month_name,
p.category, 
round(sum(total_price),2)  as total_sales 
from fact_sales s
join dim_product p
on s.product_key=p.product_key
join dim_date d
on s.date_key=d.date_key
group by 
year(d.full_date),
month(d.full_date),
d.month_name,
p.category 
order by 
year(d.full_date),
month(d.full_date); 