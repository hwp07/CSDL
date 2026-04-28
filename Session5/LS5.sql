SELECT
    full_name AS Ten_Khach_Hang,
    CASE
        WHEN COALESCE(total_orders, 0) > 500 THEN 'Kim Cương'
        WHEN COALESCE(total_orders, 0) BETWEEN 100 AND 500  THEN 'Vàng'
        ELSE 'Bạc'
    END AS Xep_Hang
FROM Users;