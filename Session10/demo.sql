-- Active: 1777294904821@@127.0.0.1@3306@students_management

-- view
USE students_management;

-- tao view
CREATE VIEW student_avgScore AS
SELECT fullName FROM students;

SELECT * FROM student_avgscore;

-- tạo view có tên lớp và điểm trung bình của lớp
CREATE View avgScore AS 
SELECT c.className, AVG(s.avgScore) 
FROM classrooms c 
    JOIN students s ON s.classId = c.classId 
GROUP BY c.classId;

DROP VIEW avgScore;

SELECT * FROM avgScore;

-- lấy các lớp có điểm trung bình < 7.5
CREATE View avgScore AS 
SELECT c.className, ROUND(AVG(s.avgScore), 2) as avgScores
FROM classrooms c 
    JOIN students s ON s.classId = c.classId 
GROUP BY c.classId
HAVING avgScores < 7.5;

-- lấy điểm trung bình của lớp lớn nhất
SELECT * FROM avgScore
ORDER BY avgScores DESC
LIMIT 1;


-- index
DELIMITER $$

CREATE PROCEDURE insert_students()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100000 DO
        INSERT INTO students (
            studentId,
            fullName,
            email,
            age,
            classId,
            avgScore
        )
        VALUES (
            i,
            CONCAT('Student ', i),
            CONCAT('student', i, '@gmail.com'),
            FLOOR(18 + RAND() * 5),
            FLOOR(1 + RAND() * 5),
            ROUND(5 + RAND() * 5, 2)
        );
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;

CALL insert_students();



-- tạo NON-CLUSTERED INDEX
CREATE INDEX idx_avgScore ON students(avgScore);
EXPLAIN ANALYZE SELECT  fullName, avgScore FROM students
WHERE avgScore > 9.9;

-- tạo COMPOSITE INDEX
CREATE INDEX idx_fullName_score ON students(fullName, avgScore);

-- xoa INDEX
DROP INDEX idx_fullName_score ON students;
DROP INDEX idx_avgScore ON students;