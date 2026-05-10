DELIMITER / /

CREATE TRIGGER PreventPastAppointments
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN
    -- Lỗi logic: Đang lấy ngày cũ ra so sánh với hiện tại thay vì kiểm tra ngày mới
    IF OLD.appointment_date < NOW() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Không thể đặt lịch khám vào thời điểm trong quá khứ!';
    END IF;
END //

DELIMITER;

-- tái hiện lỗi
UPDATE Appointments
SET
    appointment_date = '2025-01-10 08:00:00'
WHERE
    appointment_id = 104;

-- giải thích
-- OLD.appointment_date là giá trị lịch khám cũ trước khi UPDATE.
-- NEW.appointment_date là giá trị lịch khám mới mà người dùng đang muốn cập nhật.

-- Trigger cũ đang kiểm tra OLD.appointment_date với NOW(), trong khi dữ liệu cần kiểm tra thực sự là NEW.appointment_date. Vì vậy hệ thống không phát hiện việc người dùng nhập ngày khám mới nằm trong quá khứ.

DROP TRIGGER PreventPastAppointments;

DELIMITER / /
CREATE TRIGGER PreventPastAppointments
BEFORE UPDATE
ON Appointments
FOR EACH ROW
BEGIN
    -- Kiểm tra ngày khám mới có nằm trong quá khứ không
    IF NEW.appointment_date < NOW() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Không thể đặt lịch khám vào thời điểm trong quá khứ!';
    END IF;
END //
DELIMITER;