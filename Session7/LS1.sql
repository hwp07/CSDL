SELECT title, price
FROM course
WHERE
    price IN (
        SELECT price
        FROM course
        WHERE
            instructor_id = 5
    );

-- sử dụng toán tử "=" khi chắc chắn subquery trả về 1 dòng duy nhất => thay thế bằng "IN" => trả về nhiều dòng