-- 1. Trigger BeforeProductDelete
DELIMITER //

CREATE TRIGGER BeforeProductDelete
BEFORE DELETE ON products
FOR EACH ROW
BEGIN
    IF OLD.quantity > 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Không thể xóa sản phẩm có số lượng lớn hơn 10!';
    END IF;
END //

DELIMITER ;


INSERT INTO products (productName, quantity) VALUES 
('Sản phẩm A', 5),   -- Nhỏ hơn 10 (cho phép xóa)
('Sản phẩm B', 15);  -- Lớn hơn 10 (bị chặn xóa)

-- Giả sử xóa 'Sản phẩm B' có productID = 2
DELETE FROM products WHERE productID = 2;

-- Giả sử xóa 'Sản phẩm A' có productID = 1
DELETE FROM products WHERE productID = 1;
