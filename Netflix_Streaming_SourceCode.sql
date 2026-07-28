                      -- Movie Streaming Platform Database Specific Tasks --
                                   
CREATE DATABASE IF NOT EXISTS netflix;
USE netflix;

-- 1. Retrieve a list of all movies and TV shows available in the 'Action' category.
SELECT c.content_id, c.title, c.type, g.genre_name FROM content c
JOIN content_genres cg ON c.content_id = cg.content_id
JOIN genres g ON cg.genre_id = g.genre_id
WHERE g.genre_name = 'Action' AND c.type IN ('Movie', 'TV Show');

-- 2.List all registered users along with their current subscription plan(Basic, Standard, Premium).
select u.user_id, u.name, COALESCE(sp.plan_name, 'No Active Plan') AS plan_name
from users u 
left join subscriptions s on u.user_id=s.user_id and s.status='Active'
left join subscription_plans sp on s.plan_id=sp.plan_id;

-- 3.Find the most-watched movie during the latest three months available in the dataset.
SELECT c.title, COUNT(*) AS watch_count FROM watch_history wh
JOIN content c ON wh.content_id = c.content_id
WHERE c.type = 'Movie'
AND wh.watched_at >= (
    SELECT DATE_SUB(MAX(watched_at), INTERVAL 3 MONTH)
    FROM watch_history )
GROUP BY c.title
ORDER BY watch_count DESC
LIMIT 1;

-- 4.List all movies directed by 'Christopher Nolan' available on the platform.
SELECT title, release_year, director, release_date
FROM content
WHERE director = 'Christopher Nolan'
AND type = 'Movie';

-- 5.Retrieve the watch history of a specific user, including movie titles and timestamps.
select c.title,wh.watched_at,wh.watch_duration,wh.is_completed from watch_history wh 
inner join content c on wh.content_id = c.content_id where wh.user_id = 1;

-- 6.Find users who have rated at least five movies and calculate their average rating score.
SELECT u.user_id, u.name, ROUND(AVG(r.rating), 2) AS avg_rating_score
FROM users u
JOIN ratings r ON u.user_id = r.user_id
JOIN content c ON r.content_id = c.content_id
WHERE c.type = 'Movie'
GROUP BY u.user_id, u.name
HAVING COUNT(DISTINCT r.content_id) >= 5;

-- 7.Identify users who watched more than 3 hours of content during the latest month available in the dataset.
SELECT u.user_id, u.name,
ROUND(SUM(wh.watch_duration) / 60, 2) AS watch_hours FROM users u
JOIN watch_history wh ON u.user_id = wh.user_id
WHERE wh.watched_at >= (
    SELECT MAX(watched_at) - INTERVAL 1 MONTH
    FROM watch_history )
GROUP BY u.user_id, u.name
HAVING watch_hours > 3;

-- 8.Retrieve TV shows scheduled for release within six months after the latest activity date in the dataset.
SELECT content_id, title, type, release_year, release_date, director, description 
FROM content
WHERE type = 'TV Show'
AND release_date > (
    SELECT MAX(watched_at)
    FROM watch_history )
AND release_date <= DATE_ADD(
    (SELECT MAX(watched_at) FROM watch_history),
    INTERVAL 6 MONTH )
ORDER BY release_date;

-- 9.List all movies and TV Show that are available in both English and Spanish.
select c.title,GROUP_CONCAT(distinct cl.language order by cl.language separator ',') as movie_languages
from content c 
inner join content_languages cl on c.content_id= cl.content_id
where cl.language in ('English','Spanish') group by c.content_id, c.title 
having count(distinct cl.language) = 2 order by c.title;

-- 10.Identify movies that have been rated below 3 stars by more than 2 users. 
select c.content_id,c.title,c.type,COUNT(DISTINCT r.user_id) AS low_ratings 
from ratings r 
inner join content c on r.content_id = c.content_id where c.type in ('Movie') and r.rating < 3
group by c.content_id,c.title, c.type HAVING COUNT(DISTINCT r.user_id) > 2 order by low_ratings desc;

-- 11.Retrieve subscription renewal dates for all users with active plans.
select u.name,s.status,s.last_renewed,s.end_date from subscriptions s 
inner join users u on s.user_id = u.user_id where status ='Active';

-- 12.Find users who have at least five unwatched movies in their watchlist.
select u.user_id,u.name as user_name,count(wl.watchlist_id) as watchlist_count,
GROUP_CONCAT(c.title SEPARATOR ', ') as movie_titles from users u
inner join watchlist wl on u.user_id = wl.user_id
inner join content c on wl.content_id = c.content_id
LEFT JOIN watch_history wh ON wl.user_id = wh.user_id
AND wl.content_id = wh.content_id where wh.history_id IS NULL AND c.type = 'Movie'
group by u.user_id, u.name having watchlist_count >= 5;

-- 13.List the top 5 directors whose Movies and TV shows have received the highest average ratings.
SELECT c.director, ROUND(AVG(r.rating), 2) AS highest_avg_ratings
FROM ratings r
JOIN content c ON r.content_id = c.content_id
WHERE c.director IS NOT NULL
GROUP BY c.director
ORDER BY highest_avg_ratings DESC
LIMIT 5;  

