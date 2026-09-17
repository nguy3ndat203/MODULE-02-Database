-- 1. Trigger BeforeInsertProduct
DELIMITER //

CREATE TRIGGER BeforeInsertProduct
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    IF NEW.quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Số lượng sản phẩm (quantity) không được nhỏ hơn 0!';
    END IF;
END //

DELIMITER ;

INSERT INTO products (productName, quantity) 
VALUES ('Sản phẩm lỗi', -5);

INSERT INTO products (productName, quantity) 
VALUES ('Sản phẩm chuẩn', 20);
