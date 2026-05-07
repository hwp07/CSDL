-- Active: 1777294904821@@127.0.0.1@3306@students_management
USE students_management;

-- stored procedure (thủ tục được lưu trữ)
-- delimiter //
-- create procedure procedure_name(param1, param2,...)
-- begin
--  sql commands
-- end //
-- delimiter ;


-- Xây dựng thủ tục lấy ra tên và điểm của sinh viên

DELIMITER //
CREATE PROCEDURE view_name_score() 
BEGIN
    SELECT fullName, avgScore FROM students;
END //
DELIMITER;

CALL view_name_score();


-- tham số chỉ truyền vào (IN)
-- lấy ra các sinh viên có điểm được nhập vào
DELIMITER //
CREATE PROCEDURE view_score(IN p_score FLOAT) 
BEGIN
    SELECT * FROM students
    WHERE avgScore = p_score;
END //
DELIMITER;

CALL view_score(9);


-- tham số chỉ lấy ra (OUT)
-- lấy ra tên sinh viên có điểm được truyền vào
DELIMITER //
CREATE PROCEDURE view_score(
    IN inputScore FLOAT,
    OUT studentName VARCHAR(100)
)
BEGIN
    SELECT fullName INTO studentName
    FROM students
    WHERE avgScore >= inputScore
    LIMIT 1;
END //
DELIMITER ;

drop Procedure view_score;

call view_score (8, @studentName2);
SELECT @studentName2;


-- tham số cả vào cả ra (INOUT)
-- viết thủ tục lấy ra biến = điểm truyền vào + 0.2
DELIMITER //

CREATE PROCEDURE increase_score(INOUT scores FLOAT)
BEGIN
    SET scores = scores + 0.2;
END //

DELIMITER ;

SET @newScore = 9;
CALL increase_score(@newScore);
SELECT ROUND(@newScore, 2);

DROP Procedure increase_score;


-- khai báo biến và câu điều kiện trong thủ tục
-- cú pháp khai báo biến: 
-- DECLARE name DATA_TYPE DEFAULT value;


-- cú pháp câu điều kiện:
-- IF conditions 1
-- THEN SQL commands;
-- ELSEIF conditions 2
-- THEN SQL commmands;
-- .....
-- ELSE
-- SQL commands
-- END IF;


-- Lấy ra biến chứa xếp loại của sinh viên
-- nếu điểm > 8 : giỏi
-- nếu điểm > 5 : khá
-- còn lại : yếu

DELIMITER //

CREATE PROCEDURE ranking_student_by_id(
    OUT p_rank VARCHAR(5), IN p_student_id INT
)
BEGIN
-- khai báo biến
    DECLARE score FLOAT;

-- đặt điểm sih viên vào biến
    SELECT avgScore INTO score
    FROM students
    WHERE studentId = p_student_id;

    -- xếp loại
    IF score > 8 THEN
        SET p_rank = 'Giỏi';
    ELSEIF score > 5 THEN
        SET p_rank = 'Khá';
    ELSE
        SET p_rank = 'Yếu';
    END IF;


END //

DELIMITER ;

SET @rank = '';
CALL ranking_student_by_id(@rank, 8);
SELECT @rank;

DROP Procedure ranking_student_by_id;