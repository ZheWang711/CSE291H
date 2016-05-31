set search_path to cats;

WITH WeightOfUsers AS 
(SELECT ly_user_id as user_id, LOG(weight) AS weight 
 FROM user_weights
 WHERE lx_user_id=4000 )
SELECT l.video_id, SUM(weight) AS weighted_likes
FROM like_activity l,  WeightOfUsers w 
WHERE l.user_id=w.user_id and l.user_id <> 4000
GROUP BY l.video_id
ORDER BY weighted_likes DESC
LIMIT 10;