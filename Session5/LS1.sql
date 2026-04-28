-- Active: 1776147792947@@127.0.0.1@3306@csdl

SELECT restaurant_name, address, rating
FROM Restaurants
WHERE
    district IN ('Quận 1', 'Quận 3')
    AND rating > 4.0;