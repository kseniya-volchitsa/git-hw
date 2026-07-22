-- Задание 2: Оптимизированный запрос
EXPLAIN ANALYZE
SELECT 
    CONCAT(c.last_name, ' ', c.first_name) AS full_name,
    SUM(p.amount) AS total_amount
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN customer c ON r.customer_id = c.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE p.payment_date >= '2005-07-30 00:00:00'
  AND p.payment_date < '2005-07-31 00:00:00'
GROUP BY c.customer_id, c.last_name, c.first_name;

-- Выполнение запроса без EXPLAIN для проверки результата
SELECT 
    CONCAT(c.last_name, ' ', c.first_name) AS full_name,
    SUM(p.amount) AS total_amount
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN customer c ON r.customer_id = c.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE p.payment_date >= '2005-07-30 00:00:00'
  AND p.payment_date < '2005-07-31 00:00:00'
GROUP BY c.customer_id, c.last_name, c.first_name
ORDER BY total_amount DESC;
