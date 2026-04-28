-- Active: 1776147792947@@127.0.0.1@3306@csdl

--không có ORDER BY Database sẽ trả về 5 dòng bất kỳ (thường theo thứ tự vật lý / index), nên mỗi lần refresh có thể khác nhau => đúng “hiện trường giả” bạn mô tả
-- code hoàn chỉnh:
SELECT restaurant_name, created_at
FROM Restaurants
ORDER BY created_at DESC
LIMIT 5;