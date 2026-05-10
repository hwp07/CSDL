DELIMITER //

CREATE TRIGGER PreventStatusRevert
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN
    -- Lỗi logic: Dùng NEW thay vì OLD khiến toàn bộ hệ thống bị "tê liệt"
    IF NEW.status = 'Completed' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Không được phép thao tác trên lịch khám này!';
    END IF;
END //

DELIMITER ;

-- tái hiện lỗi
UPDATE Appointments
SET status = 'Completed'
WHERE appointment_id = 104;
-- kết quả: Lỗi: Không được phép thao tác trên lịch khám này!
-- lý do: Phải dùng OLD.status vì cần kiểm tra trạng thái trước khi UPDATE. Nếu lịch khám trước đó đã là 'Completed' thì mới cần chặn chỉnh sửa. Dùng NEW.status sẽ chặn luôn cả thao tác cập nhật hợp lệ sang 'Completed'.


DROP TRIGGER PreventStatusRevert;

DELIMITER //

CREATE TRIGGER PreventStatusRevert
BEFORE UPDATE
ON Appointments
FOR EACH ROW
BEGIN
    -- Nếu trạng thái cũ đã Completed thì cấm sửa
    IF OLD.status = 'Completed' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Không được phép chỉnh sửa lịch khám đã hoàn thành!';
    END IF;
END //
DELIMITER ;

