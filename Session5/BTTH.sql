-- Active: 1776147792947@@127.0.0.1@3306@csdl
CREATE DATABASE shop;

USE shop;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    total_amount INT,
    note TEXT,
    user_id INT,
    status varchar(10)
);

INSERT INTO orders (order_id, total_amount, note, user_id, status) VALUES
(1, 2500000, 'giao gấp', 101, 'DONE'),
(2, 4200000, 'đơn gấp cần xử lý', 102, 'PENDING'),
(3, 3000000, 'khách bình thường', NULL, 'DONE'),
(4, 4800000, 'ship gấp', 103, 'DONE'),
(5, 2100000, 'đơn ảo test', NULL, 'PENDING'),
(6, 3500000, 'giao gấp', 104, 'CANCELLED'),
(7, 4500000, 'gấp xử lý', NULL, 'CANCELLED'),
(8, 7000000, 'giao gấp', 105, 'DONE'),
(9, 3000000, 'giao thường', 106, 'DONE'),
(10, 1500000, 'đơn ảo', NULL, 'DONE'),
(11, 2200000, 'gấp', 107, 'DONE'),
(12, 3900000, 'đơn test', NULL, 'DONE'),
(13, 4100000, 'gấp giao nhanh', 108, 'PENDING'),
(14, 5000000, 'gấp cuối', 109, 'DONE'),
(15, 2000000, 'đơn ảo', NULL, 'DONE'),
(16, 10000000, 'gấp cực mạnh', 110, 'DONE'),
(17, 2600000, 'gấp nhẹ', 111, 'DONE'),
(18, 2800000, 'test', NULL, 'PENDING'),
(19, 4300000, 'cần gấp', 112, 'DONE'),
(20, 4700000, 'urgent gấp', 113, 'DONE'),
(21, 3000000, 'gấp', 114, 'CANCELLED'),
(22, 4000000, 'test', NULL, 'CANCELLED');

-- Bản vẽ Logic: trong SQL thứ tư ưu tiên của AND > OR => khi code không sử dụng () dẫn đến sự hiểu nhẩm của hệ thống => cần phải sử dụng dấu () đúng cách, đúng chỗ để đúng với yêu cầu bài toán
WHERE total_amount BETWEEN 2000000 AND 5000000
    AND status != 'CANCELLED'
    AND (
        note LIKE '%gấp%'
        OR user_id IS NULL
    );

-- Phân trang:
-- Công thức OFFSET: OFFSET = (page−1) × page_size
-- Nếu Client truyền tham số page = 0 or page < 0 => sử dụng câu lệnh sau:
if (page <= 0) { page = 1};
if (page > maxPage) { page = maxPage};

-- Siêu câu lệnh SQL:
SELECT order_id, total_amount,note, user_id,
    CASE
        WHEN total_amount > 4000000 THEN 'Nguy hiểm'
        ELSE 'Bình thường'
    END AS Alert_Level
FROM orders
WHERE total_amount BETWEEN 2000000 AND 5000000
    AND status <> 'CANCELLED'
    AND (
        note LIKE '%gấp%'
        OR user_id IS NULL
    )
ORDER BY total_amount DESC
LIMIT 20 OFFSET 40;
