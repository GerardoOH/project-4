SELECT 
    u.user_id AS UserID,
    u.age AS Age,
    u.gender AS Gender,
    u.subscription_plan AS SubscriptionPlan,
    u.sign_up_date AS RegistrationDate,
    MAX(c.checkout_time) AS LastVisitDate,
    ROUND(
        COUNT(c.checkin_time) / NULLIF(EXTRACT(MONTH FROM AGE(CURRENT_DATE, u.sign_up_date)), 0), 2
    ) AS AverageVisitFrequency,
    ROUND(AVG(EXTRACT(EPOCH FROM (c.checkout_time - c.checkin_time)) / 60), 2) AS AverageSessionDuration,
    c.workout_type AS FavoriteActivity,
    COUNT(c.checkin_time) / NULLIF(EXTRACT(MONTH FROM AGE(CURRENT_DATE, u.sign_up_date)), 0) AS MonthlyUsage,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, u.sign_up_date)) * 12 + EXTRACT(MONTH FROM AGE(CURRENT_DATE, u.sign_up_date)) AS MonthsActive,
    CASE 
        WHEN MAX(c.checkout_time) < CURRENT_DATE - INTERVAL '3 months' THEN 1
        ELSE 0
    END AS Churn
FROM 
    users_data u
LEFT JOIN 
    checkin_checkout_history_update c ON u.user_id = c.user_id
LEFT JOIN 
    gym_locations_data g ON c.gym_id = g.gym_id
LEFT JOIN 
    subscription_plans s ON u.subscription_plan = s.subscription_plan
GROUP BY 
    u.user_id, u.age, u.gender, u.subscription_plan, u.sign_up_date, c.workout_type;
