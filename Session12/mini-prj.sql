-- Active: 1777294904821@@127.0.0.1@3306@social_network
CREATE DATABASE social_network;

USE social_network;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_post_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);

CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    user_id INT,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_comment_post FOREIGN KEY (post_id) REFERENCES posts (post_id) ON DELETE CASCADE,
    CONSTRAINT fk_comment_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);

CREATE TABLE friends (
    user_id INT,
    friend_id INT,
    status ENUM('pending', 'accepted') NOT NULL,
    PRIMARY KEY (user_id, friend_id),
    CONSTRAINT chk_no_self_friend CHECK (user_id <> friend_id),
    CONSTRAINT fk_friend_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    CONSTRAINT fk_friend_user2 FOREIGN KEY (friend_id) REFERENCES users (user_id) ON DELETE CASCADE
);

CREATE TABLE likes (
    user_id INT,
    post_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, post_id),
    CONSTRAINT fk_like_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    CONSTRAINT fk_like_post FOREIGN KEY (post_id) REFERENCES posts (post_id) ON DELETE CASCADE
);

CREATE INDEX idx_post_created_at ON posts (created_at);

CREATE INDEX idx_post_user ON posts (user_id);

CREATE INDEX idx_comment_post ON comments (post_id);

CREATE INDEX idx_like_post ON likes (post_id);

CREATE VIEW vw_userinfo AS
SELECT
    user_id,
    username,
    email,
    created_at
FROM users;

CREATE VIEW vw_poststatistics AS
SELECT
    p.post_id,
    p.content,
    u.username,
    IFNULL(l.total_likes, 0) AS total_likes,
    IFNULL(c.total_comments, 0) AS total_comments
FROM
    posts p
    JOIN users u ON p.user_id = u.user_id
    LEFT JOIN (
        SELECT post_id, COUNT(*) AS total_likes
        FROM likes
        GROUP BY
            post_id
    ) l ON p.post_id = l.post_id
    LEFT JOIN (
        SELECT post_id, COUNT(*) AS total_comments
        FROM comments
        GROUP BY
            post_id
    ) c ON p.post_id = c.post_id;

DELIMITER / /

CREATE PROCEDURE sp_adduser (
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_email VARCHAR(100)
)
BEGIN
    DECLARE user_count INT;
    START TRANSACTION;
    SELECT COUNT(*) INTO user_count
    FROM users
    WHERE email = p_email;

    IF user_count > 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email da duoc su dung';

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

DELIMITER / /

CREATE PROCEDURE sp_createpost (
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

DELIMITER / /

CREATE PROCEDURE sp_getfriends (
    IN p_user_id INT,
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    SELECT 
        u.user_id,
        u.username,
        u.email

    FROM friends f

    JOIN users u
        ON u.user_id = f.friend_id

    WHERE f.user_id = p_user_id
        AND f.status = 'accepted'

    LIMIT p_limit OFFSET p_offset;
END //

DELIMITER;

CALL sp_adduser (
    'user1',
    'hashed_password_1',
    'user1@gmail.com'
);

CALL sp_adduser (
    'user2',
    'hashed_password_2',
    'user2@gmail.com'
);

SET @new_post_id = 0;

CALL sp_createpost (
    1,
    'Hello Social Network!',
    @new_post_id
);

SELECT @new_post_id;

INSERT INTO
    friends (user_id, friend_id, status)
VALUES (1, 2, 'accepted');

INSERT INTO
    comments (post_id, user_id, content)
VALUES (1, 2, 'Nice post!');

INSERT INTO
    likes (user_id, post_id)
VALUES (2, 1);

CALL sp_getfriends (1, 10, 0);

SELECT * FROM vw_userinfo;

SELECT * FROM vw_poststatistics;