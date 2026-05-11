<<<<<<< HEAD
CREATE TABLE Price_Changes_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_id INT NOT NULL,
    old_price DECIMAL(18,2) NOT NULL,
    new_price DECIMAL(18,2) NOT NULL,
    change_type VARCHAR(20) NOT NULL,
    difference DECIMAL(18,2) NOT NULL,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (medicine_id)
    REFERENCES Medicines(medicine_id)
);

DELIMITER //

CREATE TRIGGER TrackMedicinePriceChanges
BEFORE UPDATE
ON Medicines
FOR EACH ROW
BEGIN

    DECLARE v_difference DECIMAL(18,2);

    -- Chặn giá không hợp lệ
    IF NEW.price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Giá thuốc mới không hợp lệ';
    END IF;

    -- Trường hợp tăng giá
    IF NEW.price > OLD.price THEN

        SET v_difference = NEW.price - OLD.price;

        INSERT INTO Price_Changes_Log(
            medicine_id,
            old_price,
            new_price,
            change_type,
            difference
        )
        VALUES(
            OLD.medicine_id,
            OLD.price,
            NEW.price,
            'TĂNG GIÁ',
            v_difference
        );

    END IF;

    -- Trường hợp giảm giá
    IF NEW.price < OLD.price THEN

        SET v_difference = OLD.price - NEW.price;

        INSERT INTO Price_Changes_Log(
            medicine_id,
            old_price,
            new_price,
            change_type,
            difference
        )
        VALUES(
            OLD.medicine_id,
            OLD.price,
            NEW.price,
            'GIẢM GIÁ',
            v_difference
        );

    END IF;

END //

DELIMITER ;DELIMITER //

CREATE TRIGGER TrackMedicinePriceChanges
BEFORE UPDATE
ON Medicines
FOR EACH ROW
BEGIN
    DECLARE v_difference DECIMAL(18,2);
    -- Chặn giá không hợp lệ
    IF NEW.price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Giá thuốc mới không hợp lệ';
    END IF;

    -- Trường hợp tăng giá
    IF NW.price > OLD.price THEN
        SET v_difference = NEW.price - OLD.price;
        INSERT INTO Price_Changes_Log(
            medicine_id,
            old_price,
            new_price,
            change_type,
            difference
        )
        VALUES(
            OLD.medicine_id,
            OLD.price,
            NEW.price,
            'TĂNG GIÁ',
            v_difference
        );
    END IF;
    -- Trường hợp giảm giá
    IF NEW.price < OLD.price THEN
        SET v_difference = OLD.price - NEW.price;
        INSERT INTO Price_Changes_Log(
            medicine_id,
            old_price,
            new_price,
            change_type,
            difference
        )
        VALUES(
            OLD.medicine_id,
            OLD.price,
            NEW.price,
            'GIẢM GIÁ',
            v_difference
        );
    END IF;
END //
DELIMITER ;


-- test 1
UPDATE Medicines
SET price = 18000
WHERE medicine_id = 1;

-- tét 2
UPDATE Medicines
SET price = 12000
WHERE medicine_id = 1;

-- test 3
UPDATE Medicines
SET stock = 200
WHERE medicine_id = 1;

-- lấy dữ liệu bảng log
SELECT *
=======
CREATE TABLE Price_Changes_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_id INT NOT NULL,
    old_price DECIMAL(18,2) NOT NULL,
    new_price DECIMAL(18,2) NOT NULL,
    change_type VARCHAR(20) NOT NULL,
    difference DECIMAL(18,2) NOT NULL,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (medicine_id)
    REFERENCES Medicines(medicine_id)
);

DELIMITER //

CREATE TRIGGER TrackMedicinePriceChanges
BEFORE UPDATE
ON Medicines
FOR EACH ROW
BEGIN

    DECLARE v_difference DECIMAL(18,2);

    -- Chặn giá không hợp lệ
    IF NEW.price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Giá thuốc mới không hợp lệ';
    END IF;

    -- Trường hợp tăng giá
    IF NEW.price > OLD.price THEN

        SET v_difference = NEW.price - OLD.price;

        INSERT INTO Price_Changes_Log(
            medicine_id,
            old_price,
            new_price,
            change_type,
            difference
        )
        VALUES(
            OLD.medicine_id,
            OLD.price,
            NEW.price,
            'TĂNG GIÁ',
            v_difference
        );

    END IF;

    -- Trường hợp giảm giá
    IF NEW.price < OLD.price THEN

        SET v_difference = OLD.price - NEW.price;

        INSERT INTO Price_Changes_Log(
            medicine_id,
            old_price,
            new_price,
            change_type,
            difference
        )
        VALUES(
            OLD.medicine_id,
            OLD.price,
            NEW.price,
            'GIẢM GIÁ',
            v_difference
        );

    END IF;

END //

DELIMITER ;DELIMITER //

CREATE TRIGGER TrackMedicinePriceChanges
BEFORE UPDATE
ON Medicines
FOR EACH ROW
BEGIN
    DECLARE v_difference DECIMAL(18,2);
    -- Chặn giá không hợp lệ
    IF NEW.price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Giá thuốc mới không hợp lệ';
    END IF;

    -- Trường hợp tăng giá
    IF NW.price > OLD.price THEN
        SET v_difference = NEW.price - OLD.price;
        INSERT INTO Price_Changes_Log(
            medicine_id,
            old_price,
            new_price,
            change_type,
            difference
        )
        VALUES(
            OLD.medicine_id,
            OLD.price,
            NEW.price,
            'TĂNG GIÁ',
            v_difference
        );
    END IF;
    -- Trường hợp giảm giá
    IF NEW.price < OLD.price THEN
        SET v_difference = OLD.price - NEW.price;
        INSERT INTO Price_Changes_Log(
            medicine_id,
            old_price,
            new_price,
            change_type,
            difference
        )
        VALUES(
            OLD.medicine_id,
            OLD.price,
            NEW.price,
            'GIẢM GIÁ',
            v_difference
        );
    END IF;
END //
DELIMITER ;


-- test 1
UPDATE Medicines
SET price = 18000
WHERE medicine_id = 1;

-- tét 2
UPDATE Medicines
SET price = 12000
WHERE medicine_id = 1;

-- test 3
UPDATE Medicines
SET stock = 200
WHERE medicine_id = 1;

-- lấy dữ liệu bảng log
SELECT *
>>>>>>> 7bc2ad5a2051fb05dbe60a936b4b140158e4c1d6
FROM Price_Changes_Log;