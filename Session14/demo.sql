-- transaction
-- START TRANSACTION
-- SQL COMMANDS
-- ROLLBACK / COMMIT;

USE students_management;

START TRANSACTION;
-- thêm lớp CNTT2
-- thêm sinh viên Quang Minh và cho vào lớp CNTT2
INSERT INTO
    students
VALUES (
        150000,
        'nguyen quang minh',
        'nqm@gmail.com',
        18,
        '2026-02-02',
        8,
        7.7
    );

SELECT classId INTO v_classId FROM classrooms WHERE classId = 8;

SELECT studentId INTO v_studentId
FROM students
WHERE
    studentId = 150000;

IF(v_classId IS NULL) OR (v_studentId IS NULL) THEN ROLLBACK;

COMMIT;