set search_path to cats; 

--overall likes
select video_id, count(video_id) as occurance
from like_activity
group by video_id
order by count(video_id) desc
limit 10;
