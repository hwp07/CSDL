-- Active: 1777294904821@@127.0.0.1@3306@studentdb
CREATE DATABASE StudentDB;
USE StudentDB;

-- 1. Bảng Khoa
CREATE TABLE Department (
    DeptID VARCHAR(5) PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

-- 2. Bảng SinhVien
CREATE TABLE Student (
    StudentID VARCHAR(6) PRIMARY KEY,
    FullName VARCHAR(50),
    Gender VARCHAR(10),
    BirthDate DATE,
    DeptID VARCHAR(5),
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);


-- 3. Bảng MonHoc
CREATE TABLE Course (
    CourseID VARCHAR(6) PRIMARY KEY,
    CourseName VARCHAR(50),
    Credits INT
);

-- 4. Bảng DangKy
CREATE TABLE Enrollment (
    StudentID VARCHAR(6),
    CourseID VARCHAR(6),
    Score DECIMAL(4,2), 
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Chèn dữ liệu mẫu
INSERT INTO Department VALUES
('IT','Information Technology'),
('BA','Business Administration'),
('ACC','Accounting');

INSERT INTO Student VALUES
('S00001','Nguyen An','Male','2003-05-10','IT'),
('S00002','Tran Binh','Male','2003-06-15','IT'),
('S00003','Le Hoa','Female','2003-08-20','BA'),
('S00004','Pham Minh','Male','2002-12-12','ACC'),
('S00005','Vo Lan','Female','2003-03-01','IT'),
('S00006','Do Hung','Male','2002-11-11','BA'),
('S00007','Nguyen Mai','Female','2003-07-07','ACC'),
('S00008','Tran Phuc','Male','2003-09-09','IT');



-- cau 1
CREATE VIEW ViewStudentBasic AS 
    SELECT s.StudentID, s.FullName, d.DeptName 
    FROM student s 
        JOIN department d ON d.DeptID = s.DeptID;

SELECT * FROM ViewStudentBasic;

-- cau 2
CREATE INDEX idxFullName ON Student(FullName);

-- cau 3
DELIMITER //
CREATE Procedure GetStudentsIT()
BEGIN
    SELECT * FROM student s
        JOIN department d ON d.DeptID = s.DeptID
    WHERE d.DeptName = 'Information Technology';
END //
DELIMITER;

CALL GetStudentsIT();

-- cau 4
CREATE VIEW ViewStudentCountByDept AS
    SELECT d.DeptName, COUNT(s.DeptID) AS TotalStudents
    FROM department d
        JOIN student s ON d.DeptID = s.DeptID
    GROUP BY s.DeptID;

SELECT * FROM ViewStudentCountByDept
ORDER BY TotalStudents DESC
LIMIT 1;

-- cau 5
DELIMITER //
CREATE PROCEDURE GetTopScoreStudent (in varCourseID varchar(6) )
BEGIN
    SELECT * 
    FROM Student t
    join Department d on d.DeptID = t.DeptID
    join Enrollment e on s.StudentID = e.StudentID
    where DeptName = varCourseID
    order by score desc
    limit 1;

END //
DELIMITER ;

call GetTopScoreStudent('BCC');
