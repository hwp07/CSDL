-- Giải pháp 1: ALTER trực tiếp
-- Giải pháp 2: Tạo cột mới

-- | Tiêu chí                | ALTER trực tiếp               | Tạo cột mới           |
-- |-------------------------|-------------------------------|-----------------------|
-- | Độ đơn giản             | Rất dễ                        | Phức tạp hơn          |
-- | Downtime                | Có thể lock bảng lâu          | Giảm downtime         |
-- | An toàn dữ liệu         | Không sửa được số đã mất 0    | Có thể xử lý logic    |


-- Giải pháp lựa chọn => GP2
ALTER TABLE USERS 
ADD COLUMN Phone_new VARCHAR(15);