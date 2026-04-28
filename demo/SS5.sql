-- Active: 1776147792947@@127.0.0.1@3306@csdl
CREATE DATABASE students_management;
USE students_management;
CREATE TABLE classrooms (classId INT PRIMARY KEY, className varchar(20));
CREATE TABLE students (
    studentId INT PRIMARY KEY,
    fullName varchar(30),
    email varchar(50) UNIQUE,
    age TINYINT CHECK (age > 0),
    createAt DATE DEFAULT (current_date()),
    classId INT,
    avgScore FLOAT CHECK (avgScore > 0),
    FOREIGN KEY (classId) REFERENCES classrooms (classId)
);
INSERT INTO classrooms (classId, className)
VALUES (1, 'CNTT1'),
    (2, 'CNTT2'),
    (3, 'KinhTe1'),
    (4, 'Marketing1'),
    (5, 'QTKD1');
INSERT INTO students (
        studentId,
        fullName,
        email,
        age,
        classId,
        avgScore
    )
VALUES (1, 'Nguyen Van A', 'a1@gmail.com', 20, 1, 7.5),
    (2, 'Tran Thi B', 'b2@gmail.com', 21, 1, 8.2),
    (3, 'Le Van C', 'c3@gmail.com', 19, 2, 6.8),
    (4, 'Pham Thi D', 'd4@gmail.com', 22, 2, 7.9),
    (5, 'Hoang Van E', 'e5@gmail.com', 20, 3, 5.5),
    (6, 'Nguyen Thi F', 'f6@gmail.com', 21, 3, 9.1),
    (7, 'Tran Van G', 'g7@gmail.com', 23, 4, 6.0),
    (8, 'Le Thi H', 'h8@gmail.com', 20, 4, 7.2),
    (9, 'Pham Van I', 'i9@gmail.com', 19, 5, 8.8),
    (10, 'Hoang Thi J', 'j10@gmail.com', 22, 5, 7.0),
    (11, 'Nguyen Van K', 'k11@gmail.com', 21, 1, 6.5),
    (12, 'Tran Thi L', 'l12@gmail.com', 20, 1, 7.7),
    (13, 'Le Van M', 'm13@gmail.com', 19, 2, 8.3),
    (14, 'Pham Thi N', 'n14@gmail.com', 22, 2, 5.9),
    (15, 'Hoang Van O', 'o15@gmail.com', 20, 3, 6.6),
    (16, 'Nguyen Thi P', 'p16@gmail.com', 21, 3, 9.4),
    (17, 'Tran Van Q', 'q17@gmail.com', 23, 4, 7.1),
    (18, 'Le Thi R', 'r18@gmail.com', 20, 4, 8.0),
    (19, 'Pham Van S', 's19@gmail.com', 19, 5, 6.9),
    (20, 'Hoang Thi T', 't20@gmail.com', 22, 5, 7.8),
    (21, 'Nguyen Van U', 'u21@gmail.com', 21, 1, 5.8),
    (22, 'Tran Thi V', 'v22@gmail.com', 20, 2, 6.2),
    (23, 'Le Van W', 'w23@gmail.com', 19, 3, 7.4),
    (24, 'Pham Thi X', 'x24@gmail.com', 22, 4, 8.6),
    (25, 'Hoang Van Y', 'y25@gmail.com', 20, 5, 9.0),
    (26, 'Nguyen Thi Z', 'z26@gmail.com', 21, 1, 6.7),
    (27, 'Tran Van AA', 'aa27@gmail.com', 23, 2, 7.3),
    (28, 'Le Thi BB', 'bb28@gmail.com', 20, 3, 8.1),
    (29, 'Pham Van CC', 'cc29@gmail.com', 19, 4, 5.6),
    (30, 'Hoang Thi DD', 'dd30@gmail.com', 22, 5, 7.9);
SELECT *
FROM students;
SELECT studentId,
    fullName,
    avgScore,
    CASE
        WHEN avgScore > 8 THEN 'Gioi'
        WHEN avgScore > 7 THEN 'Kha'
        ELSE 'TB'
    END AS 'Hoc Luc'
FROM students;