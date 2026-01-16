/* % of users move from one stage of the funnel to the next */

WITH stage_counts AS (
  SELECT
    event_type,
    COUNT(DISTINCT user_id) AS users
  FROM ecommerce_events
  WHERE event_type IN ('view', 'cart', 'purchase')
  GROUP BY event_type
),
ordered AS (
  SELECT
    event_type,
    users,
    LAG(users) OVER (
      ORDER BY
        CASE event_type
          WHEN 'view' THEN 1
          WHEN 'cart' THEN 2
          WHEN 'purchase' THEN 3
        END
    ) AS prev_users
  FROM stage_counts
)
SELECT
  event_type AS funnel_stage,
  users AS users_in_stage,
  ROUND((users * 100.0 / prev_users), 2) AS conversion_rate_pct
FROM ordered
WHERE prev_users IS NOT NULL;

---------------------------------------------------------------------------------------------------------------------------------

/* (Session-Level Funnel) */

/* Step 1: Assign funnel order to events */

   /* Each event is assigned a numerical funnel stage. */

CASE event_type
  WHEN 'view' THEN 1
  WHEN 'cart' THEN 2
  WHEN 'purchase' THEN 3
END AS stage_order

/* Step 2: Identify maximum stage reached per session */
  
WITH session_stages AS (
  SELECT
    user_id,
    user_session,
    MAX(
      CASE event_type
        WHEN 'view' THEN 1
        WHEN 'cart' THEN 2
        WHEN 'purchase' THEN 3
      END
    ) AS max_stage
  FROM ecommerce_events
  WHERE event_type IN ('view', 'cart', 'purchase')
  GROUP BY user_id, user_session
)

/* Step 3: Calculate session-level conversion rates */
  
SELECT
  COUNT(*) FILTER (WHERE max_stage >= 1) AS view_sessions,
  COUNT(*) FILTER (WHERE max_stage >= 2) AS cart_sessions,
  COUNT(*) FILTER (WHERE max_stage = 3) AS purchase_sessions,
  ROUND(
    COUNT(*) FILTER (WHERE max_stage >= 2) * 100.0 /
    COUNT(*) FILTER (WHERE max_stage >= 1), 2
  ) AS view_to_cart_pct,
  ROUND(
    COUNT(*) FILTER (WHERE max_stage = 3) * 100.0 /
    COUNT(*) FILTER (WHERE max_stage >= 2), 2
  ) AS cart_to_purchase_pct
FROM session_stages;

--------------------------------------------------------------------------------------------------------
/* Segmentation Analysis */

/* Funnel by Category */
SELECT
  category_code,
  COUNT(*) FILTER (WHERE max_stage >= 1) AS views,
  COUNT(*) FILTER (WHERE max_stage >= 2) AS carts,
  COUNT(*) FILTER (WHERE max_stage = 3) AS purchases,
  ROUND(
    COUNT(*) FILTER (WHERE max_stage >= 2) * 100.0 /
    COUNT(*) FILTER (WHERE max_stage >= 1), 2
  ) AS view_to_cart_pct,
  ROUND(
    COUNT(*) FILTER (WHERE max_stage = 3) * 100.0 /
    COUNT(*) FILTER (WHERE max_stage >= 2), 2
  ) AS cart_to_purchase_pct
FROM session_stages s
JOIN ecommerce_events e
  ON s.user_session = e.user_session
GROUP BY category_code;

---------------------------------------------------------------------------------------------------------------

/* Advanced Behavioral Analytics */

/* Cart Abandonment Timing Analysis */

WITH cart_events AS (
  SELECT
    user_id,
    user_session,
    MIN(event_time) AS cart_time
  FROM ecommerce_events
  WHERE event_type = 'cart'
  GROUP BY user_id, user_session
),
purchase_events AS (
  SELECT
    user_id,
    user_session,
    MIN(event_time) AS purchase_time
  FROM ecommerce_events
  WHERE event_type = 'purchase'
  GROUP BY user_id, user_session
)
SELECT
  c.user_session,
  c.cart_time,
  p.purchase_time,
  CASE
    WHEN p.purchase_time IS NULL THEN 'abandoned'
    ELSE 'converted'
  END AS cart_status,
  EXTRACT(EPOCH FROM (COALESCE(p.purchase_time, c.cart_time) - c.cart_time)) / 60
    AS minutes_to_outcome
FROM cart_events c
LEFT JOIN purchase_events p
  ON c.user_id = p.user_id
 AND c.user_session = p.user_session;

/* Time to Conversion (Session-Level) */ 

WITH session_times AS (
  SELECT
    user_id,
    user_session,
    MIN(event_time) AS session_start,
    MAX(CASE WHEN event_type = 'purchase' THEN event_time END) AS purchase_time
  FROM ecommerce_events
  GROUP BY user_id, user_session
)
SELECT
  user_session,
  EXTRACT(EPOCH FROM (purchase_time - session_start)) / 60
    AS minutes_to_conversion
FROM session_times
WHERE purchase_time IS NOT NULL;

------------------------------------------------------------------------------------------------------------------------------------------------------

/* Multi-Touch Attribution Modeling (Session-Based) */

/* Identify Touchpoints per Session */
WITH ordered_events AS (
  SELECT
    user_id,
    user_session,
    event_type,
    event_time,
    ROW_NUMBER() OVER (
      PARTITION BY user_session
      ORDER BY event_time
    ) AS step_number
  FROM ecommerce_events
)

/* First-Touch Attribution */
  
SELECT
  event_type AS first_touch,
  COUNT(*) AS conversions
FROM ordered_events
WHERE step_number = 1
  AND user_session IN (
    SELECT DISTINCT user_session
    FROM ecommerce_events
    WHERE event_type = 'purchase'
  )
GROUP BY event_type;

/* Last-Touch Attribution */ 

SELECT
  event_type AS last_touch,
  COUNT(*) AS conversions
FROM ordered_events
WHERE user_session IN (
  SELECT DISTINCT user_session
  FROM ecommerce_events
  WHERE event_type = 'purchase'
)
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY user_session
  ORDER BY event_time DESC
) = 1;

/* Linear Attribution (Equal Credit) */

WITH conversion_sessions AS (
  SELECT DISTINCT user_session
  FROM ecommerce_events
  WHERE event_type = 'purchase'
)
SELECT
  event_type,
  COUNT(*) * 1.0 /
  COUNT(DISTINCT user_session) AS attribution_weight
FROM ecommerce_events
WHERE user_session IN (
  SELECT user_session FROM conversion_sessions
)
GROUP BY event_type;
