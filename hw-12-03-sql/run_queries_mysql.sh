#!/bin/bash

echo "=========================================="
echo "=== Задание 1: Уникальные районы ==="
echo "=========================================="
docker exec -i mysql-hw mysql -u root -proot_password -D sakila -e "
SELECT DISTINCT district
FROM address
WHERE district LIKE 'K%a'
  AND district NOT LIKE '% %';
"

echo -e "\n=========================================="
echo "=== Задание 2: Платежи за период ==="
echo "=========================================="
docker exec -i mysql-hw mysql -u root -proot_password -D sakila -e "
SELECT payment_id, customer_id, staff_id, rental_id, amount, payment_date
FROM payment
WHERE payment_date BETWEEN '2005-06-15' AND '2005-06-18 23:59:59'
  AND amount > 10.00
ORDER BY payment_date;
"

echo -e "\n=========================================="
echo "=== Задание 3: Последние 5 аренд ==="
echo "=========================================="
docker exec -i mysql-hw mysql -u root -proot_password -D sakila -e "
SELECT rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update
FROM rental
ORDER BY rental_date DESC
LIMIT 5;
"

echo -e "\n=========================================="
echo "=== Задание 4: Активные покупатели ==="
echo "=========================================="
docker exec -i mysql-hw mysql -u root -proot_password -D sakila -e "
SELECT 
    LOWER(first_name) AS first_name,
    LOWER(last_name) AS last_name,
    REPLACE(LOWER(first_name), 'll', 'pp') AS modified_first_name,
    email,
    active
FROM customer
WHERE (first_name = 'Kelly' OR first_name = 'Willie')
  AND active = 1;
"

echo -e "\n=========================================="
echo "=== Задание 5: Разбивка Email ==="
echo "=========================================="
docker exec -i mysql-hw mysql -u root -proot_password -D sakila -e "
SELECT 
    email,
    SUBSTRING_INDEX(email, '@', 1) AS email_local_part,
    SUBSTRING_INDEX(email, '@', -1) AS email_domain
FROM customer
LIMIT 10;
"

echo -e "\n=========================================="
echo "=== Задание 6: Email с форматированием ==="
echo "=========================================="
docker exec -i mysql-hw mysql -u root -proot_password -D sakila -e "
SELECT 
    email,
    CONCAT(
        UPPER(SUBSTRING(SUBSTRING_INDEX(email, '@', 1), 1, 1)),
        LOWER(SUBSTRING(SUBSTRING_INDEX(email, '@', 1), 2))
    ) AS email_local_part,
    CONCAT(
        UPPER(SUBSTRING(SUBSTRING_INDEX(email, '@', -1), 1, 1)),
        LOWER(SUBSTRING(SUBSTRING_INDEX(email, '@', -1), 2))
    ) AS email_domain
FROM customer
LIMIT 10;
"
