#!/bin/bash
# Файл: run_queries.sh

echo "=== Задание 1: Уникальные районы ==="
docker exec -it postgres-hw psql -U postgres -d bookstore -p 5432 -c "
SELECT DISTINCT district
FROM address
WHERE district LIKE 'K%a'
  AND district NOT LIKE '% %';
"

echo -e "\n=== Задание 2: Платежи за период ==="
docker exec -it postgres-hw psql -U postgres -d bookstore -p 5432 -c "
SELECT payment_id, customer_id, staff_id, rental_id, amount, payment_date
FROM payment
WHERE payment_date BETWEEN '2005-06-15' AND '2005-06-18 23:59:59'
  AND amount > 10.00
ORDER BY payment_date;
"

echo -e "\n=== Задание 3: Последние 5 аренд ==="
docker exec -it postgres-hw psql -U postgres -d bookstore -p 5432 -c "
SELECT rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update
FROM rental
ORDER BY rental_date DESC
LIMIT 5;
"

echo -e "\n=== Задание 4: Активные покупатели ==="
docker exec -it postgres-hw psql -U postgres -d bookstore -p 5432 -c "
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

echo -e "\n=== Задание 5: Разбивка Email ==="
docker exec -it postgres-hw psql -U postgres -d bookstore -p 5432 -c "
SELECT 
    email,
    SUBSTRING(email, 1, POSITION('@' IN email) - 1) AS email_local_part,
    SUBSTRING(email, POSITION('@' IN email) + 1) AS email_domain
FROM customer
LIMIT 10;
"

echo -e "\n=== Задание 6: Email с INITCAP ==="
docker exec -it postgres-hw psql -U postgres -d bookstore -p 5432 -c "
SELECT 
    email,
    INITCAP(SUBSTRING(email, 1, POSITION('@' IN email) - 1)) AS email_local_part,
    INITCAP(SUBSTRING(email, POSITION('@' IN email) + 1)) AS email_domain
FROM customer
LIMIT 10;
"
