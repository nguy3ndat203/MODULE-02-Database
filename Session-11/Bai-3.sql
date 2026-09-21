-- Tạo mới bảng transactions
CREATE TABLE IF NOT EXISTS transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    log_message VARCHAR(255),
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_transactions_accounts 
        FOREIGN KEY (account_id) REFERENCES accounts(account_id) 
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Tạo ID = 3 để kiểm thử
INSERT INTO accounts (account_id, customer_name, balance) 
VALUES (3, 'Nguyễn Văn An', 0.00)
ON DUPLICATE KEY UPDATE customer_name = 'Nguyễn Văn An';


-- 2. VIẾT STORED PROCEDURE deposit_with_logging
DELIMITER //

CREATE PROCEDURE deposit_with_logging(
    IN p_account_id INT,
    IN p_amount DECIMAL(15, 2)
)
BEGIN
    -- Nếu xảy ra bất kỳ lỗi SQL (SQLEXCEPTION), tự động ROLLBACK và báo lỗi
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Giao dịch thất bại! Đã khôi phục dữ liệu (ROLLBACK).' AS message;
    END;

    -- Bắt đầu Transaction
    START TRANSACTION;

    -- Bước 1: Cập nhật cộng thêm tiền vào bảng accounts
    UPDATE accounts 
    SET balance = balance + p_amount 
    WHERE account_id = p_account_id;

    -- Bước 2: Ghi vào bảng transactions
    INSERT INTO transactions (account_id, amount, log_message) 
    VALUES (p_account_id, p_amount, 'Nạp tiền vào tài khoản');

    -- Nếu không có lỗi xảy ra, tiến hành COMMIT
    COMMIT;
    SELECT 'Giao dịch thành công.' AS message;
END //

DELIMITER ;


-- 3. KIỂM THỬ (TESTING)
-- Gọi thủ tục để nạp 1.000.000 VNĐ cho tài khoản ID = 3
CALL deposit_with_logging(3, 1000000.00);

-- Kiểm tra bảng accounts xem tiền đã lên chưa
SELECT * FROM accounts WHERE account_id = 3;

-- Kiểm tra bảng transactions
SELECT * FROM transactions;
