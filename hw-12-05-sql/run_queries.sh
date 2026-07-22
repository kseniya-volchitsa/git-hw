#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================="
echo "=== Домашнее задание: SQL Оптимизация ==="
echo -e "==========================================${NC}"

# Проверка наличия Docker и MySQL контейнера
if ! docker ps | grep -q mysql-hw; then
    echo -e "${RED}Ошибка: Контейнер mysql-hw не запущен!${NC}"
    echo "Запустите контейнер: docker start mysql-hw"
    exit 1
fi

echo -e "${GREEN}Контейнер mysql-hw найден. Выполняем запросы...${NC}\n"

# Задание 1
echo -e "${YELLOW}=========================================="
echo "=== Задание 1: Процент индексов ==="
echo -e "==========================================${NC}"
docker exec -i mysql-hw mysql -u root -proot_password -D sakila < queries/01_index_percentage.sql

# Задание 2 - Исходный EXPLAIN ANALYZE
echo -e "\n${YELLOW}=========================================="
echo "=== Задание 2: EXPLAIN ANALYZE исходного запроса ==="
echo -e "==========================================${NC}"
docker exec -i mysql-hw mysql -u root -proot_password -D sakila < queries/02_explain_analyze.sql

# Задание 2 - Создание индексов
echo -e "\n${YELLOW}=========================================="
echo "=== Задание 2: Создание индексов ==="
echo -e "==========================================${NC}"
docker exec -i mysql-hw mysql -u root -proot_password -D sakila < queries/04_create_indexes.sql

# Задание 2 - Оптимизированный запрос
echo -e "\n${YELLOW}=========================================="
echo "=== Задание 2: EXPLAIN ANALYZE оптимизированного запроса ==="
echo -e "==========================================${NC}"
docker exec -i mysql-hw mysql -u root -proot_password -D sakila < queries/03_optimized_query.sql

echo -e "\n${GREEN}=========================================="
echo "=== Все запросы выполнены! ==="
echo -e "==========================================${NC}"
