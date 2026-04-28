CREATE TABLE PRODUCTS (
    ID INT PRIMARY KEY IDENTITY(1,1), -- thêm id tự tăng tránh bị trùng
    ProductName VARCHAR(100) NOT NULL, -- kích thước phù hợp
    Price DECIMAL(18,4) NOT NULL, -- chính xác hơn
    Description VARCHAR(500) -- dùng VARCHAR thay vì TEXT
);