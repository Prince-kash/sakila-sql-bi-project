-- Section 5 — Advanced Queries 
-- Q19. Running total revenue by month
SELECT 
    YEAR(payment_date) AS year,
    MONTH(payment_date) AS month,
    ROUND(SUM(amount), 2) AS monthly_revenue,
    ROUND(SUM(SUM(amount)) OVER (
        ORDER BY YEAR(payment_date), MONTH(payment_date)
    ), 2) AS cumulative_revenue
FROM payment
GROUP BY year, month
ORDER BY year, month;

-- Q20. Month over month revenue growth %
WITH monthly AS (
    SELECT 
        YEAR(payment_date) AS year,
        MONTH(payment_date) AS month,
        ROUND(SUM(amount), 2) AS revenue
    FROM payment
    GROUP BY year, month
),
with_growth AS (
    SELECT *,
        LAG(revenue) OVER (ORDER BY year, month) AS prev_revenue
    FROM monthly
)
SELECT 
    year, month, revenue, prev_revenue,
    ROUND(((revenue - prev_revenue) / prev_revenue) * 100, 2) AS growth_pct
FROM with_growth
WHERE prev_revenue IS NOT NULL;
-- Which month had the biggest growth jump?
-- july month

-- Q21. Customer ranking by total spending
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    ROUND(SUM(p.amount), 2) AS total_spent,
    RANK() OVER (ORDER BY SUM(p.amount) DESC) AS spending_rank,
    ROUND(SUM(p.amount) * 100.0 / SUM(SUM(p.amount)) OVER (), 2) AS revenue_share_pct
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY spending_rank
LIMIT 10;

-- Q22. Films with above average rental rate
WITH avg_rate AS (
    SELECT ROUND(AVG(rental_rate), 2) AS avg_rental_rate 
    FROM film
)
SELECT 
    f.title,
    f.rental_rate,
    ar.avg_rental_rate,
    ROUND(f.rental_rate - ar.avg_rental_rate, 2) AS above_avg_by,
    c.name AS category
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
CROSS JOIN avg_rate ar
WHERE f.rental_rate > ar.avg_rental_rate
ORDER BY f.rental_rate DESC
LIMIT 10;

-- Q23. Late returns analysis
SELECT 
    f.title,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    r.rental_date,
    r.return_date,
    f.rental_duration AS allowed_days,
    DATEDIFF(r.return_date, r.rental_date) AS actual_days,
    DATEDIFF(r.return_date, r.rental_date) - f.rental_duration AS days_overdue
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE r.return_date IS NOT NULL
AND DATEDIFF(r.return_date, r.rental_date) > f.rental_duration
ORDER BY days_overdue DESC
LIMIT 10;

SELECT 
    f.rating,
    COUNT(r.rental_id) AS total_rentals,
    ROUND(SUM(p.amount), 2) AS total_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.rating
ORDER BY total_revenue DESC;

-- 1. July is peak season → "Run promotions in June to maximize July revenue further"
-- 2. Store 2 outperforms Store 1 → "Investigate Store 1 operations — staffing, inventory, or location issue?"
-- 3. Tuesday is busiest → "Shift weekend marketing budget to weekday promotions"
-- 4. Only 7 VIP customers → "Launch loyalty program targeting the 'Loyal' segment to convert them to VIP"
-- 5. Late returns happening → "Implement automated reminder system 1 day before due date"
