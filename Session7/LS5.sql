-- Scalar Subquery trong SELECT trả về 1 giá trị duy nhất (ở đây là AVG(price) của toàn bộ bảng)
-- Giá trị này được gắn vào từng dòng của kết quả
-- Nhờ vậy:
--      Vẫn giữ được từng khóa học (không bị GROUP BY gom lại)
--      Đồng thời có thể so sánh với giá trung bình toàn hệ thống

SELECT
    title,
    price,
    price - (
        SELECT AVG(price)
        FROM course
    ) AS Price_Difference
FROM course;