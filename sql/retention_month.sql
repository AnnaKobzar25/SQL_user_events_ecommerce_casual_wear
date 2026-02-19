WITH cohort AS (
  SELECT
    user_id,
    DATE_TRUNC(MIN(event_date), month) AS cohort_month
  FROM `innate-ally-485909-n6.Casual_Wear_1234.casual_wear`
  GROUP BY user_id
),

-- 2. Determine the activity month for each event
activity AS (
  SELECT
    user_id,
    DATE_TRUNC(event_date,month) AS activity_month
  FROM `innate-ally-485909-n6.Casual_Wear_1234.casual_wear`
),

-- 3. Calculate week_number = difference between activity week and cohort week
joined AS (
  SELECT
    c.cohort_month,
    DATE_DIFF(a.activity_month, c.cohort_month, month) AS month_number,
    a.user_id
  FROM cohort c
  JOIN activity a USING (user_id)
  WHERE DATE_DIFF(a.activity_month, c.cohort_month, month) >= 0
),

-- 4. Count unique users per cohort_month and month_number
agg AS (
  SELECT
    cohort_month,
    month_number,
    COUNT(DISTINCT user_id) AS users
  FROM joined
  GROUP BY 1, 2
),

-- 5. Get cohort size (month 0)
cohort_size AS (
  SELECT
    cohort_month,
    users AS cohort_users
  FROM agg
  WHERE month_number = 0
)

-- 6. Final retention table 
SELECT
  a.cohort_month,
  a.month_number,
  a.users,
  ROUND(a.users / c.cohort_users * 100, 1) AS retention_percent
FROM agg a
JOIN cohort_size c USING (cohort_month)
ORDER BY cohort_month, month_number;
