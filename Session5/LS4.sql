-- Giải pháp  1:
SELECT *
FROM don_hang
WHERE
    nguyen_nhan = 'KHACH_HUY'
    OR nguyen_nhan = 'QUAN_DONG_CUA'
    OR nguyen_nhan = 'KHONG_CO_TAI_XE'
    OR nguyen_nhan = 'BOM_HANG';

-- GIải pháp 2 (Ưu tiên):
SELECT *
FROM don_hang
WHERE
    nguyen_nhan IN (
        'KHACH_HUY',
        'QUAN_DONG_CUA',
        'KHONG_CO_TAI_XE',
        'BOM_HANG'
    );

-- So sánh:
-- | Tiêu chí             | Dùng OR                          | Dùng IN                                          |
-- | Code sạch            | Dài, khó đọc khi nhiều điều kiện | Ngắn gọn, rõ ràng                                |
-- | Khả năng mở rộng     | Thêm 20 lý do = viết 20 dòng OR  | Chỉ thêm vào list                                |
-- | Hiệu năng SQL Engine | Có thể kém hơn khi nhiều OR      | Tối ưu tốt hơn (thường convert thành lookup set) |

-- Logic chặn Syntax ở backend:
-- if (!nguyen_nhan || nguyen_nhan.length === 0) {
--     return [];
-- };