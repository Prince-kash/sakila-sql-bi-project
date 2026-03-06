-- Section 4 — Store & Staff Performance.

-- Q16. Staff performance comparison
select 
concat(s.first_name,' ',s.last_name) as staff_name,
st.store_id,
count(p.payment_id) as total_transactions,
round(sum(p.amount),2) as total_revenue,
round(avg(p.amount),2) as avg_transaction_value
from staff s
join payment p on s.staff_id= p.staff_id
join store st on s.store_id= st.store_id
group by s.staff_id,staff_name, st.store_id
order by total_revenue desc;
-- Which staff member brings more revenue?
-- Jon Stephens

-- Q17. Monthly rentals per store
select 
st.store_id,
Year(r.rental_date) as year,
Month(r.rental_date) as month,
count(r.rental_id) as total_rentals
from rental r
join inventory i on r.inventory_id= i.inventory_id
join store st on i.store_id = st.store_id
group by st.store_id, year, month
order by st.store_id, year, month;
-- Which store is growing faster month over month?
-- store 2

-- Q18. Inventory count per store per category

SELECT 
    st.store_id,
    c.name AS category,
    COUNT(i.inventory_id) AS total_inventory
FROM inventory i
JOIN store st ON i.store_id = st.store_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY st.store_id, c.name
ORDER BY st.store_id, total_inventory DESC;
