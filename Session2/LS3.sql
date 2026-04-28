-- PHÂN TÍCH
-- order_id: kiểu dữ liệu INT, rành buộc PRIMARY KEY, AUTO_INCREMENT
-- order_date: kiểu dữ liệu DATE, ràng buộc NOT NULL, DEFAULT CURRENT_DATE (tự động lấy ngày hiện tại nếu không nhập)
-- total_amount: kiểu dữ liệu DECIMAL(15,2), ràng buộc NOT NULL, DEFAULT 0.00
-- customer_id: kiểu dữ liệu INT, ràng buộc NOT NULL, FOREIGN KEY tham chiếu đến CUSTOMERS(customer_id)

CREATE TABLE CUSTOMERS (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Age INT CHECK (Age >= 0)
);

CREATE TABLE ORDERS (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    OrderDate DATE DEFAULT CURRENT_DATE,
    TotalAmount DECIMAL(10,2) CHECK (TotalAmount >= 0),
    CustomerID INT NOT NULL,

    CONSTRAINT fk_customer
        FOREIGN KEY (CustomerID)
        REFERENCES CUSTOMERS(CustomerID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);