## Домашнее задание к занятию «Кеширование Redis/memcached»

**Студент:** Волчица Ксения

---

### Задание 1. Кеширование

**Примеры проблем, которые решает кеширование:**

1. **Медленные ответы от базы данных** — кеш хранит часто запрашиваемые данные в оперативной памяти, сокращая время ответа с сотен миллисекунд до миллисекунд.
2. **Высокая нагрузка на основную БД** — кеширование снижает количество прямых запросов к базе, уменьшая нагрузку на CPU и дисковую подсистему.
3. **Повторяющиеся вычисления** — результаты сложных расчётов (агрегации, отчёты) сохраняются в кеше и переиспользуются.
4. **Сессии пользователей** — кеш (особенно Redis) удобно использовать для хранения сессий в распределённых системах.
5. **API-лимиты** — кеш позволяет отслеживать количество запросов от пользователя без постоянного обращения к БД.
6. **Горячие данные** — например, список популярных товаров в интернет-магазине, который обновляется редко, но читается очень часто.

---

### Задание 2. Memcached

**Установка и запуск Memcached:**

```bash
sudo apt update
sudo apt install memcached -y
sudo systemctl start memcached
sudo systemctl enable memcached
```

**Скриншот `systemctl status memcached`:**

![Memcached status](img/memcached-status.png)

---

### Задание 3. Удаление по TTL в Memcached

**Запись ключей с TTL 5 секунд:**

```bash
# Подключение к memcached
telnet localhost 11211

# Запись ключей с TTL 5 секунд
set key1 0 5 4
data
set key2 0 5 6
value2
set key3 0 5 4
test

# Через 5 секунд проверка
get key1
get key2
get key3
```

**Скриншот, где видно, что ключи удалились:**

![Memcached TTL](img/memcached-ttl.png)

---

### Задание 4. Запись данных в Redis

**Установка и запуск Redis:**

```bash
sudo apt install redis-server -y
sudo systemctl start redis-server
sudo systemctl enable redis-server
```

**Запись ключей и получение всех данных:**

```bash
redis-cli
SET user:1 "Alice"
SET user:2 "Bob"
SET session:123 "active"
KEYS *
```

**Скриншот операции:**

![Redis keys](img/redis-keys.png)

---

### Задание 5*. Работа с числами

**Операции с числовым ключом:**

```bash
redis-cli
SET key5 5
INCR key5 5
GET key5
```

**Скриншот:**

![Redis numeric](img/redis-numeric.png)

---

**Ссылка на решение:**  
[https://github.com/kseniya-volchitsa/git-hw/tree/main/hw-08-cache](https://github.com/kseniya-volchitsa/git-hw/tree/main/hw-08-cache)
