set search_path to sales;

-- top 20 customer
select customer_id, sum(price_paid) as total_paid into temp top_20_cust
from sales
group by customer_id
order by total_paid desc
limit 20;

-- product, total price, total_quantity
select product_id, sum(price_paid) as price_paid, sum(quantity) as total_quantity into temp prod_agg
from sales
group by product_id;


-- top20 catagory
select category_id, sum(price_paid) as total_paid into temp top_20_cate
from prod_agg, product
where prod_agg.product_id = product.product_id
group by category_id
order by total_paid desc
limit 20;

-- (category, customer)
select category_id, customer_id into temp cat_cus
from top_20_cust, top_20_cate;


select cat_cus.category_id as top_category, customer_id as top_customer, total_quantity as quantity_sold, price_paid as dollar_value
from
    (select total_quantity, price_paid, product.category_id
        from prod_agg, product
        where product.product_id = prod_agg.product_id) as tmp,
    cat_cus
where tmp.category_id = cat_cus.category_id;
