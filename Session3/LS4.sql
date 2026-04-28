-- Giải pháp 1: Hard Delete (Xóa thật)
DELETE FROM ORDERS WHERE Status = 'Canceled';

-- Giải pháp 2: Soft Delete (Xóa mềm)
UPDATE ORDERS SET IsDeleted = 1 WHERE Status = 'Canceled';

-- So sánh
-- | Tiêu chí                   | Hard Delete             | Soft Delete                       |
-- | Giải phóng dung lượng      |  Rất tốt                |  Không giảm                       |
-- | Tốc độ truy vấn            |  Nhanh hơn (ít dữ liệu) |  Chậm hơn nếu không tối ưu index  |
-- | Khả năng khôi phục dữ liệu |  Không thể              |  Có thể                           |
-- | Phù hợp kiểm toán kế toán  |  Rủi ro cao             |  Rất phù hợp                      |
-- | Độ phức tạp code           |  Đơn giản               |  Phải lọc `IsDeleted` mọi nơi     |

-- Phương pháp lựa chọn: Soft Delete
UPDATE ORDERS SET IsDeleted = 1 WHERE Status = 'Canceled';

SELECT * FROM ORDERS WHERE IsDeleted = 0;