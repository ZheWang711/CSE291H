set search_path to cats;

CREATE OR REPLACE FUNCTION PRE_UPDATE() RETURNS void AS $$
DECLARE cat_user RECORD;
BEGIN

INSERT INTO like_activity (SELECT * FROM like_activity_delta);

DROP TABLE IF EXISTS temp_table;
DROP TABLE IF EXISTS temp_table1;

create temp table temp_table as
select lx_user_id, ly_user_id, count(*) as weight
from (
select lad.user_id as lx_user_id, la.user_id as ly_user_id
from like_activity_delta lad, like_activity la
where lad.user_id = 1
  and lad.video_id = la.video_id ) as join_table
group by lx_user_id, ly_user_id;

delete from temp_table;

FOR cat_user IN select user_id from users LOOP

    insert into temp_table (
    select lx_user_id, ly_user_id, count(*) as weight
    from (
        select lad.user_id as lx_user_id, la.user_id as ly_user_id
        from like_activity_delta lad, like_activity la
        where lad.user_id = cat_user.user_id
          and lad.video_id = la.video_id ) as join_table
    group by lx_user_id, ly_user_id );

END LOOP;
raise notice 'phase 1.';

    insert into temp_table (
    select ly_user_id as lx_user_id, lx_user_id as ly_user_id, weight
    from temp_table 
    where lx_user_id!=ly_user_id) ;
raise notice 'phase 2.';

    update user_weights
    set weight = user_weights.weight + temp_table.weight
    from temp_table
    where (user_weights.lx_user_id,user_weights.ly_user_id) = (temp_table.lx_user_id,temp_table.ly_user_id);
   
raise notice 'phase 3.2';
    insert into user_weights (
    select temp_table.lx_user_id, temp_table.ly_user_id, temp_table.weight
    from temp_table left join user_weights
    on user_weights.lx_user_id = temp_table.lx_user_id and user_weights.ly_user_id = temp_table.ly_user_id
    where user_weights.lx_user_id is null or user_weights.ly_user_id is null );

RETURN;
END;
$$ LANGUAGE plpgsql;
