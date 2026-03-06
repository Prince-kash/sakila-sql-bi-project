-- Section 2 — Film Performance.

-- Q6. Most rented film categories
Select 
c.name as category,
count(r.rental_id) as total_rentals,
round(sum(p.amount),2) as total_revenue
from rental r
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join film_category fc on f.film_id= fc.film_id
join category c on fc.category_id = c.category_id
join payment p on r.rental_id = p.rental_id
group by c.name
order by total_revenue desc;
-- This shows Which movie genre is most popular?
-- Sports


-- Q7. Top 10 most rented films
Select 
f.title,
count(r.rental_id) as total_rentals,
round(sum(p.amount),2) as total_revenue
from rental r
join inventory i on r.inventory_id= i.inventory_id
join film f on i.film_id = f.film_id
join payment p on r.rental_id = p.rental_id
group by f.film_id, f.title
order by total_revenue desc
limit 10;


-- Q8. Average rental duration by category
Select 
c.name as category,
round(avg(f.rental_duration),1) as avg_rental_days,
round(avg(f.rental_rate),1) as avg_rental_rate,
count(f.film_id) as total_films
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
group by c.name
order by avg_rental_rate desc;
-- This Shows Which category charges the most per rental?

-- Q9. Films never rented (underperforming inventory)
SELECT 
    f.title,
    f.rental_rate,
    f.rating,
    c.name AS category
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL
ORDER BY f.rental_rate DESC;
-- Business question: Which films are wasting shelf space?


-- Q10. Revenue by film rating (G, PG, R etc.)
SELECT 
    f.rating,
    COUNT(DISTINCT f.film_id) AS total_films,
    COUNT(r.rental_id) AS total_rentals,
    ROUND(SUM(p.amount), 2) AS total_revenue,
    ROUND(AVG(p.amount), 2) AS avg_revenue_per_rental
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.rating
ORDER BY total_revenue DESC;

-- Sports + PG-13 together tells a story:
-- "Family-friendly sports content drives the most rentals — marketing strategy should focus on sports titles with PG-13 ratings to maximize revenue"
