-- 1. Tạo bảng khách hàng với hàng chục cột (mô phỏng bảng lớn)
CREATE TABLE CUSTOMERS (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(50),
    LastPurchaseDate DATE,
    -- Ngày mua hàng cuối cùng
    Status VARCHAR(20),
    -- Trạng thái tài khoản (Active, Locked...)
    Gender VARCHAR(10),
    DateOfBirth DATE,
    Points INT,
    Address VARCHAR(255)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- 2. Dữ liệu mẫu với các "Bẫy dữ liệu"
-- Lưu ý: Trong MySQL không cần tiền tố N' trước các chuỗi tiếng Việt
INSERT INTO
    CUSTOMERS (
        FullName,
        Email,
        City,
        LastPurchaseDate,
        Status
    )
VALUES (
        'Nguyễn Văn A',
        'a@gmail.com',
        'Hà Nội',
        '2025-05-20',
        'Active'
    ),
    -- Khách tiềm năng (hơn 6 tháng)
    (
        'Trần Thị B',
        'btt@gmail.com',
        'Hà Nội',
        '2026-02-10',
        'Active'
    ),
    -- Mới mua (loại)
    (
        'Lê Văn C',
        NULL,
        'Hà Nội',
        '2025-01-15',
        'Active'
    ),
    -- Lỗi: Không có Email
    (
        'Phạm Minh D',
        'dpm@gmail.com',
        'Hà Nội',
        '2024-12-01',
        'Locked'
    ),
    -- Lỗi: Tài khoản bị khóa
    (
        'Hoàng An E',
        'eha@gmail.com',
        'TP HCM',
        '2025-03-01',
        'Active'
    );

-- Lỗi: Sai thành phố

-- Phân tích
-- input: bảng CUSTOMER,
-- cột City,
-- LastPurchaseDate,
-- Email,Status

-- outout:FullName,Email

-- việc sử dụng SELECT * sẽ gây ngốn RAM, làm chậm quá trình query vì bảng có hàng triệu record + hàng chục cột => gây ra hiện tượng tắc nghẽn cổ chai (bottleneck)
-- giải pháp: chỉ cần lấy những gì cần thiết

-- logic lọc dữ liệu:
-- khách ở HN => city = 'HN'
-- Không mua hàng hơn 6 tháng (tính từ 01/04/2026) => LastPurchaseDate < '2025-10-01'

SELECT FullName, Email
FROM CUSTOMERS
WHERE
    City = 'Hà Nội'
    AND LastPurchaseDate < '2025-10-01'
    AND Email IS NOT NULL
    AND Status = 'Active';