-- ============================================================
-- Weekly Retention Analysis
-- ------------------------------------------------------------
-- This query calculates weekly retention based on user activity.
-- Retention is defined as the percentage of users who return
-- in week N after their first activity week (cohort week).
--
-- Output format (long format):
--   cohort_week | week_number | users | retention_percent
-- ============================================================

-- 1. Determine the cohort week (first activity week) for each user
WITH cohort AS (
  SELECT
    user_id,
    DATE_TRUNC(MIN(event_date), WEEK(MONDAY)) AS cohort_week
  FROM `innate-ally-485909-n6.Casual_Wear_1234.casual_wear`
  GROUP BY user_id
),

-- 2. Determine the activity week for each event
activity AS (
  SELECT
    user_id,
    DATE_TRUNC(event_date, WEEK(MONDAY)) AS activity_week
  FROM `innate-ally-485909-n6.Casual_Wear_1234.casual_wear`
),

-- 3. Calculate week_number = difference between activity week and cohort week
joined AS (
  SELECT
    c.cohort_week,
    DATE_DIFF(a.activity_week, c.cohort_week, WEEK) AS week_number,
    a.user_id
  FROM cohort c
  JOIN activity a USING (user_id)
  WHERE DATE_DIFF(a.activity_week, c.cohort_week, WEEK) >= 0
),

-- 4. Count unique users per cohort_week and week_number
agg AS (
  SELECT
    cohort_week,
    week_number,
    COUNT(DISTINCT user_id) AS users
  FROM joined
  GROUP BY 1, 2
),

-- 5. Get cohort size (week 0)
cohort_size AS (
  SELECT
    cohort_week,
    users AS cohort_users
  FROM agg
  WHERE week_number = 0
)

-- 6. Final retention table (long format)
SELECT
  a.cohort_week,
  a.week_number,
  a.users,
  ROUND(a.users / c.cohort_users * 100, 1) AS retention_percent
FROM agg a
JOIN cohort_size c USING (cohort_week)
ORDER BY cohort_week, week_number;
