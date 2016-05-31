set search_path to sales;

SELECT cate.category_id, cust.customer_id, sum(quantity) AS total_quantity, sum(price_paid) AS total_price FROM

(SELECT category_id, sum(price_paid) AS total_price FROM

sales_prod_cate GROUP BY category_id ORDER BY total_price DESC limit 20) AS cate, 

(SELECT * FROM sum_customer ORDER BY sum_paid DESC limit 20) AS cust, sales s, product p

WHERE p.category_id = cate.category_id and s.customer_id = cust.customer_id and s.product_id = p.product_id

GROUP BY cate.category_id,cust.customer_id ORDER BY cate.category_id;