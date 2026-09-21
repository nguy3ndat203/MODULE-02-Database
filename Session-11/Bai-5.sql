-- 1. THIẾT KẾ DATABASE

-- Tạo bảng products
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

-- Tạo bảng orders
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_products 
        FOREIGN KEY (product_id) REFERENCES products(id) 
        ON UPDATE CASCADE ON DELETE RESTRICT
);


-- 2. TẠO DỮ LIỆU MẪU
INSERT INTO products (id, product_name, price, stock) 
VALUES (1, 'Laptop Gaming', 20000000.00, 10)


-- 3. VIẾT STORED PROCEDURE place_order
DELIMITER //

CREATE PROCEDURE place_order(
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_stock INT;
    DECLARE v_price DECIMAL(10, 2);

    -- Cơ chế bảo vệ: Tự động ROLLBACK khi gặp bất kỳ lỗi SQL bất ngờ nào
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Giao dịch thất bại do lỗi hệ thống! Đã hoàn tác (ROLLBACK).' AS message;
    END;

    -- Bắt đầu Transaction
    START TRANSACTION;

    -- Kiểm tra tồn kho và lấy giá sản phẩm
    SELECT stock, price INTO v_stock, v_price
    FROM products
    WHERE id = p_product_id;

    -- Kiểm tra sự tồn tại của sản phẩm và lượng tồn kho
    IF v_stock IS NULL THEN
        ROLLBACK;
        SELECT 'Sản phẩm không tồn tại!' AS message;
    ELSEIF v_stock >= p_quantity THEN
        -- Bước 1: Trừ số lượng tồn kho trong bảng products
        UPDATE products 
        SET stock = stock - p_quantity 
        WHERE id = p_product_id;

        -- Bước 2: Tạo bản ghi mới trong bảng orders 
        INSERT INTO orders (product_id, quantity, total_price) 
        VALUES (p_product_id, p_quantity, v_price * p_quantity);

        -- COMMIT giao dịch và thông báo
        COMMIT;
        SELECT 'Đặt hàng thành công!' AS message;
    ELSE
        -- Tồn kho < số lượng mua -> ROLLBACK và thông báo
        ROLLBACK;
        SELECT 'Số lượng hàng không đủ' AS message;
    END IF;
END //

DELIMITER ;


-- 4. KIỂM THỬ (TESTING)
-- Kiểm tra trước khi mua
SELECT * FROM products;

-- Trường hợp 1 (Thành công): Mua 2 chiếc Laptop
CALL place_order(1, 2);

-- Kiểm tra bảng products (Kho còn 8) và bảng orders (Đã có bản ghi)
SELECT * FROM products WHERE id = 1;
SELECT * FROM orders;

-- Trường hợp 2 (Thất bại): Mua 20 chiếc Laptop (vượt quá tồn kho)
CALL place_order(1, 20);

-- Kiểm tra bảng products (Kho vẫn còn 8) và bảng orders (Không tạo thêm bản ghi mới)
SELECT * FROM products WHERE id = 1;
SELECT * FROM orders;
