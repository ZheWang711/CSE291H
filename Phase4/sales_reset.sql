--sales_reset

set search_path to sales;

delete from sum_customer;
delete from sales_prod_cate;

delete from sales where sales_id >= 4000000;

insert into sales_prod_cate (
    select sales.product_id,category.category_id,quantity,price_paid
    from sales,product,category
    where sales.product_id=product.product_id
    and product.category_id=category.category_id );

insert into sum_customer (
    select customer_id,sum(price_paid) as sum_paid
    from sales
    group by customer_id );

alter sequence sales_sales_id_seq restart with 4000000;
alter sequence sales_inserted_sales_id_seq restart with 4000000;
alter sequence sales_delta_sales_id_seq restart with 4000000;
