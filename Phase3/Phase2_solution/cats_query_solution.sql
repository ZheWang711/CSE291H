--Option “Overall Likes”: The Top-10 cat videos are the ones that have collected the highest numbers of likes, overall.

SELECT l.video_id, COUNT(*) AS num_likes FROM like_activity l 
GROUP BY l.video_id
ORDER BY num_likes DESC
LIMIT 10;

--Option “Friend Likes”: The Top-10 cat videos are the ones that have collected the highest numbers of likes from the friends of X.

SELECT l.video_id, COUNT(*) AS num_likes 
FROM friendship f, like_activity l WHERE f.user1=1 AND f.user2=l.user_id
GROUP BY l.video_id
ORDER BY num_likes DESC
LIMIT 10;

--Option “Friends-of-Friends Likes”: The Top-10 cat videos are the ones that have collected the highest numbers of likes from friends and friends-of-friends.

SELECT l.video, COUNT(*) AS num_likes
FROM (
    SELECT l.video_id AS video, l.user_id AS user 
    FROM friendship f, like_activity l 
    WHERE f.user1=1 AND f.user2=l.user_id
    UNION
    SELECT l.video_id AS video, l.user_id AS user 
    FROM friendship f, friendship ff, like_activity l 
    WHERE f.user1=1 AND f.user2=ff.user1 AND ff.user2=l.user_id) l
GROUP BY l.video
ORDER BY num_likes DESC
LIMIT 10;

--Option “My kind of cats”: The Top-10 cat videos are the ones that have collected the most likes from users who have liked at least one cat video that was liked by X.

SELECT l.video_id, COUNT(*) AS num_likes
FROM like_activity l 
WHERE l.user_id IN (SELECT ly.user_id FROM like_activity lx, like_activity ly WHERE lx.user_id=1 AND lx.video_id=ly.video_id) 
GROUP BY l.video_id
ORDER BY num_likes DESC
LIMIT 10;

--Option “My kind of cats – with preference (to cat aficionados that have the same tastes)”: The Top-10 cat videos are the ones that have collected the highest sum of weighted likes from every other user Y (i.e., given a cat video, each like on it, is multiplied according to a weight).The weight is the log cosine lc(X,Y) defined as follows: Conceptually, there is a vector vx for each user Y, including the logged-in user X. The vector has as many elements as the number of cat videos. Element i is 1 if Y liked the ith cat video; it is 0 otherwise.

WITH WeightOfUsers AS 
(SELECT ly.user_id, LOG(1+COUNT(*)) AS weight 
 FROM like_activity lx, like_activity ly 
 WHERE lx.user_id=1 AND lx.video_id=ly.video_id
 GROUP BY ly.user_id)
SELECT l.video_id, SUM(weight) AS weighted_likes
FROM like_activity l,  WeightOfUsers w 
WHERE l.user_id=w.user_id and l.user_id <> 1 
GROUP BY l.video_id
ORDER BY weighted_likes DESC
LIMIT 10;
