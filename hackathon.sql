-- Active: 1776147792947@@127.0.0.1@3306@practice
CREATE DATABASE practice;

USE practice;

CREATE Table Users (
    user_id VARCHAR(5) PRIMARY KEY,
    user_name VARCHAR(100),
    user_email VARCHAR(100) UNIQUE,
    user_phone VARCHAR(15) UNIQUE
);

CREATE Table Products (
    product_id VARCHAR(5) PRIMARY KEY,
    product_name VARCHAR(150),
    product_price DECIMAL(10, 2),
    stock_quantity INT
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(5),
    Foreign Key (user_id) REFERENCES Users (user_id),
    order_date DATE,
    total_price DECIMAL(10, 2),
    order_status VARCHAR(20)
);

CREATE Table Order_Details (
    order_detail_id INT AUTO_INCREMENT,
    order_id INT,
    product_id VARCHAR(5),
    quantity INT,
    unit_price DECIMAL(10, 2),
    PRIMARY KEY (order_detail_id, order_id),
    Foreign Key (order_id) REFERENCES Orders (order_id) ON DELETE CASCADE,
    Foreign Key (product_id) REFERENCES Products (product_id)
);

INSERT INTO
    Users (
        user_id,
        user_name,
        user_email,
        user_phone
    )
VALUES (
        'U001',
        'Nguyễn Văn An',
        'an.nguyen@gmail.com',
        '0912345678'
    ),
    (
        'U002',
        'Trần Thị Bích',
        'bich.tran@gmail.com',
        '0923456789'
    ),
    (
        'U003',
        'Lê Hoàng Minh',
        'minh.le@gmail.com',
        '0934567890'
    ),
    (
        'U004',
        'Phạm Thu Hà',
        'ha.pham@gmail.com',
        '0945678901'
    ),
    (
        'U005',
        'Võ Quốc Huy',
        'huy.vo@gmail.com',
        '0956789012'
    );

INSERT INTO
    Products (
        product_id,
        product_name,
        product_price,
        stock_quantity
    )
VALUES (
        'P001',
        'Áo thun nam',
        199000,
        50
    ),
    (
        'P002',
        'Quần jean nữ',
        399000,
        40
    ),
    (
        'P003',
        'Giày sneaker',
        899000,
        30
    ),
    (
        'P004',
        'Áo thun nam',
        199000,
        20
    ),
    (
        'P005',
        'Áo thun nam',
        199000,
        15
    );

INSERT INTO
    Orders (
        order_id,
        user_id,
        order_date,
        total_price,
        order_status
    )
VALUES (
        1,
        'U001',
        '2025-03-01',
        398000,
        'Completed'
    ),
    (
        2,
        'U002',
        '2025-03-02',
        899000,
        'Completed'
    ),
    (
        3,
        'U003',
        '2025-03-03',
        399000,
        'Processing'
    ),
    (
        4,
        'U001',
        '2025-03-04',
        2598000,
        'Cancelled'
    ),
    (
        5,
        'U004',
        '2025-03-05',
        1797000,
        'Pending'
    );

INSERT INTO
    Order_Details (
        order_detail_id,
        order_id,
        product_id,
        quantity,
        unit_price
    )
VALUES (1, 1, 'P001', 2, 199000),
    (2, 2, 'P003', 1, 899000),
    (3, 3, 'P002', 1, 399000),
    (4, 4, 'P005', 2, 1299000),
    (5, 5, 'P004', 3, 599000);

SELECT * FROM users;

SELECT * FROM products;

SELECT * FROM orders;

SELECT * FROM order_details;

UPDATE users set user_phone = '096532628' WHERE user_id = 'U003';

UPDATE Orders SET order_status = 'Cancelled' WHERE order_id = 3;

DELETE FROM Orders
WHERE
    order_status = 'Cancelled'
    AND order_date < '2025-03-04';

--2.6
SELECT
    order_id,
    order_date,
    order_status
FROM Orders
WHERE
    order_status = 'completed';

--2.7
SELECT
    user_name,
    user_phone,
    user_email
FROM users
WHERE
    user_phone LIKE '09%%';

--2.8
SELECT order_id, user_id, order_date
FROM Orders
ORDER BY order_date DESC;

--2.9
SELECT * FROM Orders WHERE order_status = 'completed' LIMIT 3;

--2.10
SELECT user_id, user_name FROM Users LIMIT 3 OFFSET 2;

--3.11
SELECT o.order_id, u.user_name, o.order_date, o.total_price
FROM users u
    JOIN orders o ON o.user_id = u.user_id
WHERE
    order_status = 'completed';

--3.12
SELECT p.product_id, p.product_name, od.order_id
FROM products p
    LEFT JOIN order_details od ON p.product_id = od.product_id;

--3.13
SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY
    order_status;

--3.14
SELECT user_id, COUNT(*) AS Count_Order
FROM orders
GROUP BY
    user_id
HAVING
    COUNT(*) >= 2;

--3.15
SELECT order_id, order_date, total_price
FROM Orders
WHERE
    total_price > (
        SELECT AVG(total_price)
        FROM Orders
    );

--3.16
SELECT DISTINCT u.user_name, u.user_phone
FROM Users u
    JOIN Orders o ON u.user_id = o.user_id
    JOIN Order_Details od ON o.order_id = od.order_id
    JOIN Products p ON od.product_id = p.product_id
WHERE
    p.product_name = 'Giày sneaker';

--3.17
SELECT o.order_id, u.user_name, p.product_name, od.quantity, od.unit_price
FROM Orders o
    JOIN Users u ON o.user_id = u.user_id
    JOIN Order_Details od ON o.order_id = od.order_id
    JOIN Products p ON od.product_id = p.product_id;
