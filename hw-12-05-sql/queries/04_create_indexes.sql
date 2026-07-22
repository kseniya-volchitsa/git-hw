-- Задание 2: Создание индексов для оптимизации

-- Индекс для ускорения фильтрации по дате
CREATE INDEX idx_payment_date ON payment(payment_date);

-- Индекс для payment-rental связей
CREATE INDEX idx_payment_rental ON payment(rental_id);

-- Составной индекс для соединений
CREATE INDEX idx_rental_customer_inventory ON rental(customer_id, inventory_id);

-- Индекс для inventory-film связей
CREATE INDEX idx_inventory_film ON inventory(film_id);

-- Проверка созданных индексов
SHOW INDEX FROM payment;
SHOW INDEX FROM rental;
SHOW INDEX FROM inventory;
