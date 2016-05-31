-- 1. Show the total sales (quantity sold and dollar value) for each customer.

SELECT customer_name, sum(quantity) AS total_quantity, sum(price_paid) AS total_price 
FROM sales s NATURAL JOIN customer c 
GROUP BY c.customer_id;

-- 2. Show the total sales for each state.

SELECT state_name, sum(quantity) AS total_quantity, sum(price_paid) AS total_price 
FROM sales s NATURAL JOIN customer c NATURAL JOIN state st 
GROUP BY st.state_name;

-- 3. Show the total sales for each product, for a given customer. Only products that were actually bought by the given customer. Order by dollar value.

SELECT product_id, sum(quantity) AS total_quantity, sum(price_paid) AS total_price
FROM sales 
WHERE customer_id=1 
GROUP BY product_id 
ORDER BY total_price DESC;


-- 4. Show the total sales for each product and customer. Order by dollar value.

SELECT product_id, customer_id, sum(quantity) AS total_quantity, sum(price_paid) AS total_price 
FROM sales 
GROUP BY product_id,customer_id 
ORDER BY total_price DESC;

-- 5. Show the total sales for each product category and state.

SELECT state_name, ca.category_id, sum(quantity) AS total_quantity, sum(price_paid) AS total_price 
FROM sales sa NATURAL JOIN customer cu NATURAL JOIN state st NATURAL JOIN category ca NATURAL JOIN product p
GROUP BY state_name, ca.category_id;


-- 6. For each one of the top 20 product categories and top 20 customers, it returns a tuple (top product, top customer, quantity sold, dollar value)

SELECT cate.category_id, cust.customer_id, sum(quantity) AS total_quantity, sum(price_paid) AS total_price FROM

(SELECT category_id, sum(price_paid) AS total_price FROM

category NATURAL JOIN product NATURAL JOIN sales

GROUP BY category_id ORDER BY total_price DESC limit 20) AS cate,

(SELECT customer_id, sum(price_paid) AS total_price FROM sales

GROUP BY customer_id ORDER BY total_price DESC limit 20) AS cust, sales s, product p

WHERE p.category_id = cate.category_id and s.customer_id = cust.customer_id and s.product_id = p.product_id

GROUP BY cate.category_id,cust.customer_id ORDER BY cate.category_id;