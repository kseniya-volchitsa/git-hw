-- Останавливаем Slave
STOP SLAVE;

-- Настраиваем подключение к Master
CHANGE MASTER TO
    MASTER_HOST = 'mysql-master',
    MASTER_PORT = 3306,
    MASTER_USER = 'replication',
    MASTER_PASSWORD = 'replication_password',
    MASTER_LOG_FILE = 'mysql-bin.000001',
    MASTER_LOG_POS = 156;

-- Запускаем Slave
START SLAVE;

-- Проверяем статус
SHOW SLAVE STATUS\G
