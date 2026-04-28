-- Active: 1776147792947@@127.0.0.1@3306@sales_management_system
USE sales_management_system;

CREATE TABLE Customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    gender ENUM('M', 'F') NOT NULL,
    date_of_birth DATE NOT NULL
);

INSERT INTO
    Customer (
        full_name,
        email,
        gender,
        date_of_birth
    )
VALUES (
        'Nguyen Van A',
        'a@gmail.com',
        'M',
        '2000-05-10'
    ),
    (
        'Tran Thi B',
        'b@gmail.com',
        'F',
        '1998-03-15'
    ),
    (
        'Le Van C',
        'c@gmail.com',
        'M',
        '2002-07-20'
    ),
    (
        'Pham Thi D',
        'd@gmail.com',
        'F',
        '1995-12-01'
    ),
    (
        'Hoang Van E',
        'e@gmail.com',
        'M',
        '1999-09-09'
    );

CREATE TABLE Category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO
    Category (category_name)
VALUES ('Điện tử'),
    ('Thời trang'),
    ('Gia dụng'),
    ('Sách'),
    ('Thực phẩm');

CREATE TABLE Product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Category (category_id)
);

INSERT INTO
    Product (
        product_name,
        price,
        category_id
    )
VALUES ('iPhone 14', 20000000, 1),
    ('Laptop Dell', 15000000, 1),
    ('Áo thun', 200000, 2),
    ('Quần jeans', 500000, 2),
    ('Nồi cơm điện', 800000, 3);

CREATE TABLE `Order` (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer (customer_id)
);

INSERT INTO `Order` (customer_id) VALUES (1), (2), (1), (3), (4);

CREATE TABLE Order_Detail (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES `Order` (order_id),
    FOREIGN KEY (product_id) REFERENCES Product (product_id)
);

INSERT INTO
    Order_Detail (
        order_id,
        product_id,
        quantity,
        price
    )
VALUES (1, 1, 1, 20000000),
    (1, 3, 2, 200000),
    (2, 2, 1, 15000000),
    (3, 4, 1, 500000),
    (4, 5, 2, 800000);

-- cập nhật sản phẩm
UPDATE Product SET price = 21000000 WHERE product_name = 'iPhone 14';

-- cập nhật email
UPDATE Customer
SET
    email = 'newemail@gmail.com'
WHERE
    customer_id = 1;

-- xóa đơn không gợp lệ
DELETE FROM Order_Detail WHERE quantity = 0;

-- xóa đơn bị hủy
DELETE FROM `Order` WHERE status = 'CANCELLED';

-- danh sách khách hàng
SELECT
    full_name AS Ten_Khach_Hang,
    email AS Email,
    CASE
        WHEN gender = 'M' THEN 'Nam'
        WHEN gender = 'F' THEN 'Nữ'
    END AS Gioi_Tinh
FROM Customer;

-- khách hàng trẻ tuổi nhất
SELECT full_name, YEAR(NOW()) - YEAR(date_of_birth) AS age
FROM Customer
ORDER BY age ASC
LIMIT 3;

-- danh sách đơn hàng
SELECT o.order_id, c.full_name, o.order_date
FROM `Order` o
    INNER JOIN Customer c ON o.customer_id = c.customer_id;

-- số sản phẩm theo danh mục
SELECT c.category_name, COUNT(p.product_id) AS total_products
FROM Category c
    JOIN Product p ON c.category_id = p.category_id
GROUP BY
    c.category_name
HAVING
    COUNT(p.product_id) >= 2;

-- sản phẩm có giá > TB
SELECT product_name, price
FROM Product
WHERE
    price > (
        SELECT AVG(price)
        FROM Product
    );

-- khách hàng chưa từng đặtt hàng
SELECT full_name
FROM Customer
WHERE
    customer_id NOT IN(
        SELECT customer_id
        FROM `Order`
    );

-- danh mục có doanh thu > 120%
SELECT c.category_name, SUM(od.quantity * od.price) AS revenue
FROM
    Category c
    JOIN Product p ON c.category_id = p.category_id
    JOIN Order_Detail od ON p.product_id = od.product_id
GROUP BY
    c.category_id
HAVING
    revenue > (
        SELECT AVG(total_revenue) * 1.2
        FROM (
                SELECT SUM(od2.quantity * od2.price) AS total_revenue
                FROM
                    Category c2
                    JOIN Product p2 ON c2.category_id = p2.category_id
                    JOIN Order_Detail od2 ON p2.product_id = od2.product_id
                GROUP BY
                    c2.category_id
            ) AS temp
    );

-- sán phẩm đắt nhất từng danh mục
SELECT p.product_name, p.price, p.category_id
FROM Product p
WHERE
    p.price = (
        SELECT MAX(price)
        FROM Product
        WHERE
            category_id = p.category_id
    );

-- khách VIP
SELECT full_name
FROM Customer
WHERE
    customer_id IN (
        SELECT customer_id
        FROM `Order`
        WHERE
            order_id IN (
                SELECT order_id
                FROM Order_Detail
                WHERE
                    product_id IN (
                        SELECT product_id
                        FROM Product
                        WHERE
                            category_id = (
                                SELECT category_id
                                FROM Category
                                WHERE
                                    category_name = 'Điện tử'
                            )
                    )
            )
    );