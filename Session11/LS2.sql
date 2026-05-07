USE RikkeiClinicDB;

DELIMITER / /

CREATE PROCEDURE AddInventory(IN p_item_id INT, IN p_quantity INT)
BEGIN
    UPDATE Inventory
    SET stock_quantity = stock_quantity + p_quantity
    WHERE item_id = p_item_id;
END //

DELIMITER;

CALL AddInventory (10, 500);

SELECT * FROM Inventory;

-- thủ tục trên đang bị lỗi do chưa có điều kiên kiểm tra đầu vào dẫn đến nhập số âm thì sẽ thành trừ, gây hao hụt đơn hàng

-- xóa thủ tục cũ
DROP PROCEDURE AddInventory;

-- thủ tục mới
DELIMITER / /

CREATE PROCEDURE AddInventory(
    IN p_item_id INT,
    IN p_quantity INT
)
BEGIN
    -- Kiểm tra số lượng nhập có hợp lệ hay không
    IF p_quantity > 0 THEN

        -- Kiểm tra sản phẩm có tồn tại
        IF EXISTS (
            SELECT 1
            FROM Inventory
            WHERE item_id = p_item_id
        ) THEN

            -- Cộng thêm tồn kho
            UPDATE Inventory
            SET stock_quantity = stock_quantity + p_quantity
            WHERE item_id = p_item_id;

            SELECT 'Inventory updated successfully' AS message;

        ELSE
            SELECT 'Item does not exist' AS message;
        END IF;

    ELSE
        SELECT 'Invalid quantity. Quantity must be greater than 0' AS message;
    END IF;

END //

DELIMITER;