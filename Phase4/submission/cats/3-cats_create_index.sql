set search_path to cats;

create index like_activity_user_id on like_activity using hash (user_id);
create index user_weights_user_id on user_weights (lx_user_id);
create index user_weights_lx_ly on user_weights (lx_user_id,ly_user_id);