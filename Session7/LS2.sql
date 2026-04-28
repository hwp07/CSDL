-- Derived Table: là một bảng ảo được tạo ra từ kết quả của một câu lệnh SELECT nằm bên trong mệnh đề FROM của một câu truy vấn khác
-- SQL coi subquery trong FROM là một bảng mới. Nếu không đặt tên (Alias), SQL sẽ không biết gọi bảng đó là gì để trích xuất dữ liệu, dẫn đến lỗi "vô danh".

SELECT SUM(total_spent)
FROM (
        SELECT student_id, SUM(amount) AS total_spent
        FROM Payments
        GROUP BY
            student_id
        HAVING
            SUM(amount) > 10000000
    ) AS Result;
-- cần thêm alias ở đây