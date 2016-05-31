--update query for sales_prod_cate

set search_path to sales;

select sales_delta.customer_id,sales_delta.product_id,category.category_id,quantity,price_paid
from sales_delta,customer,product,category
where sales_delta.customer_id=customer.customer_id
and sales_delta.product_id=product.product_id
and product.category_id=category.category_id


--delta plus for sum_customer
with sum_delta as (
select customer_id, sum(price_paid) as sum_paid
from sales_delta
group by customer_id ),

join_sum as (
select sd.customer_id, sd.sum_paid as sd_sum_paid, sc.sum_paid as sc_sum_paid
from sum_delta sd, sum_customer sc
where sd.customer_id = sc.customer_id )

select sd.customer_id, sum(sd.sum_paid) as sum_paid
from sum_delta sd left join
     (select customer_id, sd_sum_paid as sum_paid from join_sum) as js on sd.customer_id = js.customer_id
where js.customer_id is NULL 
group by sd.customer_id


--delta update for sum_customer

with sum_delta as (
select customer_id, sum(price_paid) as sum_paid
from sales_delta
group by customer_id ),

join_sum as (
select sd.customer_id, sd.sum_paid as sd_sum_paid, sc.sum_paid as sc_sum_paid
from sum_delta sd, sum_customer sc
where sd.customer_id = sc.customer_id )

select customer_id, sum(sum_paid) as sum_paid
from (select customer_id, sd_sum_paid as sum_paid 
    from join_sum union 
    select customer_id, sc_sum_paid as sum_paid 
    from join_sum) as jsa
group by customer_id






--simulated ivm update
set search_path to sales;

drop table if exists sum_delta;
drop table if exists join_sum;
drop table if exists update_list;

insert into sales (select * from sales_inserted);

insert into sales_prod_cate (
select sales_inserted.customer_id,sales_inserted.product_id,category.category_id,quantity,price_paid
from sales_inserted,customer,product,category
where sales_inserted.customer_id=customer.customer_id
and sales_inserted.product_id=product.product_id
and product.category_id=category.category_id );


select customer_id, sum(price_paid) as sum_paid into temp sum_delta
from sales_inserted
group by customer_id;


select sd.customer_id, sd.sum_paid as sd_sum_paid, sc.sum_paid as sc_sum_paid into temp join_sum
from sum_delta sd, sum_customer sc
where sd.customer_id = sc.customer_id;

insert into sum_customer (
select sd.customer_id, sum(sd.sum_paid) as sum_paid
from sum_delta sd left join
     (select customer_id, sd_sum_paid as sum_paid from join_sum) as js on sd.customer_id = js.customer_id
where js.customer_id is NULL 
group by sd.customer_id );

with update_list as (
select customer_id, sum(sum_paid) as sum_paid
from (select customer_id, sd_sum_paid as sum_paid 
    from join_sum union 
    select customer_id, sc_sum_paid as sum_paid 
    from join_sum) as jsa
group by customer_id)

update sum_customer
set sum_paid=update_list.sum_paid
from update_list
where sum_customer.customer_id=update_list.customer_id;


--new way to simulate ivm update

set search_path to sales;

drop table if exists sum_delta;

insert into sales (select * from sales_inserted);

insert into sales_prod_cate (
select sales_inserted.customer_id,sales_inserted.product_id,category.category_id,quantity,price_paid
from sales_inserted,customer,product,category
where sales_inserted.customer_id=customer.customer_id
and sales_inserted.product_id=product.product_id
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


--index
set search_path to sales;

create index sum_customer_customerid on sum_customer using hash (customer_id);

