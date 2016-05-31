set search_path to cats;

CREATE OR REPLACE FUNCTION PRE_INIT() RETURNS void AS $$
DECLARE cat_user RECORD;
BEGIN

FOR cat_user IN select user_id from users LOOP
    INSERT INTO user_weights (
    SELECT lx.user_id as lx_user_id, ly.user_id as ly_user_id, 1+COUNT(*) AS weight
     FROM like_activity lx, like_activity ly 
     WHERE lx.user_id=cat_user.user_id AND lx.video_id=ly.video_id
     GROUP BY lx.user_id, ly.user_id );

END LOOP;
RETURN;
END;
$$ LANGUAGE plpgsql;
