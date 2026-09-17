-- 1. Tạo Cơ sở dữ liệu InventoryManagement
CREATE DATABASE IF NOT EXISTS InventoryManagement;
USE InventoryManagement;

-- 2. Tạo bảng products
CREATE TABLE products (
    productID INT AUTO_INCREMENT PRIMARY KEY,
    productName VARCHAR(100) NOT NULL,
    quantity INT NOT NULL DEFAULT 0
);

-- 3. Tạo bảng inventoryChanges
CREATE TABLE inventoryChanges (
    changeID INT AUTO_INCREMENT PRIMARY KEY,
    productID INT NOT NULL,
    oldQuantity INT,
    newQuantity INT,
    changeDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_inventory_products 
        FOREIGN KEY (productID) REFERENCES products(productID) 
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 4. Tạo Trigger AfterProductUpdate
DELIMITER //

CREATE TRIGGER AfterProductUpdate
AFTER UPDATE ON products
FOR EACH ROW
BEGIN

    INSERT INTO inventoryChanges (productID, oldQuantity, newQuantity, changeDate)
    VALUES (NEW.productID, OLD.quantity, NEW.quantity, NOW());
END //

DELIMITER ;


INSERT INTO Products (name, quantity) VALUES
('Product test A', 100),
('Product test B', 150),
('Product test C', 200);

-- Bước 5 
-- Cập nhật số lượng cho Product test A từ 100 sang 120
UPDATE Products SET quantity = 120 WHERE name = 'Product test A';

-- Cập nhật số lượng cho Product test B từ 150 sang 130
UPDATE Products SET quantity = 130 WHERE name = 'Product test B';


-- Bước 6 : Kiểm tra kết quả
SELECT * FROM InventoryChanges;
