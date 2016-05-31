--pre-compute table for cate
set search_path to sales;

create table sales_prod_cate as
    select sales.customer_id,sales.product_id,category.category_id,quantity,price_paid
    from sales,customer,product,category
    where sales.customer_id=customer.customer_id
    and sales.product_id=product.product_id
    and product.category_id=category.category_id

--pre-compute table for cust
set search_path to sales;

create table sum_customer as
    select customer_id,sum(price_paid) as sum_paid
    from sales
    group by customer_id