SELECT user_id, COUNT(*) AS total_orders, SUM(status = 'CANCELLED')
FROM Bookings
GROUP BY
    user_id
HAVING
    COUNT(*) >= 10
    AND SUM(status = 'CANCELLED') > 5;

-- ý tưởng:
-- 1. gom các user thành 1 nhóm
-- 2. đếm tổng số lần đặt phòng
-- 3. đếm số đơn hủy: SUM(status = 'CANCELLED') sẽ biến điều kiện thành số, nếu status = 'CANCELLED' => trả về 1 ngược lại trả về 0 => tổng số đơn hủy