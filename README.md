Sự khác biệt giữa UNION và UNION ALL:
    + UNION ALL (Lựa chọn trong bài toán này): Gộp toàn bộ dữ liệu từ hai bảng mà không kiểm tra trùng lặp. Vì hệ thống bệnh viện cần đảm bảo không mất dữ liệu, UNION ALL là lựa chọn chính xác. Ngay cả khi Record_ID bị trùng (do hai chi nhánh đánh số độc lập), cả hai bản ghi vẫn xuất hiện trong View

    + UNION: Sẽ thực hiện thêm một bước kiểm tra và loại bỏ các dòng có dữ liệu giống hệt nhau giữa hai bảng. Điều này làm tốn tài nguyên hệ thống (CPU/RAM) để so sánh và có thể gây mất dữ liệu nếu vô tình có hai bệnh nhân khác nhau nhưng trùng các thông tin trong bảng

Vấn đề xung đột ID:
Trong View này, dữ liệu không bị mất. Việc thêm cột ảo Branch_Name giúp định danh nguồn gốc dữ liệu, biến cặp giá trị (Record_ID, Branch_Name) thành một "khóa chính logic" mới để phân biệt các bản ghi trùng ID vật lý