--cột room_name trong câu lệnh select vi phạm về mặt toán học vì:
-- bài toán đang yêu cầu trả về 1 nhóm dữ liệu nhưng room_name k làm được vì k có giá trị đại diện cho 1 nhóm.

-- câu lệnh hoàn chỉnh:
SELECT hotel_id, MIN(price_per_night)
FROM Rooms
GROUP BY
    hotel_id;
-- => không cần lấy room_name nữa