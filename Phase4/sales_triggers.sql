-- 1. trigger for updating inserts into sales_prod_cate

set search_path to sales;

drop trigger if exists update_spc_tri on sales;

create or replace function update_spc() returns trigger as $spc$
begin
    insert into sales_prod_cate
    (
        select n.customer_id,n.product_id,category.category_id,quantity,price_paid
        from (select NEW.*) as n,customer,product,category
        where n.customer_id=customer.customer_id
        and n.product_id=product.product_id
        and product.category_id=category.category_id
    );
    return new;
end;

$spc$ language plpgsql;

create trigger update_spc_tri
after insert on sales
for each row execute procedure update_spc();



-- 2. trigger for sum_customer

set search_path to sales;

drop trigger if exists update_sc_tri on sales;

create or replace function update_sc() returns trigger as $sc$
begin
    if exists(select customer_id from sum_customer where customer_id=new.customer_id) then
        with join_sum as (
        select new.customer_id,new.price_paid as sd_sum_paid,sc.sum_paid as sc_sum_paid
        from (select new.*) as sd,sum_customer sc
        where sd.customer_id=sc.customer_id ),

        update_list as (
        select customer_id, sum(sum_paid) as sum_paid
        from (select customer_id, sd_sum_paid as sum_paid
        from join_sum union 
        select customer_id, sc_sum_paid as sum_paid 
        from join_sum) as jsa
        group by customer_id )
        
        update sum_customer
        set sum_paid=update_list.sum_paid
        from update_list
        where sum_customer.customer_id=update_list.customer_id;
    else 
        insert into sum_customer (
            select customer_id,price_paid as sum_paid
            from (select new.*) as inserted );
    end if;

    return new;
end;

$sc$ language plpgsql;

create trigger update_sc_tri
after insert on sales
for each row execute procedure update_sc();