-- khi sử dụng NOT IN + NULL => hệ thống sẽ hiểu thành roomId != a AND roomId != b AND roomId != NULL nhưng lúc này roomId cũng chưa biết đúng hay sai = > UNKNOWN; mà trong WHERE lại chỉ lấy TRUE = > loại hết, 0 có dữ liệu

-- cách khắc phục: sử dụng LEFT JOIN + IS NULL

SELECT r.room_id, r.room_name
FROM Rooms r
    LEFT JOIN Bookings b ON r.room_id = b.room_id
WHERE
    b.room_id IS NULL;