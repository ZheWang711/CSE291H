set search_path to sales;

--sales for each category and state
select state_id,category_id,sum(quantity) as total_quantity,sum(price_paid) as total_paid
from sales,product,customer
where sales.customer_id=customer.customer_id and sales.product_id=product.product_id
group by state_id,category_id
order by total_paid;