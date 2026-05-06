-- Bảng Khoa
CREATE TABLE Departments (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(100)
);

-- Bảng Hóa đơn (Kết nối bệnh nhân và khoa)
CREATE TABLE Invoices (
    Invoice_ID INT PRIMARY KEY,
    Patient_ID INT,
    Dept_ID INT,
    Amount DECIMAL(10, 2),

    Foreign Key (Dept_ID) REFERENCES Departments (Dept_ID)
);

-- Chèn dữ liệu mẫu
INSERT INTO Departments VALUES (1, 'Nội'), (2, 'Ngoại');
INSERT INTO Invoices VALUES (101, 1, 1, 500.00), (102, 2, 1, 300.00), (103, 3, 2, 1000.00);

CREATE VIEW Department_Revenue_View  AS
SELECT d.Dept_Name, COUNT(i.Patient_ID), SUM(i.Amount) AS total
FROM Departments d
    JOIN Invoices i ON i.Dept_ID = d.Dept_ID
GROUP BY d.Dept_ID, d.Dept_Name;

SELECT * FROM Department_Revenue_View;

UPDATE department_revenue_view
SET total = total * 1.1
WHERE Patient_ID = 1;
-- báo lỗi: The target table department_revenue_view of the UPDATE is not updatable