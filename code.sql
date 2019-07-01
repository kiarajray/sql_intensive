/*Usage Funnels*/

/*Query 1 - select data from table*/
SELECT *
FROM survey 
LIMIT 10;
 
/*Query 2 - quiz funnel*/
SELECT question, COUNT(user_id)
FROM survey
GROUP BY 1;
 
/*Query 3 - purchase funnel*/ 
SELECT * 
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

/* Query 4 - create new table */

WITH funnels AS(SELECT DISTINCT q.user_id,  
                h.user_id IS NOT NULL AS 'is_home_try_on',
                h.number_of_pairs, 
                p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q 
LEFT JOIN home_try_on h
                ON q.user_id = h.user_id
LEFT JOIN purchase p
                ON p.user_id = q.user_id)

SELECT *
FROM funnels
LIMIT 10;


-- conversion rates --
WITH funnels AS(SELECT DISTINCT q.user_id,  
                h.user_id IS NOT NULL AS 'is_home_try_on',
                h.number_of_pairs, 
                p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q 
LEFT JOIN home_try_on h
                ON q.user_id = h.user_id
LEFT JOIN purchase p
                ON p.user_id = q.user_id)

SELECT COUNT(user_id) AS 'Number of Users', 
1.0*SUM(is_home_try_on)/count(user_id) AS 'Quiz to Home Try-On Conversion' , 
1.0*SUM(is_purchase)/SUM(is_home_try_on)AS 'Home Try-On Purchase Conversion',
1.0*SUM(is_purchase)/COUNT(user_id) AS 'Quiz to Purchase'
FROM funnels;

--Purchase rates by # of glasses --
WITH funnels AS(SELECT DISTINCT q.user_id,  
                h.user_id IS NOT NULL AS 'is_home_try_on',
                h.number_of_pairs, 
                p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q 
LEFT JOIN home_try_on h
                ON q.user_id = h.user_id
LEFT JOIN purchase p
                ON p.user_id = q.user_id)

SELECT number_of_pairs AS 'Number of Pairs',
COUNT(user_id) AS 'Number of Users', 
SUM(is_home_try_on) AS 'Number of Home Try-On', 
SUM(is_purchase) AS 'Total Number of Purchases', 
ROUND(1.0*SUM(is_purchase)/SUM(is_home_try_on), 3) AS 'Try-On to Purchase Conversion Rate'
FROM funnels
WHERE number_of_pairs IS NOT NULL
GROUP BY 1;
 
 
--additional insigths --

SELECT color, COUNT(*)
FROM purchase
GROUP BY 1
ORDER BY 2 DESC;

SELECT color, COUNT(*)
FROM purchase
WHERE style = "Women's Styles"
GROUP BY 1
ORDER BY 2 DESC;

SELECT color, COUNT(*)
FROM purchase
WHERE style = "Men's Styles"
GROUP BY 1
ORDER BY 2 DESC;

SELECT price, COUNT(*)
FROM purchase
GROUP BY 1
ORDER BY 2 DESC;

SELECT fit, COUNT(*)
FROM quiz
GROUP BY 1;

SELECT shape, COUNT(*)
FROM quiz
GROUP BY 1;
