SELECT *
FROM survey
LIMIT 10;

SELECT question, COUNT(DISTINCT user_id) AS 'responses'
FROM survey
GROUP BY 1;

SELECT *
FROM quiz;

SELECT *
FROM home_try_on;

SELECT *
FROM purchase;

SELECT DISTINCT q.user_id,
	CASE
  	WHEN hto.user_id IS NOT NULL THEN 'True'
    WHEN hto.user_id IS NULL THEN 'False'
  END AS 'is_home_try_on',
  hto.number_of_pairs,
  CASE
  	WHEN p.user_id IS NOT NULL THEN 'True'
    WHEN p.user_id IS NULL THEN 'False'
  END AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'hto'
  ON q.user_id = hto.user_id
LEFT JOIN purchase AS 'p'
  ON p.user_id = q.user_id;

WITH funnels AS (SELECT DISTINCT q.user_id,
	hto.user_id IS NOT NULL AS 'is_home_try_on',
  hto.number_of_pairs,
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'hto'
	ON q.user_id = hto.user_id
LEFT JOIN purchase AS 'p'
	ON p.user_id = q.user_id)
SELECT DISTINCT number_of_pairs, is_purchase, COUNT(*) AS 'purchased_items'
FROM funnels
GROUP BY 1, 2;

WITH funnels AS (SELECT quiz.user_id,
	home_try_on.user_id IS NOT NULL AS 'is_home_try_on',
purchase.user_id IS NOT NULL AS 'is_purchase'
FROM quiz
LEFT JOIN home_try_on
	ON home_try_on.user_id = quiz.user_id
LEFT JOIN purchase
	ON purchase.user_id = home_try_on.user_id)
SELECT SUM(is_home_try_on) AS 'num_home_try_on',
	SUM(is_purchase) AS 'num_purchase',
1.0 * SUM(is_home_try_on) / COUNT(user_id) AS 'browse_to_checkout',
1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS 'checkout_to_purchase'
FROM funnels;

SELECT style,
	model_name,
	COUNT(*) AS 'number_of_purchases'
FROM purchase
GROUP BY 1, 2;

SELECT style,
 	shape,
 	COUNT(*) AS 'results'
FROM quiz
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 5;
