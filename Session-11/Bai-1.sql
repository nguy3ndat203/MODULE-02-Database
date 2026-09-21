-- 1. Tạo bảng accounts
CREATE TABLE accounts (
    accountID INT AUTO_INCREMENT PRIMARY KEY,
    balance DECIMAL(10, 2) NOT NULL DEFAULT 0.00
);

-- Tạo bảng transactions
CREATE TABLE transactions (
    transactionID INT AUTO_INCREMENT PRIMARY KEY,
    fromAccountID INT NOT NULL,
    toAccountID INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    transactionDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_from_account FOREIGN KEY (fromAccountID) REFERENCES accounts(accountID),
    CONSTRAINT fk_to_account FOREIGN KEY (toAccountID) REFERENCES accounts(accountID)
);

-- 2. Thêm 10 tài khoản vào bảng accounts
INSERT INTO accounts (balance) VALUES 
(5000000.00),
(2000000.00),
(1500000.00),
(10000000.00),
(3500000.00),
(500000.00),
(8000000.00),
(1200000.00),
(4000000.00),
(6000000.00);

-- 3
SELECT * FROM accounts WHERE accountID = 1;

-- 4
START TRANSACTION;

-- Cộng thêm 1.000.000 VNĐ vào tài khoản có accountID = 1
UPDATE accounts 
SET balance = balance + 1000000.00 
WHERE accountID = 1;

-- Lưu thay đổi vào CSDL
COMMIT;

-- 5. Kiểm tra số dư
SELECT * FROM accounts WHERE accountID = 1;
