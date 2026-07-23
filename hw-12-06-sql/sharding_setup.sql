-- Таблицы для каждого шарда
CREATE TABLE IF NOT EXISTS users_shard_1 (
    user_id INT PRIMARY KEY,
    username VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users_shard_2 (
    user_id INT PRIMARY KEY,
    username VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users_shard_3 (
    user_id INT PRIMARY KEY,
    username VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Функция для определения шарда
DELIMITER //
CREATE FUNCTION get_shard_id(p_user_id INT) 
RETURNS INT DETERMINISTIC
BEGIN
    RETURN (p_user_id % 3) + 1;
END //
DELIMITER ;

-- Маршрутизация в ProxySQL
-- INSERT INTO mysql_servers (hostgroup_id, hostname, port) VALUES (1, 'shard1-master', 3306);
-- INSERT INTO mysql_servers (hostgroup_id, hostname, port) VALUES (2, 'shard2-master', 3306);
-- INSERT INTO mysql_servers (hostgroup_id, hostname, port) VALUES (3, 'shard3-master', 3306);
