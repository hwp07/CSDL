USE RikkeiClinicDB;

DROP PROCEDURE PayHospitalFee;

DELIMITER //

CREATE PROCEDURE PayHospitalFee(
    IN p_patient_id INT,
    IN p_amount DECIMAL(18,2),

    OUT p_message VARCHAR(255)

)
BEGIN
    DECLARE v_balance DECIMAL(18,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;

        SET p_message =
        'Lỗi hệ thống - Đã rollback dữ liệu';
    END;

    START TRANSACTION;

    -- lay so du
    SELECT balance
    INTO v_balance
    FROM Wallets
    WHERE patient_id = p_patient_id;

    -- kiem tra thanh toan
    IF p_amount <= 0 THEN
        ROLLBACK;

        SET p_message =
        'Lỗi: Số tiền thanh toán không hợp lệ';

    ELSEIF p_amount > v_balance THEN
        ROLLBACK;

        SET p_message =
        'Lỗi: Số dư ví không đủ';
    ELSE
        -- tru tien trong vi
        UPDATE Wallets
        SET balance = balance - p_amount
        WHERE patient_id = p_patient_id;

        -- giam cong no
        UPDATE Patient_Invoices
        SET total_due = total_due - p_amount
        WHERE patient_id = p_patient_id;

        COMMIT;

        SET p_message =
        'Thanh toán thành công';
    END IF;
END //
DELIMITER;

-- test 1
CALL PayHospitalFee (1, 200000, @msg);
SELECT @msg;
SELECT * FROM Wallets WHERE patient_id = 1;
SELECT * FROM Patient_Invoices WHERE patient_id = 1;


-- test 2
CALL PayHospitalFee (2, 100000, @msg);
SELECT @msg;
SELECT * FROM Wallets WHERE patient_id = 2;
SELECT * FROM Patient_Invoices WHERE patient_id = 2;


-- test 3
CALL PayHospitalFee (1, -50000, @msg);
SELECT @msg;
SELECT * FROM Wallets WHERE patient_id = 1;
SELECT * FROM Patient_Invoices WHERE patient_id = 1;