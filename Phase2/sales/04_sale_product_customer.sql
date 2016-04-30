set search_path to sales;

--sale for each product and customer, order by dollar value
select customer_id,product_id,sum(quantity) as total_quantity,sum(price_paid) as total_paid
from sales
group by customer_id,product_id
order by total_paid;
