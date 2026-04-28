-- Trong SQL khi so sánh bất kỳ với NULL giá trị trả về đều là UNKNOWN, NOT IN cũng thế. Vì mệnh đề WHERE chỉ lấy giá trị TRUE, do đó ở bài toán trên mệnh đề WHERE chỉ lấy những dòng có kết quả là TRUE, nên khi gặp NULL, câu lệnh NOT IN sẽ loại bỏ sạch tất cả các dòng dữ liệu, dẫn đến tập hợp rỗng.

SELECT c.*
FROM Courses c
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Enrollments e
        WHERE
            e.course_id = c.id
    );