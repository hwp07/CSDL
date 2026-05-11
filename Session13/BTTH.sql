USE RikkeiClinicDB;

DELIMITER //

CREATE TRIGGER AutoDeductWallet
BEFORE INSERT
ON Service_Usages
FOR EACH ROW
BEGIN
    -- biến lưu giá dịch vụ
    DECLARE v_actual_price DECIMAL(18,2);

    -- biến lưu số dư ví
    DECLARE v_balance DECIMAL(18,2);

    -- biến lưu trạng thái ví
    DECLARE v_status VARCHAR(20);

    -- lấy giá dịch vụ
    SELECT price
    INTO v_actual_price
    FROM Services
    WHERE service_id = NEW.service_id;

    -- gán giá vào actual_price
    SET NEW.actual_price = v_actual_price;

    -- lấy thông tin ví
    SELECT balance, status
    INTO v_balance, v_status
    FROM Wallets
    WHERE patient_id = NEW.patient_id;

    -- kiểm tra ví bị khóa
    IF v_status = 'Inactive' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Thất bại: Ví trả trước đang bị khóa';
    END IF;

    -- kiểm tra không đủ tiền
    IF v_balance < v_actual_price THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Thất bại: Số dư ví không đủ để thanh toán';
    END IF;

    -- trừ tiền trong ví
    UPDATE Wallets
    SET balance = balance - v_actual_price
    WHERE patient_id = NEW.patient_id;

END //

DELIMITER;

-- test 1
INSERT INTO Service_Usages (patient_id, service_id) 
VALUES (1, 1);

SELECT * FROM Wallets 
WHERE patient_id = 1;

-- test 2
INSERT INTO Service_Usages (patient_id, service_id) 
VALUES (3, 1);

-- test 3
INSERT INTO Service_Usages (patient_id, service_id) 
VALUES (2, 1);