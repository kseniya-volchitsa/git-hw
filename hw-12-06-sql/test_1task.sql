-- На Master
CREATE TABLE sakila.test_replication (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO sakila.test_replication (name) VALUES ('Test 1'), ('Test 2');

-- На Slave (проверка)
USE sakila;
SELECT * FROM test_replication;
