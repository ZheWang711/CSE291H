set search_path to sales;

-- total q & p for each customer
select sales.customer_id,sum(quantity) as total_quantity, sum(price_paid) as paid
from sales,customer
where sales.customer_id=customer.customer_id
group by sales.customer_id
order by sales.customer_id;
