CREATE DATABASE IF NOT EXISTS InventoryManagement;
USE InventoryManagement;

-- Bước 1 tạo bảng Products
CREATE TABLE Products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL
);

-- Bước 2 tạo bảng InventoryChanges
CREATE TABLE InventoryChanges (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    old_quantity INT NOT NULL,
    new_quantity INT NOT NULL,
    change_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(id)
);


-- Bước 3 tạo trigger AfterProductUpdate
DELIMITER //

CREATE TRIGGER AfterProductUpdate
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    -- Ghi lại thông tin thay đổi vào bảng InventoryChanges
    INSERT INTO InventoryChanges (product_id, old_quantity, new_quantity)
    VALUES (NEW.id, OLD.quantity, NEW.quantity);
END //

DELIMITER ;

-- Bước 4 thêm dữ liệu vào bảng Products

INSERT INTO Products (name, quantity) VALUES
('Product test 1', 555),
('Product test 2', 333),
('Product test 3', 215);

-- Bước 5 Cập nhật quantity

UPDATE Products SET quantity = 280 WHERE name = 'Product test 1';

UPDATE Products SET quantity = 330 WHERE name = 'Product test 2';


-- Bước 6 : Kiểm tra kết quả
SELECT * FROM InventoryChanges;
