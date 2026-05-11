USE RikkeiClinicDB;

DELIMITER //

CREATE PROCEDURE ProcessEquipmentPurchase (
    IN p_patient_id INT,
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_price DECIMAL(18,2);
    DECLARE v_stock INT;
    DECLARE v_total DECIMAL(18,2);
    DECLARE v_balance DECIMAL(18,2);
    DECLARE v_status VARCHAR(20);

    START TRANSACTION;

    -- lay thong tin san pham
    SELECT price, stock INTO v_price, v_stock
    FROM Products
    WHERE product_id = p_product_id;

    -- lay thong tin vi
    SELECT balance, status INTO v_balance, v_status
    FROM Wallets
    WHERE patient_id = p_patient_id;

    -- kiem tra trang thai vi
    IF v_status = 'Inactive'
        THEN ROLLBACK;
        SELECT 'Thất bại: Ví đang bị khóa' AS message;

    ELSEIF p_quantity > v_stock
        THEN ROLLBACK;
        SELECT 'Thất bại: Kho không đủ sản phẩm' AS message;

    ELSE
        -- tinh tien
        SET v_total = p_quantity * v_price;

        -- kiem tra so du
        IF v_total > v_balance
            THEN ROLLBACK;
           SELECT 'Thất bại: Số dư ví không đủ' AS message;

        ELSE
            -- tru ton kho
            UPDATE products
            SET stock = stock - p_quantity
            WHERE product_id = p_product_id;


            -- tru vi tien
            UPDATE wallets
            SET balance = balance - v_stock
            WHERE patient_id = p_patient_id;
        END IF;

    END IF;
END //

DELIMITER;

-- test 1
CALL ProcessEquipmentPurchase (1, 2, 1);

SELECT * FROM wallets;

SELECT * FROM products;

-- test 2
CALL ProcessEquipmentPurchase (1, 2, 100);

-- test 3
CALL ProcessEquipmentPurchase (2, 2, 1);