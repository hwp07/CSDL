CREATE DATABASE ss13;

USE ss13;

CREATE TABLE student (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    sex BIT,
    birthday DATE,  -- ngày sinh phải là ngày trong quá 
    phone varchar(11) UNIQUE
);

-- tạo trigger kiểm tra ngày sinh trươc khi chèn vao bang student
-- dối tượng old và new để lưu trữ dữ liệu tạm thời trước và sau khi tahy đổi

DELIMITER //
CREATE Trigger trigger_before_insert_student
BEFORE INSERT ON student
FOR EACH ROW
BEGIN
        IF NEW.birthday >= CURRENT_DATE() THEN
            -- nem ra thong bao loi 
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Khong the them ngay sinh sau ngay hien tai';
        END IF;
END //
DELIMITER;

INSERT INTO student
VALUES(null,'nguyen van a', 1, '2027-12-12', '0123456789');

SELECT * FROM student;


-- cú pháp tạo trigger

-- delimiter //
-- create trigger trigger_name 
-- (before / after) (insert / update / deleted)
-- ON table_name
-- for each row 
-- begin
-- sql commands
-- end //
-- delimiter ;

USE students_management;
SELECT * FROM students
WHERE classId = 5;
INSERT INTO students (studentId, fullName, email, age, avgScore)
VALUES (100005, 'Hong Phong', 'hongphong@gmail.com', 18, 6);


-- Xây dựng trigger tự động thêm sinh viên vào lớp chung
DELIMITER //
CREATE TRIGGER add_student
BEFORE INSERT 
ON students
FOR EACH ROW
BEGIN
   SET NEW.classId = 5;
END //
DELIMITER;

DROP TRIGGER add_student;
SELECT * FROM students;



-- tạo bảng lưu lại thông tin sinh viên
CREATE Table student_score_log (
    logId INT AUTO_INCREMENT PRIMARY KEY,
    studentId INT,
    oldScore FLOAT,
    newScore FLOAT,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- xây dựng trigger lưu lại thông tin khi cập nhật điểm
-- thực hiện cập nhật điểm cho sinh viên
DELIMITER //
CREATE TRIGGER update_score_log
AFTER UPDATE 
ON students
FOR EACH ROW
BEGIN
    IF OLD.avgScore <> NEW.avgScore
    THEN
        INSERT INTO student_score_log(`studentId`, `oldScore`, `newScore`)
        VALUES(OLD.studentId, OLD.avgScore, NEW.avgScore);
    END IF;
END //
DELIMITER;
SELECT * FROM update_score_log;



UPDATE students
SET avgScore = 10
WHERE studentId = 2;

