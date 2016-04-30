set search_path to sales;

-- total sale of states
select state_id,sum(quantity) as total_quantity,sum(price_paid) as total_paid
from sales,customer
where sales.customer_id=customer.customer_id
group by state_id
order by state_id;
