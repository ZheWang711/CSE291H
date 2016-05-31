--new way to simulate ivm update

set search_path to sales;

drop table if exists sum_delta;

insert into sales (select * from sales_inserted);

insert into sales_prod_cate (
select sales_inserted.product_id,category.category_id,quantity,price_paid
from sales_inserted,product,category
where sales_inserted.product_id=product.product_id
and product.category_id=category.category_id );

select customer_id, sum(price_paid) as sum_paid into temp sum_delta
from sales_inserted
group by customer_id;

update sum_customer
set sum_paid=sum_customer.sum_paid+sum_delta.sum_paid
from sum_delta
where sum_customer.customer_id=sum_delta.customer_id;

insert into sum_customer (
    select sd.customer_id as customer_id,sd.sum_paid as sum_paid
    from sum_delta sd left join sum_customer sc
    on sd.customer_id = sc.customer_id
    where sc.customer_id is NULL );




