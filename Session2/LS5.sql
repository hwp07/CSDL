-- Rủi ro
-- 1. 1user có nhiều ví
-- 2. số tiền bị âm
-- 3. giao dịch âm hoặc = 0
-- 4. giao dịch lung tung, không rõ ràng, không gắn với ví của user

CREATE TABLE WALLETS (
    wallet_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL UNIQUE,
    balance DECIMAL(15,2) NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    -- số dư không âm
    CONSTRAINT chk_wallet_balance CHECK (balance >= 0),

    -- liên kết khách hàng
    CONSTRAINT fk_wallet_customer
        FOREIGN KEY (customer_id)
        REFERENCES CUSTOMERS(CustomerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE TRANSACTIONS (
    transaction_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    wallet_id INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    -- số tiền phải > 0
    CONSTRAINT chk_transaction_amount CHECK (amount > 0),

    -- giao dịch hợp lệ
    CONSTRAINT chk_transaction_type CHECK (transaction_type IN ('DEPOSIT', 'WITHDRAW', 'PAYMENT')),

    -- trạng thái hợp lệ
    CONSTRAINT chk_transaction_status CHECK (status IN ('PENDING', 'SUCCESS', 'FAILED')),

    -- liên kết ví
    CONSTRAINT fk_transaction_wallet
        FOREIGN KEY (wallet_id)
        REFERENCES WALLETS(wallet_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);