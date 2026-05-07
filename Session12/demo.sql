-- Active: 1777294904821@@127.0.0.1@3306@socialnetwork
CREATE DATABASE SocialNetwork;

USE SocialNetwork;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE
    posts (
        post_id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        content TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        is_deleted BOOLEAN DEFAULT FALSE,

-- REQ-07: Xóa user thì tự động xóa toàn bộ bài viết của user đó.
FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
    );

CREATE TABLE
    comments (
        comment_id INT AUTO_INCREMENT PRIMARY KEY,
        post_id INT NOT NULL,
        user_id INT NOT NULL,
        content TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

-- REQ-07: Xóa bài viết hoặc user thì tự động xóa comment liên quan.
FOREIGN KEY (post_id) REFERENCES posts (post_id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
    );

CREATE TABLE
    friends (
        user_id INT NOT NULL,
        friend_id INT NOT NULL,
        status ENUM ('pending', 'accepted', 'rejected') DEFAULT 'pending',
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (user_id, friend_id),

-- REQ-07: Xóa user thì tự động xóa quan hệ bạn bè liên quan.
FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
        FOREIGN KEY (friend_id) REFERENCES users (user_id) ON DELETE CASCADE,
        CHECK (user_id != friend_id)
    );

CREATE TABLE
    likes (
        user_id INT NOT NULL,
        post_id INT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (user_id, post_id),

-- REQ-07: Xóa user hoặc bài viết thì tự động xóa lượt like liên quan.
FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
        FOREIGN KEY (post_id) REFERENCES posts (post_id) ON DELETE CASCADE
    );

-- REQ-06: Tạo index tối ưu truy vấn newsfeed theo thời gian tạo bài viết.
CREATE INDEX idx_post_created_at ON posts (created_at);
INSERT INTO
    users (username, password, email)
VALUES (
        'DuongSo',
        'pass123',
        'Gnoudmal@example.com'
    ),
    (
        'AnhTC',
        'pass123',
        'anhtc@example.com'
    ),
    (
        'carol',
        'pass123',
        'carol@example.com'
    );

INSERT INTO
    posts (user_id, content)
VALUES (1, 'Nộp bài đi các em!'),
    (2, 'Nhớ meeting nhé!'),
    (
        3,
        'Hôm nay chúng ta học bài 12!'
    );

INSERT INTO
    likes (user_id, post_id)
VALUES (2, 1),
    (3, 1),
    (1, 2);

INSERT INTO
    comments (post_id, user_id, content)
VALUES (1, 2, 'Thầy Dương chất quá!'),
    (
        2,
        3,
        'Thầy ơi còn cứu được không ạ!'
    ),
    (
        3,
        1,
        'Thầy ơi, meeting nhưng quên gửi link ạ :(((.'
    );

INSERT INTO
    friends (user_id, friend_id, status)
VALUES (1, 2, 'accepted'),
    (1, 3, 'pending'),
    (2, 3, 'accepted');

-- REQ-01: View thông tin user cơ bản
CREATE VIEW vw_UserInfo AS
SELECT
    user_id,
    username,
    email,
    created_at
FROM users;

-- REQ-02: View thống kê tương tác,
-- vẫn hiển thị bài viết chưa có like/comment
CREATE VIEW vw_PostStatistics AS
SELECT
    p.post_id,
    p.content AS post_content,
    u.username AS author_username,
    COUNT(DISTINCT l.user_id) AS total_likes,
    COUNT(DISTINCT c.comment_id) AS total_comments
FROM
    posts p
    JOIN users u ON u.user_id = p.user_id
    LEFT JOIN likes l ON l.post_id = p.post_id
    LEFT JOIN comments c ON c.post_id = p.post_id
GROUP BY
    p.post_id,
    p.content,
    u.username;

-- REQ-03: Procedure đăng ký user mới,
-- chặn email trùng và báo lỗi
DELIMITER / /

CREATE PROCEDURE sp_RegisterUser (
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_email VARCHAR(100)
)
BEGIN
    DECLARE v_email_count INT DEFAULT 0;
    START TRANSACTION;
    SELECT COUNT(*)
    INTO v_email_count
    FROM users
    WHERE email = p_email;

    IF v_email_count > 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email đã được sử dụng';

    ELSE
        INSERT INTO users (
            username,
            password,
            email
        )
        VALUES (
            p_username,
            p_password,
            p_email
        );
        COMMIT;
    END IF;

END //
DELIMITER;

-- REQ-04: Procedure đăng bài mới
-- và trả về post_id vừa được cấp
DELIMITER / /
CREATE PROCEDURE sp_CreatePost (
    IN p_user_id INT,
    IN p_content TEXT,
    OUT p_post_id INT
)
BEGIN
    INSERT INTO posts (
        user_id,
        content
    )
    VALUES (
        p_user_id,
        p_content
    );
    SET p_post_id = LAST_INSERT_ID();

END //
DELIMITER;

-- REQ-05: Procedure lấy danh sách bạn bè
-- đã accepted theo limit/offset
DELIMITER / /
CREATE PROCEDURE sp_GetFriends (
    IN p_user_id INT,
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    SELECT
        u.username,
        u.email
    FROM friends f
    JOIN users u
        ON u.user_id = CASE
            WHEN f.user_id = p_user_id
                THEN f.friend_id
            ELSE f.user_id
        END
    WHERE (
        f.user_id = p_user_id
        OR f.friend_id = p_user_id
    )
    AND f.status = 'accepted'
    ORDER BY
        f.created_at DESC,
        u.user_id
    LIMIT p_limit
    OFFSET p_offset;
END //
DELIMITER;