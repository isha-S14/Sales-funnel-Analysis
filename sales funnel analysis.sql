/* Q1. How many users are there at each funnel stage? */

SELECT
  event_type AS funnel_stage,
  COUNT(DISTINCT user_id) AS users
FROM events
GROUP BY event_type
ORDER BY
  CASE event_type
    WHEN 'visit' THEN 1
    WHEN 'product_view' THEN 2
    WHEN 'add_to_cart' THEN 3
    WHEN 'checkout' THEN 4
    WHEN 'purchase' THEN 5
  END;

/* Purpose: Understand funnel size and structure. */

/* Q2. What percentage of users move from one stage to the next? */ 


/* Covers end-to-end funnel analysis */
/* Includes segmentation & forecasting */
