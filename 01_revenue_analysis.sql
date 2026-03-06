-- Section 1: Revenue Analysis

-- Q1.Total revrnue busisness has earned?
use sakila;
Select round(sum(amount),2) as total_revenue
from payment ;
-- Q2. Revenue by month
Select 
Year(payment_date) as year,
Month(payment_date) as month,
round(sum(amount),2) as monthly_revenue
from payment 
group by year,month
order by year, month;
-- This shows which months were best for business
-- Month 7 means july
-- Q3.Top 10 customers by total spending
SELECT 
    c.first_name,
    c.last_name,
    c.email,
    ROUND(SUM(p.amount), 2) AS total_spent,
    COUNT(p.payment_id) AS total_payments
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
ORDER BY total_spent DESC
LIMIT 10;
-- This shows Who are our most valuable customers?
-- Q4. Revenue by store
Select 
s.store_id,
ci.city_id,
co.country_id,
Round(sum(p.amount), 2) as total_revenue,
count(p.payment_id) as total_transaction
from payment p
join staff st on p.staff_id = st.staff_id
join store s on st.store_id = s.store_id
join address ad on s.address_id = ad.address_id
join city ci on ad.city_id = ci.city_id
join country co on ci.country_id = co.country_id
group by s.store_id,
ci.city_id,
co.country_id
order by total_revenue DESC;
-- This shows Which store is making more money?
-- Store 2
-- Q5. Revenue by day of week
SELECT 
dayname(payment_date) as day_of_week,
count(payment_id) as total_transaction,
round(sum(amount),2) as total_revenue,
round(avg(amount),2) as avg_transaction_value
from payment
group by day_of_week
order by total_revenue DESC;
-- This shows  Which day of the week is busiest?
-- Tuesday
