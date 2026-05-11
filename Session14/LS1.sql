
USE rikkeiclinicdb;

DELIMITER //

CREATE PROCEDURE PayHospitalFee(IN p_patient_id INT, IN p_amount DECIMAL(18,2))
BEGIN
    -- Bước 1: Trừ tiền trong ví
    UPDATE Wallets SET balance = balance - p_amount WHERE patient_id = p_patient_id;

    -- Giả lập sự cố hệ thống bất ngờ xảy ra tại đây (Cúp điện, rớt mạng...)
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Hệ thống gặp sự cố mạng đột ngột!';

    -- Bước 2: Giảm trừ công nợ (Lệnh này không kịp chạy)
    UPDATE Patient_Invoices SET total_due = total_due - p_amount WHERE patient_id = p_patient_id;
END //
DELIMITER;


-- tái hiện lỗi
CALL PayHospitalFee (1, 200000);
SELECT * FROM wallets;
SELECT * FROM Patient_Invoices;
-- vi phạm lỗi atomicity (tính nguyên tử) => cùng thất bại / cùng thành công


-- xóa procedure cũ
DROP PROCEDURE PayHospitalFee;

-- tạo procedure mới
DELIMITER //
CREATE PROCEDURE PayHospitalFee(
    IN p_patient_id INT,
    IN p_amount DECIMAL(18,2)
)
BEGIN
    -- xu ly loi => rollback
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Giao dịch thất bại - Đã hoàn tác dữ liệu' AS message;
    END;

    START TRANSACTION;

    -- trru tien vi
    UPDATE wallets
    SET balance = balance - p_amount
    WHERE patient_id = p_patient_id;

    -- gia lap loi
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Hệ thống gặp sự cố mạng đột ngột!';

    -- giam cong no
    UPDATE Patient_Invoices
    SET total_due = total_due - p_amount
    WHERE patient_id = p_patient_id;

    COMMIT;
END //
DELIMITER;

-- test
CALL PayHospitalFee (1, 200000);
SELECT * FROM wallets;
SELECT * FROM Patient_Invoices;
