-- Active: 1776147792947@@127.0.0.1@3306@csdl
CREATE DATABASE CSDL;
USE CSDL;
CREATE TABLE products (
    id VARCHAR(5) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    size VARCHAR(5),
    price INT NOT NULL CHECK(price > 0)
);
INSERT INTO products(id, name, size, price)
VALUES ('P01', 'Áo sơ mi trắng', 'L', 250000),
    ('P02', 'Quần Jeans xanh', 'M', 450000),
    ('P03', 'Áo thun Basic', 'XL', 150000),
    ('P04', 'Áo hoodie', NULL, 200000);
-- Giảm giá sản phẩm P02
UPDATE products
SET price = 400000
WHERE id = 'P02';
-- Tăng tất cả sản phẩm 10%
UPDATE products
SET price = price * 1.1;
-- Xóa san phẩm P03
DELETE FROM products
WHERE id = 'P03';
-- Xem toàn bộ sản phẩm
SELECT name,
    size
FROM products;
-- Tìm sản phẩm giá > 300000
SELECT *
FROM products
WHERE price > 300000;