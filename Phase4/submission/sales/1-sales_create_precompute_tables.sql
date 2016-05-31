--pre-compute table for sales join product join category
set search_path to sales;

create table sales_prod_cate as
    select sales.product_id,category.category_id,quantity,price_paid
    from sales,product,category
    where sales.product_id=product.product_id
    and product.category_id=category.category_id;

--pre-compute table for sum price_paid aggregated by customer_id
set search_path to sales;

create table sum_customer as
    select customer_id,sum(price_paid) as sum_paid
    from sales
    group by customer_id;