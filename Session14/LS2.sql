USE rikkeiclinicdb;

DELIMITER //

CREATE PROCEDURE TransferBed(IN p_patient_id INT, IN p_new_bed_id INT)
BEGIN
    -- Thao tác 1: Giải phóng giường cũ
    UPDATE Beds SET patient_id = NULL WHERE patient_id = p_patient_id;

    -- Thao tác 2: Gán giường mới
    UPDATE Beds SET patient_id = p_patient_id WHERE bed_id = p_new_bed_id;
END //

DELIMITER;

-- giải thích
-- sự có bênh nhân bị mất khỏi cả 2 giường bi phạm tính nguyên - atomicity vì quá trình đó yêu cầu cùng thành công hoặc cùng bị hủy => dữ liệu không nhất quán


-- xóa procedure cũ
DROP PROCEDURE TransferBed;

-- tạo mới
DELIMITER //
CREATE PROCEDURE TransferBed(
    IN p_patient_id INT,
    IN p_new_bed_id INT
)
BEGIN
    -- co loi thi rollback
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Thất bại: Đã hoàn tác quá trình chuyển giường' AS message;
    END;

    START TRANSACTION;
    -- xoa giuong cu
    UPDATE beds
    SET patient_id = NULL
    WHERE patient_id = p_patient_id;

    -- gia lap loi he thong
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Lỗi hệ thống';

    -- gan giuong moi
    UPDATE Beds
    SET patient_id = p_patient_id
    WHERE bed_id = p_new_bed_id;

    COMMIT;
    SELECT 'Thành công: Đã chuyển giường bệnh nhân' AS message;
END //
DELIMITER;


-- tets
CALL TransferBed (1, 201);
SELECT * FROM Beds;