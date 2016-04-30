set search_path to cats;

-- my kinds of cats
select video_id,count(video_id) as occurance from users,like_activity
where users.user_id=20 and users.user_id=like_activity.user_id
group by video_id
order by count(video_id) desc
limit 10;
