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

Purpose: Measure funnel efficiency.

WITH stage_counts AS (
  SELECT
    event_type,
    COUNT(DISTINCT user_id) AS users
  FROM events
  GROUP BY event_type
),
ordered AS (
  SELECT
    event_type,
    users,
    LAG(users) OVER (
      ORDER BY
        CASE event_type
          WHEN 'visit' THEN 1
          WHEN 'product_view' THEN 2
          WHEN 'add_to_cart' THEN 3
          WHEN 'checkout' THEN 4
          WHEN 'purchase' THEN 5
        END
    ) AS prev_users
  FROM stage_counts
)
SELECT
  event_type,
  users,
  ROUND((users * 100.0 / prev_users), 2) AS conversion_rate_pct
FROM ordered
WHERE prev_users IS NOT NULL;

🔹 CATEGORY 2: DROP-OFF & LEAKAGE ANALYSIS
Q3. At which stage is the maximum user drop-off happening?

Purpose: Identify biggest leakage point.

SELECT
  event_type,
  prev_users - users AS drop_off_users
FROM ordered
WHERE prev_users IS NOT NULL
ORDER BY drop_off_users DESC;

Q4. What percentage of total visitors end up purchasing?

Purpose: Executive-level KPI.

WITH visits AS (
  SELECT COUNT(DISTINCT user_id) AS visit_users
  FROM events
  WHERE event_type = 'visit'
),
purchases AS (
  SELECT COUNT(DISTINCT user_id) AS purchase_users
  FROM events
  WHERE event_type = 'purchase'
)
SELECT
  ROUND((purchase_users * 100.0 / visit_users), 2) AS overall_conversion_rate
FROM visits, purchases;

🔹 CATEGORY 3: SEGMENTED FUNNEL QUESTIONS
Q5. Which traffic source produces the most purchases?

Purpose: Marketing optimization.

SELECT
  s.traffic_source,
  COUNT(DISTINCT e.user_id) AS purchases
FROM events e
JOIN sessions s ON e.session_id = s.session_id
WHERE e.event_type = 'purchase'
GROUP BY s.traffic_source
ORDER BY purchases DESC;

Q6. How does funnel performance differ by device type?

Purpose: UX & product optimization.

SELECT
  u.device_type,
  COUNT(DISTINCT e.user_id) AS purchases
FROM events e
JOIN users u ON e.user_id = u.user_id
WHERE e.event_type = 'purchase'
GROUP BY u.device_type;

🔹 CATEGORY 4: TIME & BEHAVIOR ANALYSIS
Q7. How long does it take users to convert from visit to purchase?

Purpose: Identify friction and delays.

SELECT
  user_id,
  MIN(CASE WHEN event_type = 'visit' THEN event_timestamp END) AS visit_time,
  MIN(CASE WHEN event_type = 'purchase' THEN event_timestamp END) AS purchase_time
FROM events
GROUP BY user_id
HAVING purchase_time IS NOT NULL;

🔹 CATEGORY 5: BUSINESS SCENARIOS & SIMULATION
Q8. If checkout conversion improves by 20%, how many more purchases occur?

Purpose: Impact forecasting.

SELECT
  COUNT(DISTINCT user_id) * 0.20 AS additional_purchases
FROM events
WHERE event_type = 'purchase';

Q9. What is the revenue impact of this improvement?

Purpose: ROI estimation.

SELECT
  (COUNT(DISTINCT user_id) * 0.20) * 2000 AS additional_revenue
FROM events
WHERE event_type = 'purchase';

🔹 CATEGORY 6: DECISION-LEVEL QUESTIONS
Q10. Which funnel stage should be prioritized for optimization?

Purpose: Strategic decision.

SELECT
  event_type,
  prev_users - users AS drop_off
FROM ordered
WHERE prev_users IS NOT NULL
ORDER BY drop_off DESC
LIMIT 1;
/* Covers end-to-end funnel analysis */
/* Includes segmentation & forecasting */
