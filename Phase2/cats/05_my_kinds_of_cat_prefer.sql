set search_path to cats;

-- my kinds of cats with preference
select log(1+count(*)) as result from users,like_activity,like_activity as like_activity1
where users.user_id=41 and users.user_id=like_activity.user_id 
	and like_activity.video_id=like_activity1.video_id and like_activity1.user_id<>41;