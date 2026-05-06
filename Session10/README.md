So sánh hiệu năng giữa việc đánh 2 Index đơn độc lập và 1 Composite Index trên cả 2 cột (Drug_Name, Expiry_Date).
    - Với Index đơn khi sử dụng EXPLAIN: 
        + type: ALL hoặc index merge
        + rows: rất lớn (scan nhiều)

    - Với Composite Index khi sử dụng EXPLAIN:
        + type: range hoặc ref
        + key: idx_drug_expiry
        + rows: giảm mạnh
    => Composite Index giúp giảm số dòng cần đọc -> tăng tốc độ cực nhanh.


Hiện tượng Index bị "vô hiệu hóa" khi sử dụng LIKE '%keyword%':
    - Khi sử dụng câu truy vấn:
        SELECT * FROM Pharmacy_Inventory
        WHERE Drug_Name LIKE '%para%';
    => dẫn đến lỗi hiệu năng, thời gian lâu, tăng bộ nhớ vì:
        + Index là cấu trúc dạng B-Tree
        + Nó chỉ tìm nhanh khi biết bắt đầu từ đâu, nhưng '%para%' lại không biết bắt đầu từ đâu => scan toàn bộ => lỗi hiệu năng

    - Cách khắc phục: 'para%' => Index hoạt động lại bình thường

TÓM LẠI:
    - Index đơn:
        + Tốt cho query đơn giản
        + Kém hiệu quả khi nhiều điều kiện

    - Composite Index:
        + Tối ưu cho query multi-condition
        + Giảm I/O cực mạnh
        + Phải tuân thủ left-most rule

    - LIKE '%keyword%':
        + Phá index
        + Gây full scan

    - Giải pháp:
        + LIKE 'prefix%'
