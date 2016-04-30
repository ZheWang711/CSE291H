set search_path to cats; 

--friend of friend likes
select video_id, count(video_id) as occurance from
	(select distinct friendship1.user2 from users,friendship,friendship as friendship1
	where users.user_id=1 and users.user_id=friendship.user1 and friendship.user2=friendship1.user1
	order by friendship1.user2) as foff,like_activity
where foff.user2=like_activity.user_id
group by video_id
order by count(video_id) desc
limit 10;