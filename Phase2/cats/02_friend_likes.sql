set search_path to cats; 

--friend likes
select video_id, count(video_id) as occurance from users,friendship,like_activity
where users.user_id=41 and users.user_id = user1 and user2=like_activity.user_id
group by video_id
order by count(video_id) desc
limit 10;