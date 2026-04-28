-- Active: 1776147792947@@127.0.0.1@3306@shopmanager
CREATE DATABASE ShopManager;
USE ShopManager;
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50)
);
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(50),
    price INT NOT NULL,
    stock INT NOT NULL,
    category_id INT,
    Foreign Key (category_id) REFERENCES Categories (category_id) ON DELETE CASCADE
);
INSERT INTO Categories (category_id, category_name)
VALUES (1, 'Điện tử'),
    (2, 'Thời trang');
INSERT INTO Products (
        product_id,
        product_name,
        price,
        stock,
        category_id
    )
VALUES (1, 'iPhone 15', 25000000, 10, 1),
    (2, 'Samsung S23', 20000000, 5, 1),
    (3, 'Áo sơ mi nam', 500000, 50, 2),
    (4, 'Giày thể thao', 1200000, 20, 2);
UPDATE Products
SET price = 26000000
WHERE product_name = 'iPhone 15';
UPDATE products
SET stock = stock + 10
WHERE category_id = 1;
DELETE FROM Products
WHERE product_id = 4;
DELETE FROM Products
WHERE price < 1000000;
SELECT *
FROM Products;
SELECT *
FROM Products
WHERE stock > 15;