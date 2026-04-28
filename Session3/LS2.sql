-- 1. Cấu trúc bảng ban đầu
CREATE TABLE SHIPPERS (
    ShipperID INT PRIMARY KEY AUTO_INCREMENT,
    ShipperName VARCHAR(255),
    Phone VARCHAR(20)
);
INSERT INTO SHIPPERS (ShipperName, Phone)
VALUES ('Giao Hàng Nhanh', '0901234567');
-- Thiếu dấu ' ở cuối VALUES ShipperName
INSERT INTO SHIPPERS (ShipperName, Phone)
VALUES ('Viettel Post', '0123456789');
-- Thiếu cột để truyền dữ liệu