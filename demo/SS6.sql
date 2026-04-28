-- Active: 1776147792947@@127.0.0.1@3306@students_management

USE students_management;

SELECT * FROM students;

SELECT * FROM classrooms;

-- 6.SELECT
-- 1.FROM
-- 2.JOIN TABLE_NAME ON CONDITION
-- 3.WHERE
-- 4.GROUP BY
-- 5.HAVING
-- 7.ORDER BY
-- 8.LIMIT OFFSET

-- JOIN
-- INNER JOIN: Lấy phần giao của 2 bảng
-- LEFT JOIN: Lấy phần bên trái của bảng và phần chung của 2 bảng kể cả các bản ghi k thỏa mãn đk
-- RIGHT JOIN: Lấy phần bên trái của bảng và phần chung của 2 bảng kể cả các bản ghi k thỏa mãn đk
-- OUTER JOIN: Lấy hết, không khớp => NULL

-- INNER JOIN
SELECT s.*, c.className
FROM students s
    JOIN classrooms c ON s.classId = c.classId;

-- LEFT JOIN/RIGHT JOIN
SELECT s.*, c.className
FROM students s
    LEFT JOIN classrooms c ON s.classId = c.classId;

-- Các hàm tổng hợp (AGREGATE FUNCTION)
-- AVG, SUM, COUNT, MAX, MIN

-- Lấy ta tổng số sinh viên trong hệ thống;
SELECT COUNT(studentId) Total FROM students;

-- Lấy ra điểm trung bình của toàn bộ sinh viên
SELECT ROUND(AVG(avgScore), 2) AS total FROM students;

-- GROUP BY: Nhóm các dữ liệu theo cột

--Lấy tất cả các lớp và sĩ số sinh viên trong mỗi lớp
SELECT c.`classId`, c.`className`, COUNT(s.`fullName`) Total_student
FROM classrooms c
    JOIN students s on s.`classId` = c.`classId`
GROUP BY
    c.`classId`

-- lấy các lớp và điểm trung bình của các sinh viên trong lớp
SELECT c.`classId`, c.`className`, ROUND(avg(s.`avgScore`), 1) AVG_student
FROM classrooms c
    JOIN students s on s.`classId` = c.`classId`
GROUP BY
    c.`classId`

-- Lấy số lượng sinh viên các lớp có điểm trung bình > 7.5
SELECT c.`classId`, c.`className`, COUNT(s.`avgScore`)
FROM classrooms c
    JOIN students s on s.`classId` = c.`classId`
WHERE
    `avgScore` > 7.5
GROUP BY
    c.`classId`

-- chỉ in ra những lớp mà số lượng sinh viên có số lượng sinh viên >= 3

SELECT c.`classId`, c.`className`, COUNT(s.`avgScore`) total
FROM classrooms c
    JOIN students s ON s.`classId` = c.`classId`
WHERE
    `avgScore` > 7.5
GROUP BY
    c.`classId`
HAVING
    total >= 3;