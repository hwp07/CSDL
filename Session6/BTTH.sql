-- Active: 1776147792947@@127.0.0.1@3306@csdl
USE csdl

CREATE TABLE User (
    userID INT AUTO_INCREMENT PRIMARY KEY,
    userName VARCHAR(50)
);

INSERT INTO
    User
VALUES (1, 'An'),
    (2, 'Binh'),
    (3, 'Cuong'),
    (4, 'Dung');

CREATE TABLE Hotel (
    hotelID INT AUTO_INCREMENT PRIMARY KEY,
    hotelName VARCHAR(100),
    starRating INT
)

INSERT INTO
    Hotel
VALUES (101, 'Vinpearl', 5),
    (102, 'Marriott', 5),
    (103, 'Novotel', 4),
    (104, 'Ibis', 3);

CREATE TABLE Bookings (
    bookingId INT AUTO_INCREMENT PRIMARY KEY,
    userID int,
    hotelID INT,
    total_price INT,
    status VARCHAR(20),
    FOREIGN KEY (userID) REFERENCES User (userID),
    FOREIGN KEY (hotelID) REFERENCES Hotel (hotelID)
);

INSERT INTO
    Bookings (
        bookingId,
        userID,
        hotelID,
        total_price,
        status
    )
VALUES (
        1,
        1,
        101,
        30000000,
        'COMPLETED'
    ),
    (
        2,
        1,
        102,
        25000000,
        'COMPLETED'
    ),
    (
        3,
        1,
        103,
        10000000,
        'COMPLETED'
    ),
    (
        4,
        2,
        103,
        30000000,
        'COMPLETED'
    ),
    (
        5,
        2,
        103,
        25000000,
        'COMPLETED'
    ),
    (
        6,
        3,
        101,
        60000000,
        'COMPLETED'
    ),
    (
        7,
        3,
        101,
        -20000000,
        'COMPLETED'
    ),
    (8, 4, 102, 80000000, 'FAILED');

SELECT
    u.userName AS customer_name,
    h.starRating,
    SUM(b.total_price) AS total_spent
FROM User u
    JOIN Bookings b ON u.userID = b.userID
    JOIN Hotel h ON b.hotelID = h.hotelID
WHERE
    b.status = 'COMPLETED'
    AND b.total_price > 0
GROUP BY
    u.userID,
    u.userName,
    h.starRating
HAVING
    SUM(b.total_price) > 50000000
ORDER BY h.starRating DESC, total_spent DESC;

SELECT * FROM user;

SELECT * FROM hotel;

SELECT * FROM bookings;

-- lấy tên khách hàng, hạng khách sạn, tổng tiền đã tiêu cho hạng đó