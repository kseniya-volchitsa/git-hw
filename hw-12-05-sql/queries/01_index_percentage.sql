-- Задание 1: Процентное отношение размера индексов к размеру таблиц
SELECT 
    CONCAT(
        ROUND(
            (SELECT SUM(INDEX_LENGTH) 
             FROM INFORMATION_SCHEMA.TABLES 
             WHERE TABLE_SCHEMA = 'sakila') / 
            (SELECT SUM(DATA_LENGTH + INDEX_LENGTH) 
             FROM INFORMATION_SCHEMA.TABLES 
             WHERE TABLE_SCHEMA = 'sakila') * 100, 2
        ), '%'
    ) AS index_percentage;

-- Альтернативное решение с детализацией по таблицам
SELECT 
    TABLE_NAME,
    ROUND(DATA_LENGTH / 1024 / 1024, 2) AS table_size_mb,
    ROUND(INDEX_LENGTH / 1024 / 1024, 2) AS index_size_mb,
    CONCAT(ROUND(INDEX_LENGTH / DATA_LENGTH * 100, 2), '%') AS index_percentage
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'sakila'
  AND DATA_LENGTH > 0
ORDER BY index_percentage DESC;
