-- Section 3 — Customer Analysis.

-- Q11. Total customers per country
Select 
co.country,
count(c.customer_id) as total_customers
from customer c
join address  a on c.address_id= a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id= co.country_id
group by co.country
order by total_customers desc;


-- Q12. Customer segmentation by rental frequency 
WITH customer_rentals AS (
    SELECT 
        customer_id,
        COUNT(rental_id) AS total_rentals
    FROM rental
    GROUP BY customer_id
)
SELECT 
    CASE 
        WHEN total_rentals >= 40 THEN 'VIP (40+ rentals)'
        WHEN total_rentals BETWEEN 25 AND 39 THEN 'Loyal (25-39 rentals)'
        WHEN total_rentals BETWEEN 10 AND 24 THEN 'Regular (10-24 rentals)'
        ELSE 'Occasional (under 10)'
    END AS customer_segment,
    COUNT(*) AS total_customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM customer_rentals
GROUP BY customer_segment
ORDER BY total_customers DESC;
-- Loyal (25-39 rentals)


-- Q13. Top 10 cities by revenue
SELECT 
    ci.city,
    co.country,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    ROUND(SUM(p.amount), 2) AS total_revenue
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
GROUP BY ci.city, co.country
ORDER BY total_revenue DESC
LIMIT 10;
-- Cape Coral

-- Q14. Active vs inactive customers
SELECT 
    CASE WHEN active = 1 THEN 'Active' ELSE 'Inactive' END AS status,
    COUNT(*) AS total_customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM customer
GROUP BY active;
-- 584
-- Q15. Average spending per customer by country
SELECT 
    co.country,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    ROUND(SUM(p.amount), 2) AS total_revenue,
    ROUND(AVG(p.amount), 2) AS avg_spend_per_transaction,
    ROUND(SUM(p.amount) / COUNT(DISTINCT c.customer_id), 2) AS avg_revenue_per_customer
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
GROUP BY co.country
ORDER BY avg_revenue_per_customer DESC
LIMIT 10;

-- Only 7 VIP customers out of 599 — that's just 1.1%

-- -- "VIP customers represent only 1.1% of the customer base — a targeted loyalty program could convert 'Loyal' segment customers into VIPs, potentially increasing revenue significantly"