-- 14.Analyze monthly subscription cancellations during the latest six months available in the dataset
SELECT
    DATE_FORMAT(end_date, '%Y-%m') AS cancellation_month,
    COUNT(*) AS total_cancellations 
FROM subscriptions
WHERE status = 'Cancelled'
AND end_date >= ( SELECT DATE_SUB(MAX(end_date), INTERVAL 6 MONTH)
FROM subscriptions
WHERE status = 'Cancelled')
GROUP BY DATE_FORMAT(end_date, '%Y-%m')
ORDER BY cancellation_month;

-- 15.Identify users who started but did not complete at least three pieces of content.
select u.user_id,u.name,count(*) as partially_watched from watch_history wh
inner join users u on wh.user_id= u.user_id where wh.is_completed= 0 group by u.user_id,u.name
having partially_watched >= 3;

-- 16.Generate a monthly subscription revenue report for the latest year available in the dataset.
SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    SUM(amount) AS monthly_revenue
FROM payments
WHERE status = 'Success'
AND payment_date >= (
    SELECT DATE_SUB(MAX(payment_date), INTERVAL 12 MONTH)
    FROM payments
    WHERE status = 'Success'
)
GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY month;

-- 17.Ensure that when a user cancels their subscription, their access is revoked immediately.
delimiter //
CREATE TRIGGER revoke_access_on_cancel
AFTER UPDATE ON subscriptions
FOR EACH ROW
BEGIN
    IF NEW.status = 'Cancelled' AND OLD.status <> 'Cancelled' THEN
        UPDATE users 
        SET has_access = 0
        WHERE user_id = NEW.user_id;
    END IF;
END; //
delimiter ;   

-- 18. Check whether a user is allowed to watch content in their geographic region.
select u.user_id,u.name AS user_name,u.country AS user_country,c.title AS movie_title,
case
        when exists(select 1 from content_regions cr where cr.content_id = c.content_id and cr.country = u.country)
        then 'Allowed'
        else 'Blocked'
    end as access_status
from users u
inner join content c on c.content_id = 11 
where u.user_id = 16;     

-- 19.Ensure that new content includes title, director, release year and creator.
DELIMITER //
CREATE TRIGGER validate_content_fields
BEFORE INSERT ON content
FOR EACH ROW
BEGIN
    IF NEW.title IS NULL
       OR NEW.director IS NULL
       OR NEW.release_year IS NULL
       OR NEW.creator_id IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Title, director, release year and creator are required.';
    END IF;
END//
DELIMITER ;

-- 20.Update a user's subscription status immediately when they successfully complete a payment.
delimiter //
CREATE TRIGGER update_subscriptions_status
AFTER INSERT ON payments
FOR EACH ROW 
BEGIN
    IF NEW.status = 'Success' THEN UPDATE subscriptions SET status = 'Active',
       last_renewed = NEW.payment_date WHERE subscription_id = NEW.subscription_id;
    END IF;
END; //
delimiter ;

-- 21.Identify users whose registered device count exceeds their plan limit.
select d.user_id,u.name, COUNT(DISTINCT d.device_id) AS multiple_devices from devices d
inner join users u on d.user_id = u.user_id
inner join subscriptions s on u.user_id = s.user_id
inner join subscription_plans sp on s.plan_id = sp.plan_id WHERE s.status = 'Active'
group by d.user_id, u.name, sp.max_devices having multiple_devices > sp.max_devices;

-- 22.Ensure that only verified content creators can modify movies or TV shows.
delimiter //
CREATE TRIGGER allow_only_verified_creators
BEFORE UPDATE ON content
FOR EACH ROW
BEGIN
    DECLARE v INT;
    -- Check if creator exists and is verified
    SELECT verified INTO v FROM creators WHERE creator_id = NEW.creator_id;
    -- If not verified, block update
    IF v IS NULL OR v = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Creator must be verified.';
    END IF;
END; //
delimiter ;

-- 23.Trigger a notification when a user's subscription is about to expire within 3 days.
set global event_scheduler = ON;
create event notify_subscription_expiry
ON SCHEDULE EVERY 1 DAY
DO
insert into notifications (user_id, type, message)
select user_id, 'Subscription Expiry','Your subscription will expire in 3 days.' from subscriptions
WHERE status = 'Active'
AND end_date = DATE_ADD(CURDATE(), INTERVAL 3 DAY);

-- 24.Find content with similar genres based on a user's watch history.
select distinct c2.title from watch_history wh
inner join content_genres cg1 on wh.content_id = cg1.content_id
inner join content_genres cg2 on cg1.genre_id = cg2.genre_id
inner join content c2 on cg2.content_id = c2.content_id
where wh.user_id = 3 and c2.content_id != wh.content_id
limit 10;

-- 25. Generate a monthly report showing the most-watched genres.
SELECT
    DATE_FORMAT(wh.watched_at, '%Y-%m') AS month,
    g.genre_name,
    COUNT(*) AS watch_count
FROM watch_history wh
JOIN content_genres cg
ON wh.content_id = cg.content_id
JOIN genres g
ON cg.genre_id = g.genre_id
GROUP BY
    DATE_FORMAT(wh.watched_at, '%Y-%m'),
    g.genre_name
ORDER BY month, watch_count DESC;
