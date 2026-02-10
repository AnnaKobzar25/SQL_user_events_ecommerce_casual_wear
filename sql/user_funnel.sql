# User funnel analysis (Visit → View → Add to Cart → Checkout → Purchase)
WITH tb1 AS (
  SELECT *
  FROM (
    SELECT event_type, COUNT(*) AS cnt
    FROM `innate-ally-485909-n6.Casual_Wear_1234.casual_wear`
    GROUP BY event_type
  )
  PIVOT (
    SUM(cnt) FOR event_type IN ('visit', 'view', 'add_to_cart', 'checkout', 'purchase')
  )
)
SELECT 
  ROUND(view/visit, 2) * 100 AS conv1,
  ROUND(add_to_cart/view, 2) * 100 AS con2,
  ROUND(checkout/add_to_cart, 2) * 100 AS con3,
  ROUND(purchase/checkout, 2) * 100 AS con4
FROM tb1;


