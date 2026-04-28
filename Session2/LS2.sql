CREATE TABLE CUSTOMERS (
	CustomerID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100), 
    Age INT
)

-- fullname cần thêm NOT NULL
-- cần thêm ràng buộc cho email để tránh bị crash, sử dụng UNIQUE để không bị trùng
-- age cần thêm check âm/dương, số tuổi quá lớn


ALTER TABLE CUSTOMERS
MODIFY COLUMN FullName VARCHAR(100) NOT NULL;

ALTER TABLE CUSTOMERS
MODIFY COLUMN Email VARCHAR(100) NOT NULL;

ALTER TABLE CUSTOMERS
ADD CONSTRAINT uq_customers_email UNIQUE (Email);

ALTER TABLE CUSTOMERS
ADD CONSTRAINT chk_customers_age CHECK (Age >= 0 AND Age <= 150);