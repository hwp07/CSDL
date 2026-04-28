-- Active: 1776147792947@@127.0.0.1@3306@students_management
USE students_management;

SELECT * FROM students;

SELECT * FROM classrooms;

-- truy vấn lồng so sánh với 1 giá trị
-- lấy sinh viên có điểm cao hơn trung bình toàn bộ sinh viên

SELECT *
FROM students
WHERE
    avgScore > (
        SELECT avg(avgScore)
        FROM students
    )

-- lấy sinh viên có tuổi lớn hơn trung bình
SELECT *
FROM students
WHERE
    age > (
        SELECT avg(age)
        FROM students
    );

-- lấy toàn bộ sinh viên và điểm trung bình lớp của sinh viên đó
SELECT *, (
        SELECT AVG(avgScore)
        FROM students s2
        WHERE
            s1.`classId` = s2.`classId`
    ) as avgClass
FROM students s1

-- lấy toàn bộ sinh viên và sĩ số lớp đó
SELECT *, (
        SELECT COUNT(studentId)
        FROM students s2
        WHERE
            s1.`classId` = s2.`classId`
    ) as totalSV
FROM students s1;

-- truy vấn lồng với nhiều giá trị
-- lấy các sinh viên trong lớp bắt đầu bằng CN
select * from classrooms WHERE className like 'CN%'

SELECT *
FROM students
WHERE
    classId IN (
        SELECT classId
        FROM classrooms
        WHERE
            className like 'CN%'
    );

-- lấy lớp có ít nhất 1 sinh viên điểm > 8
-- sử dụng EXISTS
SELECT c.className
FROM classrooms c
WHERE
    EXISTS (
        SELECT *
        FROM students s
        WHERE
            c.classId = s.classId
            AND s.avgScore > 8
    );

-- lấy sinh viên có điểm lớn hơn tất cả sinh viên lớp 2
-- dùng ALL
SELECT *
FROM students
WHERE
    avgScore > ALL (
        SELECT avgScore
        FROM students
        WHERE
            classId = 2
    );

SELECT *
FROM students
WHERE
    avgScore > (
        SELECT MAX(avgScore)
        FROM students
        WHERE
            classId = 2
    );

-- Lấy sinh viên có điểm lớn hơn ít nhất 1 sinh viên lớp 2
SELECT *
FROM students
WHERE
    avgScore > EXISTS (
        SELECT avgScore
        FROM students
        WHERE
            classId = 2
    );