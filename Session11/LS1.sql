-- Active: 1777294904821@@127.0.0.1@3306@rikkeiclinicdb
USE RikkeiClinicDB;

-- Đoạn mã nguồn hiện tại đang chạy trên Database
DELIMITER //

CREATE PROCEDURE CancelAppointment(IN p_appointment_id INT)
BEGIN
    -- Cập nhật trạng thái lịch khám thành "Đã hủy"
    UPDATE Appointments
    SET status = 'Pending'
    WHERE appointment_id = p_appointment_id;
END //

DELIMITER ;

CALL CancelAppointment(104);

SELECT * FROM Appointments;

-- code trên đang bị lỗi vì thủ tục không tìm kiếm appointment_id có tồn tại trong bảng không trước khi cập nhật, câu lệnh chạy vẫn thành công nhưng lại không có appointment_id nào được cập nhất ( nếu nhập sai id).

-- xóa Procedure
DROP Procedure CancelAppointment;

-- Procedure mới
DELIMITER //

CREATE PROCEDURE CancelAppointment(IN p_appointment_id INT)
BEGIN
    -- Kiểm tra lịch khám có tồn tại hay không
    IF EXISTS (
        SELECT 1
        FROM Appointments
        WHERE appointment_id = p_appointment_id
    ) THEN

        -- Cập nhật trạng thái thành "Cancelled"
        UPDATE Appointments
        SET status = 'Cancelled'
        WHERE appointment_id = p_appointment_id;

        SELECT 'Appointment cancelled successfully' AS message;

    ELSE
        -- Thông báo lỗi nếu không tồn tại
        SELECT 'Appointment does not exist' AS message;
    END IF;

END //

DELIMITER ;

-- test
CALL CancelAppointment(105);
SELECT * FROM Appointments;
