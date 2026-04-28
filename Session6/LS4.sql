-- Hướng tu duy 1: lọc trễ (bad practice)
-- Khi dữ liệu lớn (hàng triệu dòng):
-- CPU tốn hơn => phải tính CASE, COUNT, AVG trên toàn bộ dataset
-- RAM tốn hơn => phải giữ nhiều nhóm + dữ liệu trung gian
-- I/O nặng hơn => đọc cả dữ liệu không cần thiết (FAILED, CANCELLED)

-- Hướng tu duy 2: clean code
-- Giảm số dòng trước khi GROUP BY
-- Ít nhóm hơn → nhẹ RAM
-- Ít phép tính hơn → nhẹ CPU

-- Câu lệnh hoàn chỉnh:
SELECT hotelId
FROM bookings
WHERE
    status = 'COMPLETED'
GROUP BY
    hotelId
HAVING
    COUNT(*) >= 50
    AND AVG(total_price) > 3000000;