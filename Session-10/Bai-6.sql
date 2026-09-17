-- 1. Tạo cart_items
CREATE TABLE cart_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    CONSTRAINT fk_cart_products 
        FOREIGN KEY (product_id) REFERENCES products(productID) 
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 2. Tạo Trigger before_cart_add
DELIMITER //

CREATE TRIGGER before_cart_add
BEFORE INSERT ON cart_items
FOR EACH ROW
BEGIN
    DECLARE v_stock INT;

    -- Lấy số lượng tồn kho (quantity) của sản phẩm trong bảng products
    SELECT quantity INTO v_stock
    FROM products
    WHERE productID = NEW.product_id;

    -- Kiểm tra số lượng mua với tồn kho
    IF NEW.quantity > v_stock THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số lượng hàng trong kho không đủ';
    END IF;
END //

DELIMITER ;

-- 3
INSERT INTO products (productName, quantity) 
VALUES ('iPhone 15', 5);

-- TH 1: Thêm vào giỏ hàng số lượng 2 (Hợp lệ -> Thành công)
INSERT INTO cart_items (product_id, quantity) VALUES (1, 2);

-- Kiểm tra giỏ hàng
SELECT * FROM cart_items;

-- Trường hợp 2: Thêm vào giỏ hàng số lượng 10 (Không hợp lệ -> Bị chặn và báo lỗi)
INSERT INTO cart_items (product_id, quantity) VALUES (1, 10);
