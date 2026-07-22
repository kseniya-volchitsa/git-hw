#!/bin/bash
# Файл: run_queries.sh

echo "=========================================="
echo "=== Задание 1: Информация о магазине ==="
echo "=========================================="
docker exec -i mysql-hw mysql -u root -proot_password -D sakila -e "
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    c.city AS store_city,
    COUNT(cu.customer_id) AS customer_count
FROM store st
JOIN staff s ON st.manager_staff_id = s.staff_id
JOIN address a ON st.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
JOIN customer cu ON st.store_id = cu.store_id
GROUP BY st.store_id, s.first_name, s.last_name, c.city
HAVING COUNT(cu.customer_id) > 300;
"

echo -e "\n=========================================="
echo "=== Задание 2: Фильмы длиннее среднего ==="
echo "=========================================="
docker exec -i mysql-hw mysql -u root -proot_password -D sakila -e "
SELECT COUNT(*) AS films_longer_than_avg
FROM film
WHERE length > (SELECT AVG(length) FROM film);
"

echo -e "\n=========================================="
echo "=== Задание 3: Месяц с наибольшей суммой ==="
echo "=========================================="
docker exec -i mysql-hw mysql -u root -proot_password -D sakila -e "
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    SUM(amount) AS total_amount,
    COUNT(rental_id) AS rental_count
FROM payment
GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY total_amount DESC
LIMIT 1;
"

echo -e "\n=========================================="
echo "=== Задание 4: Премия продавцов ==="
echo "=========================================="
docker exec -i mysql-hw mysql -u root -proot_password -D sakila -e "
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    COUNT(p.payment_id) AS sales_count,
    CASE 
        WHEN COUNT(p.payment_id) > 8000 THEN 'Да'
        ELSE 'Нет'
    END AS bonus
FROM staff s
JOIN payment p ON s.staff_id = p.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name;
"

echo -e "\n=========================================="
echo "=== Задание 5: Фильмы без аренд ==="
echo "=========================================="
docker exec -i mysql-hw mysql -u root -proot_password -D sakila -e "
SELECT 
    f.film_id,
    f.title,
    f.release_year,
    f.rental_rate
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL
GROUP BY f.film_id, f.title, f.release_year, f.rental_rate
LIMIT 10;
"
