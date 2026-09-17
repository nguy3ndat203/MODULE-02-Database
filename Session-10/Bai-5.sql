-- 1. Tạo table orders
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL DEFAULT 'Pending'
);

-- 2. Tạo table order_logs
CREATE TABLE order_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_logs_orders 
        FOREIGN KEY (order_id) REFERENCES orders(id) 
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 3. Tạo Trigger after_order_status_update
DELIMITER //

CREATE TRIGGER after_order_status_update
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
	INSERT INTO order_logs (order_id, old_status, new_status)
	VALUES (NEW.id, OLD.status, NEW.status);
END //

DELIMITER ;


-- 4.1. Thêm một đơn hàng mới với trạng thái 'Pending'
INSERT INTO orders (customer_name, total_amount, status) 
VALUES ('Nguyen Van A', 1500000.00, 'Pending');

-- 4.2. Lần UPDATE 1
UPDATE orders 
SET status = 'Shipping' 
WHERE id = 1;

-- 4.3. Lần UPDATE 2
UPDATE orders 
SET customer_name = 'Nguyen Van A - Updated' 
WHERE id = 1;

-- 4.4. Kiểm tra kết quả trong bảng nhật ký order_logs
SELECT * FROM order_logs;
