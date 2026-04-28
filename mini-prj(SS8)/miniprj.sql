-- Active: 1776147792947@@127.0.0.1@3306@bookstoredb
CREATE DATABASE BookStoreDB;

USE BookStoreDB;

CREATE TABLE Category (
    category_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

INSERT INTO
    category (category_name, description)
VALUES ('IT & Tech', 'Sách lập trình'),
    ('Business', 'Sách kinh doanh'),
    ('Novel', 'Tiểu thuyết');

CREATE TABLE Book (
    book_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    title VARCHAR(150) NOT NULL,
    status INT DEFAULT 1,
    publish_date DATE,
    price DECIMAL(10, 2),
    category_id INT,
    Foreign Key (category_id) REFERENCES Category (category_id)
);

INSERT INTO
    book (
        title,
        status,
        publish_date,
        price,
        category_id,
        author_name
    )
VALUES (
        'Clean Code',
        1,
        '2020-05-10',
        500000,
        1,
        'Robert C. Martin'
    ),
    (
        'Đắc Nhân Tâm',
        0,
        '2018-08-20',
        150000,
        2,
        'Dale Carnegie'
    ),
    (
        'JavaScript Nâng cao',
        1,
        '2023-01-15',
        350000,
        1,
        'Kyle Simpson'
    ),
    (
        'Nhà Giả Kim',
        0,
        '2015-11-25',
        120000,
        3,
        'Paulo Coelho'
    );

CREATE TABLE BookOrder (
    order_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    book_id INT,
    FOREIGN KEY (book_id) REFERENCES Book (book_id) ON DELETE CASCADE,
    order_date DATE DEFAULT(CURRENT_DATE),
    delivery_date DATE
);

INSERT INTO
    BookOrder (
        customer_name,
        book_id,
        order_date,
        delivery_date
    )
VALUES (
        'Nguyen Hai Nam',
        1,
        '2025-01-10',
        '2025-01-15'
    ),
    (
        'Tran Bao Ngoc',
        3,
        '2025-02-05',
        '2025-02-10'
    ),
    (
        'Le Hoang Yen',
        4,
        '2025-03-12',
        NULL
    );

ALTER TABLE book ADD COLUMN author_name VARCHAR(100) NOT NULL;

ALTER TABLE BookOrder
MODIFY COLUMN customer_name VARCHAR(200) NOT NULL;

ALTER TABLE BookOrder
ADD constraint delivery_date check (delivery_date >= order_date);

SELECT * FROM Category;

SELECT * FROM Book;

SELECT * FROM BookOrder;

UPDATE book SET price = 50000 WHERE category_id = 1;

UPDATE BookOrder
SET
    delivery_date = '2025-12-31'
WHERE
    delivery_date IS NULL;

DELETE FROM BookOrder WHERE order_date < '2025-02-01';

SELECT
    title,
    author_name,
    CASE
        WHEN status = 1 THEN 'Còn hàng'
        WHEN status = 0 THEN 'Hết hàng'
    END AS status_name
FROM Book;

SELECT
    UPPER(title) AS title_upper,
    DATEDIFF(
        YEAR,
        publish_date,
        GETDATE ()
    ) AS years_since_publish
FROM Book;

SELECT b.title, b.price, c.category_name
FROM Book b
    INNER JOIN Category c ON b.category_id = c.category_id;

SELECT *
FROM Book
WHERE
    price IS NOT NULL
ORDER BY price DESC
LIMIT 2;