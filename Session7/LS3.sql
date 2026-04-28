-- EXISTS: Chỉ quan tâm đến việc "có hay không". Khi quét vào bảng Payments, ngay khi tìm thấy dòng đầu tiên thỏa mãn điều kiện (học viên có mua hàng), nó sẽ lập tức dừng lại và trả về TRUE. Nó không cần quan tâm học viên đó đã mua thêm 10 hay 100 lần nữa.

-- NOT IN: Thường phải quét và thu thập toàn bộ danh sách ID từ subquery vào bộ nhớ (RAM), sau đó mới bắt đầu so sánh. Với 5 triệu học viên, danh sách này có thể cực kỳ đồ sộ, gây tốn RAM và chậm trễ.

SELECT s.email
FROM Students s
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Payments p
        WHERE
            p.student_id = s.id
            AND p.payment_date >= '2024-01-01'
            AND p.payment_date <= '2024-12-31'
    );