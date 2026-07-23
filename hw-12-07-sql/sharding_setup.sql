-- Таблицы для каждого шарда
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50),
    email VARCHAR(100),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200),
    author VARCHAR(100),
    isbn VARCHAR(20) UNIQUE,
    price DECIMAL(10, 2),
    stock_quantity INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS stores (
    store_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    city VARCHAR(50),
    phone VARCHAR(20)
);

-- Функция для определения шарда по user_id
DELIMITER //
CREATE FUNCTION get_shard_id(p_user_id INT) 
RETURNS INT DETERMINISTIC
BEGIN
    RETURN (p_user_id % 3) + 1;
END //
DELIMITER ;

-- Настройка ProxySQL
-- Добавление серверов в ProxySQL
INSERT INTO mysql_servers (hostgroup_id, hostname, port) VALUES 
(1, 'shard1-master', 3306),
(2, 'shard2-master', 3306),
(3, 'shard3-master', 3306),
(1, 'shard1-slave', 3306),
(2, 'shard2-slave', 3306),
(3, 'shard3-slave', 3306);

-- Правила маршрутизации в ProxySQL
INSERT INTO mysql_query_rules (rule_id, active, match_digest, destination_hostgroup) VALUES
(1, 1, '^SELECT.*FROM users.*WHERE user_id', 1),
(2, 1, '^SELECT.*FROM users.*WHERE user_id', 2),
(3, 1, '^SELECT.*FROM users.*WHERE user_id', 3);
