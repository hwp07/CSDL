-- Dữ liệu đầu vào
-- p_total_cost : Tổng chi phí khám chữa bệnh
--   Kiểu DECIMAL(18,2)
--   Dùng tham số IN
-- p_patient_type : Diện bệnh nhân (BHYT, VIP, THUONG)
--   Kiểu VARCHAR(20)
--   Dùng tham số IN

-- Dữ liệu đầu ra
-- p_final_amount : Số tiền cuối cùng phải thu
--   Kiểu DECIMAL(18,2)
--   Dùng tham số OUT
-- p_message : Thông báo trạng thái
--   Kiểu VARCHAR(100)
--   Dùng tham số OUT

-- Giải pháp và các bước thực hiện
-- Tạo Stored Procedure để:
-- 1. Nhận tổng chi phí và diện bệnh nhân.
-- 2. Kiểm tra dữ liệu hợp lệ:
--      + Nếu chi phí âm => trả về lỗi.
--      + Nếu hợp lệ:
--          BHYT => thu 20%
--          VIP => giảm 10%
--          THUONG => thu 100%
--      + Trả về:
--          Số tiền cuối cùng
--          Thông báo trạng thái

-- code
USE RikkeiClinicDB;

DELIMITER / /

CREATE PROCEDURE CalculatePatientPayment(
    IN p_total_cost DECIMAL(18,2),
    IN p_patient_type VARCHAR(20),
    OUT p_final_amount DECIMAL(18,2),
    OUT p_message VARCHAR(100)
)
BEGIN

    -- Kiểm tra chi phí hợp lệ
    IF p_total_cost < 0 THEN

        SET p_final_amount = 0;
        SET p_message = 'Loi: Chi phi khong hop le';

    ELSE

        -- Tính tiền theo diện bệnh nhân
        CASE
            WHEN p_patient_type = 'BHYT' THEN
                SET p_final_amount = p_total_cost * 0.2;

            WHEN p_patient_type = 'VIP' THEN
                SET p_final_amount = p_total_cost * 0.9;

            WHEN p_patient_type = 'THUONG' THEN
                SET p_final_amount = p_total_cost;

            ELSE
                SET p_final_amount = p_total_cost;
        END CASE;

        SET p_message = 'Da tinh toan xong';

    END IF;

END //

DELIMITER;

-- Kiểm thử
-- 1 — Bệnh nhân BHYT
CALL CalculatePatientPayment (
    1000000,
    'BHYT',
    @final_amount,
    @message
);

SELECT @final_amount, @message;

--Kết quả :
@final_amount = 200000 @message = 'Đã tính xong'

-- 2 — Bệnh nhân VIP
CALL CalculatePatientPayment (
    1000000,
    'VIP',
    @final_amount,
    @message
);

SELECT @final_amount, @message;

--Kết quả :
@final_amount = 900000

-- 3 — Bệnh nhân THUONG
CALL CalculatePatientPayment (
    1000000,
    'THUONG',
    @final_amount,
    @message
);

SELECT @final_amount, @message;

--Kết quả :
@final_amount = 1000000

-- 4 — Chặn dữ liệu âm
CALL CalculatePatientPayment (
    -500000,
    'VIP',
    @final_amount,
    @message
);

SELECT @final_amount, @message;

--Kết quả :
@final_amount = 0 
@message = 'Lỗi chi phí không hợp lệ'