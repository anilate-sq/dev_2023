/*
CoffeeShop — учебная база данных для курса
«Технология доступа к базам данных ADO.NET»

СУБД: Microsoft SQL Server
*/

-- Удаление базы данных, если она уже существует

USE master;
GO

IF DB_ID(N'coffee_shop') IS NOT NULL
BEGIN
    ALTER DATABASE coffee_shop SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE coffee_shop;
END;
GO


-- Создание базы данных

CREATE DATABASE coffee_shop;
GO

USE coffee_shop; -- Подключение к определенной базе данных
GO


/*
Создание таблиц:
    CREATE TABLE <имя таблицы>(
        <название поля> <тип данных> <ограничения>,
        <название поля> <тип данных> <ограничения>
    );
*/


-- Создание таблицы categories

CREATE TABLE categories(
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL UNIQUE
);
GO


-- Создание таблицы products

CREATE TABLE products(
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    is_available BIT NOT NULL DEFAULT 1,

    FOREIGN KEY (category_id) REFERENCES categories(id),
    CHECK (price >= 0)
);
GO


-- Создание таблицы customers

CREATE TABLE customers(
    id INT PRIMARY KEY IDENTITY(1,1),
    full_name NVARCHAR(150) NOT NULL,
    phone NVARCHAR(30),
    email NVARCHAR(150)
);
GO


-- Создание таблицы orders

CREATE TABLE orders(
    id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    order_date DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    status NVARCHAR(30) NOT NULL DEFAULT N'Новый',

    FOREIGN KEY (customer_id) REFERENCES customers(id),
    CHECK (status IN (
        N'Новый',
        N'Готовится',
        N'Готов',
        N'Выдан',
        N'Отменён'
    ))
);
GO


-- Создание таблицы order_items

CREATE TABLE order_items(
    id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    CHECK (quantity > 0),
    CHECK (unit_price >= 0)
);
GO


-- Добавление категорий

INSERT INTO categories (name)
VALUES
    (N'Кофе'),
    (N'Чай'),
    (N'Холодные напитки'),
    (N'Десерты'),
    (N'Выпечка'),
    (N'Завтраки');
GO


-- Добавление товаров

INSERT INTO products (name, category_id, price, is_available)
VALUES
    (N'Эспрессо',             1, 120.00, 1),
    (N'Американо',            1, 140.00, 1),
    (N'Капучино',             1, 190.00, 1),
    (N'Латте',                1, 210.00, 1),
    (N'Флэт Уайт',            1, 230.00, 1),
    (N'Матча-латте',          2, 220.00, 1),
    (N'Чёрный чай',           2, 130.00, 1),
    (N'Зелёный чай',          2, 130.00, 1),
    (N'Лимонад',              3, 180.00, 1),
    (N'Айс-латте',            3, 230.00, 1),
    (N'Чизкейк',              4, 260.00, 1),
    (N'Тирамису',             4, 280.00, 1),
    (N'Круассан',             5, 170.00, 1),
    (N'Круассан с шоколадом', 5, 210.00, 1),
    (N'Сырники',              6, 250.00, 1),
    (N'Овсяная каша',         6, 220.00, 1);
GO


-- Добавление клиентов

INSERT INTO customers (full_name, phone, email)
VALUES
    (N'Иван Петров',       N'+7 900 100-10-01', N'ivan@example.com'),
    (N'Анна Смирнова',     N'+7 900 100-10-02', N'anna@example.com'),
    (N'Максим Волков',     N'+7 900 100-10-03', N'maxim@example.com'),
    (N'Елена Морозова',    N'+7 900 100-10-04', N'elena@example.com'),
    (N'Дмитрий Соколов',   N'+7 900 100-10-05', N'dmitry@example.com'),
    (N'Ольга Кузнецова',   N'+7 900 100-10-06', N'olga@example.com'),
    (N'Алексей Попов',     N'+7 900 100-10-07', N'alexey@example.com'),
    (N'Мария Новикова',    N'+7 900 100-10-08', N'maria@example.com');
GO


-- Добавление заказов

INSERT INTO orders (customer_id, order_date, status)
VALUES
    (1, '2026-09-25 09:15:00', N'Выдан'),
    (2, '2026-09-25 10:20:00', N'Выдан'),
    (3, '2026-09-25 12:05:00', N'Выдан'),
    (4, '2026-09-26 08:40:00', N'Выдан'),
    (5, '2026-09-26 11:30:00', N'Готов'),
    (1, '2026-09-27 09:10:00', N'Выдан'),
    (6, '2026-09-27 13:45:00', N'Готовится'),
    (7, '2026-09-28 15:20:00', N'Новый'),
    (8, '2026-09-29 10:05:00', N'Выдан'),
    (2, '2026-09-29 18:10:00', N'Выдан');
GO


-- Добавление позиций заказов

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
    -- Заказ 1
    (1, 3, 1, 190.00),
    (1, 13, 1, 170.00),

    -- Заказ 2
    (2, 4, 1, 210.00),
    (2, 11, 1, 260.00),

    -- Заказ 3
    (3, 2, 2, 140.00),
    (3, 15, 1, 250.00),

    -- Заказ 4
    (4, 1, 1, 120.00),
    (4, 14, 2, 210.00),

    -- Заказ 5
    (5, 5, 1, 230.00),
    (5, 12, 1, 280.00),
    (5, 9, 1, 180.00),

    -- Заказ 6
    (6, 6, 1, 220.00),
    (6, 13, 2, 170.00),

    -- Заказ 7
    (7, 10, 1, 230.00),
    (7, 11, 1, 260.00),

    -- Заказ 8
    (8, 3, 1, 190.00),
    (8, 16, 1, 220.00),

    -- Заказ 9
    (9, 4, 2, 210.00),
    (9, 12, 1, 280.00),

    -- Заказ 10
    (10, 2, 1, 140.00),
    (10, 5, 1, 230.00),
    (10, 14, 1, 210.00);
GO


-- Проверка количества записей в таблицах

SELECT N'categories' AS table_name, COUNT(*) AS row_count FROM categories
UNION ALL
SELECT N'products', COUNT(*) FROM products
UNION ALL
SELECT N'customers', COUNT(*) FROM customers
UNION ALL
SELECT N'orders', COUNT(*) FROM orders
UNION ALL
SELECT N'order_items', COUNT(*) FROM order_items;
GO


-- Проверка связей между заказами, клиентами и товарами

SELECT
    orders.id AS order_id,
    customers.full_name AS customer,
    orders.order_date,
    orders.status,
    SUM(order_items.quantity * order_items.unit_price) AS total_amount
FROM orders
LEFT JOIN customers
    ON customers.id = orders.customer_id
JOIN order_items
    ON order_items.order_id = orders.id
GROUP BY
    orders.id,
    customers.full_name,
    orders.order_date,
    orders.status
ORDER BY orders.id;
GO
