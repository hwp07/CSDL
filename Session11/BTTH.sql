USE RikkeiClinicDB;

-- PHAN A - PHAN TICH I/O

-- INPUT DATA
-- p_patient_id    : Ma benh nhan
-- p_medicine_id   : Ma thuoc
-- p_quantity      : So luong thuoc can ke
-- p_discount_code : Ma giam gia

-- OUTPUT DATA
-- p_message : Thong bao trang thai tra ve cho Backend

-- LUA CHON THAM SO
-- IN:
--     Dung cho cac du lieu dau vao do Backend gui vao he thong
--
-- OUT:
--     Dung cho p_message vi:
--     + Gia tri duoc tao ben trong Procedure
--     + Khong can truyen gia tri ban dau
--     + Backend chi can nhan ket qua sau khi xu ly
--
-- KHONG DUNG INOUT:
--     Vi he thong khong can vua nhan vua cap nhat lai
--     cung mot gia tri tu ben ngoai

-- PHAN A - THIET KE LUONG XU LY

-- FLOW XU LY:
--
-- 1. Nhan thong tin don thuoc
-- 2. Kiem tra so luong hop le (>0)
-- 3. Lay gia thuoc va ton kho hien tai
-- 4. Kiem tra kho co du thuoc khong
-- 5. Tinh thanh tien
-- 6. Ap dung ma giam gia
-- 7. Tru ton kho
-- 8. Cong cong no benh nhan
-- 9. Commit transaction
-- 10. Tra thong bao ket qua
--
-- CAC LOCAL VARIABLES:
--
-- v_price
--     Luu don gia thuoc
--
-- v_stock
--     Luu ton kho hien tai
--
-- v_total_amount
--     Tong tien truoc giam gia
--
-- v_final_amount
--     Tong tien sau giam gia

-- CREATE PROCEDURE
DELIMITER /
/

CREATE PROCEDURE ProcessPrescription(
    IN p_patient_id INT,
    IN p_medicine_id INT,
    IN p_quantity INT,
    IN p_discount_code VARCHAR(50),
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_price DECIMAL(18,2);
    DECLARE v_stock INT;
    DECLARE v_total_amount DECIMAL(18,2);
    DECLARE v_final_amount DECIMAL(18,2);
    START TRANSACTION;

    -- VALIDATE INPUT
    IF p_quantity <= 0 THEN

        SET p_message =
            'Thất bại';
        ROLLBACK;
    ELSE
 
        -- GET MEDICINE INFO
        SELECT
            price,
            stock
        INTO
            v_price,
            v_stock
        FROM Medicines
        WHERE medicine_id = p_medicine_id;

        -- CHECK MEDICINE EXISTS
        IF v_stock IS NULL THEN
            SET p_message =
                'Thât bại';
            ROLLBACK;

        -- CHECK STOCK
        ELSEIF v_stock < p_quantity THEN
            SET p_message =
                'Thất bại';
            ROLLBACK;
        ELSE
            -- CALCULATE ORIGINAL PRICE
            SET v_total_amount =
                p_quantity * v_price;

            -- APPLY DISCOUNT
            IF p_discount_code = 'NV-RIKKEI' THEN
                SET v_final_amount =
                    v_total_amount * 0.5;

            ELSE
                SET v_final_amount =
                    v_total_amount;
            END IF;

            -- UPDATE STOCK
            UPDATE Medicines
            SET stock = stock - p_quantity
            WHERE medicine_id = p_medicine_id;

            -- UPDATE PATIENT DEBT
            UPDATE Patient_Invoices
            SET total_due =
                total_due + v_final_amount
            WHERE patient_id = p_patient_id;

            -- SUCCESS
            SET p_message =
                'Thành công';
            COMMIT;
        END IF;
    END IF;
END
/
/

DELIMITER;

-- TEST 1
CALL ProcessPrescription (1, 1, 2, NULL, @message);

SELECT @message;

-- TEST 2
CALL ProcessPrescription (
    2,
    1,
    4,
    'NV-RIKKEI',
    @message
);

SELECT @message;

-- TEST 3
CALL ProcessPrescription (3, 2, 10, NULL, @message);

SELECT @message;

-- OPTIONAL CHECK DATA
SELECT * FROM Medicines;

SELECT * FROM Patient_Invoices;