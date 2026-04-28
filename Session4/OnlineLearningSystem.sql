-- Tạo Database
CREATE DATABASE OnlineLearningSystem;
USE OnlineLearningSystem;
CREATE TABLE Student (
    StudentID VARCHAR(10) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL
);
CREATE TABLE Instructor (
    InstructorID VARCHAR(10) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL
);
CREATE TABLE Course (
    CourseID VARCHAR(10) PRIMARY KEY,
    CourseName NVARCHAR(200) NOT NULL,
    Description NVARCHAR(500),
    NumberOfSessions INT CHECK (NumberOfSessions > 0),
    InstructorID VARCHAR(10) NOT NULL,
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID)
);
CREATE TABLE Enrollment (
    EnrollmentID INT IDENTITY(1, 1) PRIMARY KEY,
    StudentID VARCHAR(10) NOT NULL,
    CourseID VARCHAR(10) NOT NULL,
    EnrollmentDate DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    UNIQUE (StudentID, CourseID)
);
CREATE TABLE Result (
    ResultID INT IDENTITY(1, 1) PRIMARY KEY,
    StudentID VARCHAR(10) NOT NULL,
    CourseID VARCHAR(10) NOT NULL,
    MidtermScore DECIMAL(4, 2) CHECK (
        MidtermScore BETWEEN 0 AND 10
    ),
    FinalScore DECIMAL(4, 2) CHECK (
        FinalScore BETWEEN 0 AND 10
    ),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    UNIQUE (StudentID, CourseID)
);
INSERT INTO Instructor (InstructorID, FullName, Email)
VALUES (
        'GV001',
        'Nguyễn Văn An',
        'an.nguyen@uni.edu.vn'
    ),
    (
        'GV002',
        'Trần Thị Bình',
        'binh.tran@uni.edu.vn'
    ),
    (
        'GV003',
        'Lê Hoàng Cường',
        'cuong.le@uni.edu.vn'
    ),
    (
        'GV004',
        'Phạm Thị Dung',
        'dung.pham@uni.edu.vn'
    ),
    ('GV005', N'Vũ Minh Em', 'em.vu@uni.edu.vn');
INSERT INTO Student (StudentID, FullName, DateOfBirth, Email)
VALUES (
        'SV001',
        'Phạm Văn Hải',
        '2003-05-15',
        'hai.pham@stu.edu.vn'
    ),
    (
        'SV002',
        'Lê Thị Lan',
        '2004-02-20',
        'lan.le@stu.edu.vn'
    ),
    (
        'SV003',
        'Trần Minh Quân',
        '2003-11-10',
        'quan.tran@stu.edu.vn'
    ),
    (
        'SV004',
        'Nguyễn Thị Hoa',
        '2004-08-05',
        'hoa.nguyen@stu.edu.vn'
    ),
    (
        'SV005',
        'Đỗ Hoàng Nam',
        '2003-03-25',
        'nam.do@stu.edu.vn'
    );
INSERT INTO Course (
        CourseID,
        CourseName,
        Description,
        NumberOfSessions,
        InstructorID
    )
VALUES (
        'KH001',
        'Lập trình Python cơ bản',
        'Khóa học giới thiệu ngôn ngữ Python',
        12,
        'GV001'
    ),
    (
        'KH002',
        'Cơ sở dữ liệu SQL',
        'Học thiết kế và truy vấn CSDL',
        15,
        'GV002'
    ),
    (
        'KH003',
        'Web Development với HTML/CSS/JS',
        'Xây dựng website tĩnh',
        10,
        'GV003'
    ),
    (
        'KH004',
        'Machine Learning cơ bản',
        'Giới thiệu học máy',
        14,
        'GV001'
    ),
    (
        'KH005',
        'Tiếng Anh chuyên ngành CNTT',
        'Kỹ năng tiếng Anh cho lập trình viên',
        8,
        'GV004'
    );
INSERT INTO Enrollment (StudentID, CourseID, EnrollmentDate)
VALUES ('SV001', 'KH001', '2026-01-10'),
    ('SV001', 'KH002', '2026-01-12'),
    ('SV002', 'KH001', '2026-01-15'),
    ('SV002', 'KH003', '2026-01-16'),
    ('SV003', 'KH002', '2026-01-18'),
    ('SV003', 'KH004', '2026-01-20'),
    ('SV004', 'KH001', '2026-01-22'),
    ('SV005', 'KH005', '2026-01-25');
INSERT INTO Result (StudentID, CourseID, MidtermScore, FinalScore)
VALUES ('SV001', 'KH001', 8.5, 9.0),
    ('SV001', 'KH002', 7.0, 8.5),
    ('SV002', 'KH001', 9.0, 8.0),
    ('SV002', 'KH003', 6.5, 7.5),
    ('SV003', 'KH002', 8.0, 9.5),
    ('SV003', 'KH004', 7.5, 8.0),
    ('SV004', 'KH001', 9.5, 9.0);
UPDATE Student
SET Email = 'hai.pham.new@stu.edu.vn'
WHERE StudentID = 'SV001';
UPDATE Course
SET Description = 'Khóa học Python từ cơ bản đến nâng cao, bao gồm thực hành dự án'
WHERE CourseID = 'KH001';
UPDATE Result
SET FinalScore = 9.5
WHERE StudentID = 'SV001'
    AND CourseID = 'KH001';
DELETE FROM Enrollment
WHERE StudentID = 'SV005'
    AND CourseID = 'KH005';
DELETE FROM Result
WHERE StudentID = 'SV005'
    AND CourseID = 'KH005';
SELECT *
FROM Student;
SELECT *
FROM Instructor;
SELECT *
FROM Course;
SELECT e.EnrollmentID,
    s.FullName AS SinhVien,
    c.CourseName AS KhoaHoc,
    e.EnrollmentDate
FROM Enrollment e
    JOIN Student s ON e.StudentID = s.StudentID
    JOIN Course c ON e.CourseID = c.CourseID;
SELECT r.ResultID,
    s.FullName AS SinhVien,
    c.CourseName AS KhoaHoc,
    r.MidtermScore AS DiemGiuaKy,
    r.FinalScore AS DiemCuoiKy,
    (r.MidtermScore * 0.4 + r.FinalScore * 0.6) AS DiemTongKet
FROM Result r
    JOIN Student s ON r.StudentID = s.StudentID
    JOIN Course c ON r.CourseID = c.CourseID;