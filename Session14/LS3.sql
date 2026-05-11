USE RikkeiClinicDB;

DROP PROCEDURE DispenseMedicine;

DELIMITER //

CREATE PROCEDURE DispenseMedicine(
    IN p_patient_id INT,
    IN p_medicine_id INT,
    IN p_quantity INT,

    OUT p_message VARCHAR(255)

)
BEGIN
    DECLARE v_stock INT;
    DECLARE v_price DECIMAL(18,2);
    DECLARE v_total DECIMAL(18,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;

        SET p_message =
        'Lỗi hệ thống - Đã rollback dữ liệu';

    END;

    START TRANSACTION;

    -- lau thon tin thuoc
    SELECT stock, price
    INTO v_stock, v_price
    FROM Medicines
    WHERE medicine_id = p_medicine_id;


    -- kiem trra ton kho
    IF p_quantity > v_stock THEN
        ROLLBACK;

        SET p_message =
        'Lỗi: Số lượng tồn kho không đủ';

    ELSE
    -- tong tien
        SET v_total = p_quantity * v_price;

        -- tru so luong kho
        UPDATE Medicines
        SET stock = stock - p_quantity
        WHERE medicine_id = p_medicine_id;
        
        -- cong no benh nhan
        UPDATE Patient_Invoices
        SET total_due = total_due + v_total
        WHERE patient_id = p_patient_id;

        COMMIT;

        SET p_message =
        'Đã cấp phát thành công';
    END IF;
END //
DELIMITER;


-- test 
CALL DispenseMedicine (1, 1, 5, @msg);
SELECT @msg;
SELECT * FROM Medicines WHERE medicine_id = 1;
SELECT * FROM Patient_Invoices WHERE patient_id = 1;


-- test 2
CALL DispenseMedicine (1, 2, 10, @msg);
SELECT @msg;
SELECT * FROM Medicines WHERE medicine_id = 2;