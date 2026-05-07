--Tham số đầu vào:
-- p_patient_id INT
-- p_phone VARCHAR(15)

--Tham số đầu ra
-- p_total_due DECIMAL(18,2)
-- p_message VARCHAR(100)

-- Giải pháp:
-- Giải pháp 1 — Dùng IF...ELSE để rẽ nhánh xử lý
-- Ý tưởng
    -- Nếu có patient_id => tìm theo ID.
    -- Nếu không có ID nhưng có Phone => tìm theo Phone.
    -- Nếu cả 2 NULL => báo lỗi.
    -- Nếu không tìm thấy => trả về nợ = 0.
    IF patient_id IS NOT NULL THEN
        -- tìm theo ID
    ELSEIF phone IS NOT NULL THEN
        -- tìm theo Phone
    ELSE
        -- báo lỗi
    END IF;

-- Giải pháp 2 — Dùng truy vấn linh hoạt với OR
-- Ý tưởng
    -- Chỉ dùng một câu SELECT:
    -- WHERE patient_id = p_patient_id
    --    OR phone = p_phone
    -- Kết hợp kiểm tra NULL trước khi truy vấn.

SELECT ...
FROM Patients p
JOIN Patient_Invoices pi
ON ...
WHERE
    (p_patient_id IS NOT NULL AND p.patient_id = p_patient_id)
    OR
    (p_phone IS NOT NULL AND p.phone = p_phone);


-- So sánh
-- | Tiêu chí         | Giải pháp 1 (IF...ELSE) | Giải pháp 2 (OR linh hoạt) |
-- | ---------------- | ----------------------- | -------------------------- |
-- | Dễ đọc           | Rất dễ                  | Trung bình                 |
-- | Dễ bảo trì       | Tốt                     | Khó hơn                    |
-- | Hiệu năng        | Tốt hơn                 | Có thể chậm nếu OR lớn     |
-- | Kiểm soát logic  | Rõ ràng                 | Phức tạp hơn               |
-- | Phù hợp bài toán | Rất phù hợp             | Phù hợp                    |

-- Giải pháp lựa chọn: PP1
-- Bước 1
-- Kiểm tra:
-- Nếu p_patient_id và p_phone đều NULL
-- → dừng ngay và báo lỗi.

-- Bước 2
-- Nếu có patient_id
-- → tìm công nợ theo ID.

-- Bước 3
-- Nếu không có ID nhưng có Phone
-- → JOIN Patients và Patient_Invoices để tìm theo số điện thoại.

-- Bước 4
-- Nếu không tìm thấy dữ liệu
-- → trả về:
-- 0
-- "Không tìm thấy bệnh nhân"

-- Bước 5
-- Nếu tìm thấy
-- → trả về:
-- Tổng nợ
-- "Tra cứu thành công"


USE RikkeiClinicDB;
DELIMITER //
CREATE PROCEDURE GetPatientDebt(
    IN p_patient_id INT,
    IN p_phone VARCHAR(15),
    OUT p_total_due DECIMAL(18,2),
    OUT p_message VARCHAR(100)
)
BEGIN
    -- Trường hợp bỏ trống cả 2
    IF p_patient_id IS NULL AND p_phone IS NULL THEN
        SET p_total_due = 0;
        SET p_message = 'Loi: Phai nhap ID hoac So dien thoai';

    -- Tìm theo Patient ID
    ELSEIF p_patient_id IS NOT NULL THEN
        SELECT total_due
        INTO p_total_due
        FROM Patient_Invoices
        WHERE patient_id = p_patient_id;

        IF p_total_due IS NULL THEN
            SET p_total_due = 0;
            SET p_message = 'Khong tim thay benh nhan';
        ELSE
            SET p_message = 'Tra cuu thanh cong';
        END IF;

    -- Tìm theo Phone
    ELSE
        SELECT pi.total_due
        INTO p_total_due
        FROM Patients p
        JOIN Patient_Invoices pi
            ON p.patient_id = pi.patient_id
        WHERE p.phone = p_phone;

        IF p_total_due IS NULL THEN
            SET p_total_due = 0;
            SET p_message = 'Khong tim thay benh nhan';
        ELSE
            SET p_message = 'Tra cuu thanh cong';
        END IF;
    END IF;
END //
DELIMITER ;

CALL GetPatientDebt(
    1,
    NULL,
    @total_due,
    @message
);
SELECT @total_due, @message;


CALL GetPatientDebt(
    NULL,
    '0912222333',
    @total_due,
    @message
);
SELECT @total_due, @message;


CALL GetPatientDebt(
    NULL,
    NULL,
    @total_due,
    @message
);
SELECT @total_due, @message;


CALL GetPatientDebt(
    999,
    NULL,
    @total_due,
    @message
);
SELECT @total_due, @message;