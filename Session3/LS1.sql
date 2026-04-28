-- Active: 1776147792947@@127.0.0.1@3306@csdl
CREATE TABLE PRODUCTS (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    OriginalPrice DECIMAL(18, 2)
);
INSERT INTO PRODUCTS (ProductID, ProductName, Category, OriginalPrice)
VALUES (1, 'iPhone 15', 'Electronics', 20000000),
    (
        2,
        'Samsung Refrigerator',
        'Electronics',
        15000000
    ),
    (3, 'Water Spinach', 'Food', 10000),
    (4, 'Filtered Fresh Milk 4', 'Food', 28000);
UPDATE PRODUCTS
SET OriginalPrice = OriginalPrice * 0.9
WHERE Category = 'Electronics';
-- ban đầu code không có mệnh đề WhERE nên giá của tất cả các sản phẩm của PRODUCTS đều bị giảm 10%
-- cần thêm mệnh đề WHERE để ràng buộc