-- 1. Tạo bảng accounts
CREATE TABLE IF NOT EXISTS accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100),
    balance DECIMAL(10, 2) NOT NULL DEFAULT 0.00
);

INSERT INTO accounts (id, customer_name, balance) 
VALUES (2, 'Nguyen Van Dat', 300000.00)
ON DUPLICATE KEY UPDATE balance = 300000.00;

-- 2. Định nghĩa Stored Procedure
DELIMITER //

CREATE PROCEDURE withdraw_money(
    IN p_account_id INT,
    IN p_amount DECIMAL(10, 2)
)
BEGIN
    DECLARE v_current_balance DECIMAL(10, 2);

    -- 1. Bắt đầu giao dịch
    START TRANSACTION;

    -- 2. Thực hiện trừ tiền trong tài khoản
    UPDATE accounts 
    SET balance = balance - p_amount 
    WHERE id = p_account_id;

    -- 3. Kiểm tra số dư hiện tại sau khi trừ
    SELECT balance INTO v_current_balance 
    FROM accounts 
    WHERE id = p_account_id;

    -- 4. Điều kiện ROLLBACK hoặc COMMIT
    IF v_current_balance < 0 THEN
        ROLLBACK;
        SELECT CONCAT('Giao dịch thất bại! Số dư không đủ. Tài khoản còn: ', v_current_balance + p_amount, ' VNĐ') AS message;
    ELSE
        COMMIT;
        SELECT CONCAT('Rút tiền thành công! Số dư còn lại: ', v_current_balance, ' VNĐ') AS message;
    END IF;
END //

DELIMITER ;


-- TH1: Rút 500.000 từ tài khoản có 300.000
CALL withdraw_money(2, 500000);
-- Kiểm tra lại số dư (Mong muốn: Vẫn còn 300.000 VNĐ)
SELECT * FROM accounts WHERE id = 2;

-- TH2: Rút 500.000 từ tài khoản đó
CALL withdraw_money(2, 100000);
-- Kiểm tra lại số dư (Mong muốn: Còn 200.000 VNĐ)
SELECT * FROM accounts WHERE id = 2;
