INSERT INTO accounts (account_id, customer_name, balance) 
VALUES 
    (4, 'Nguyễn Văn Tam', 2000000.00),
    (5, 'Nguyễn Văn Tứ', 0.00)
ON DUPLICATE KEY UPDATE balance = VALUES(balance);


-- 2. VIẾT STORED PROCEDURE transfer_money
DELIMITER //

CREATE PROCEDURE transfer_money(
    IN p_sender_id INT,
    IN p_receiver_id INT,
    IN p_amount DECIMAL(15, 2)
)
BEGIN
    DECLARE v_sender_balance DECIMAL(15, 2);

    -- Tự động ROLLBACK khi gặp bất kỳ lỗi SQL nào
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Giao dịch thất bại: Lỗi hệ thống SQL!' AS message;
    END;

    -- Bắt đầu Transaction
    START TRANSACTION;

    -- Kiểm tra số dư tài khoản người gửi
    SELECT balance INTO v_sender_balance 
    FROM accounts 
    WHERE account_id = p_sender_id;

    -- Kiểm tra điều kiện đủ tiền
    IF v_sender_balance IS NULL THEN
        ROLLBACK;
        SELECT 'Tài khoản người gửi không tồn tại!' AS message;
    ELSEIF v_sender_balance < p_amount THEN
        ROLLBACK;
        SELECT 'Số dư người gửi không đủ để thực hiện giao dịch!' AS message;
    ELSE
        -- Trừ tiền người gửi
        UPDATE accounts 
        SET balance = balance - p_amount 
        WHERE account_id = p_sender_id;

        -- Cộng tiền người nhận
        UPDATE accounts 
        SET balance = balance + p_amount 
        WHERE account_id = p_receiver_id;

        -- Xác nhận giao dịch
        COMMIT;
        SELECT 'Chuyển tiền thành công!' AS message;
    END IF;
END //

DELIMITER ;


-- 3. TESTING

-- Thực hiện chuyển 300.000 VNĐ từ ID 4 sang ID 5
CALL transfer_money(4, 5, 300000.00);

-- Kiểm tra kết quả số dư của cả hai tài khoản (A còn 1.700.000, B có 300.000)
SELECT * FROM accounts WHERE account_id IN (4, 5);
