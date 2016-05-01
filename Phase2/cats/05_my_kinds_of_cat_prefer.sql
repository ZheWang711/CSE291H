set search_path to cats;

-- X, Y, vid

select * into temp like_activity1
from like_activity;

select like_activity.user_id as X, like_activity1.user_id as Y, like_activity.video_id as vid into temp XYV
from like_activity, like_activity1
where like_activity.video_id = like_activity1.video_id;

-- X, Y Lc(X, Y)
select X, Y, log(1+count(vid)) as Lc into temp XYLc
from XYV
group by X, Y;

-- select X=logged in user and Y != logged in user
select Y, Lc into temp YLc
from XYLc
where X = 41 and Y <> 41;

-- vid | user liked vid | Lc
select video_id, Y, Lc into temp VYLc
from YLc, like_activity
where Y = like_activity.user_id;

select video_id, sum(Lc) as preference
from VYLc
group by video_id
order by preference desc
limit 10;
