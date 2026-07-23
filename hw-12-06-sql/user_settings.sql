-- Создаём пользователя для репликации
CREATE USER 'replication'@'%' IDENTIFIED BY 'replication_password';
GRANT REPLICATION SLAVE ON *.* TO 'replication'@'%';
FLUSH PRIVILEGES;

-- Получаем статус мастера
SHOW MASTER STATUS;
