set search_path to sales;

--given customer, show total sale for each product, order by dollar value
select product_id,sum(quantity) as total_quantity,sum(price_paid) as total_paid
from sales
where customer_id=9
group by product_id
order by total_paid;
