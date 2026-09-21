-- 1. CẬP NHẬT CẤU TRÚC BẢNG orders
ALTER TABLE orders 
ADD COLUMN status VARCHAR(50) NOT NULL DEFAULT 'Completed';

-- Cập nhật các đơn hàng cũ thành trạng thái 'Completed'
UPDATE orders 
SET status = 'Completed' 
WHERE status IS NULL OR status = '';


-- 2. VIẾT STORED PROCEDURE cancel_order
DELIMITER //

CREATE PROCEDURE cancel_order(
    IN p_order_id INT
)
BEGIN
    DECLARE v_product_id INT;
    DECLARE v_quantity INT;
    DECLARE v_current_status VARCHAR(50);

    -- Tự động ROLLBACK nếu xảy ra lỗi SQL bất ngờ
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Hủy đơn hàng thất bại do lỗi hệ thống!' AS message;
    END;

    -- Kiểm tra đơn hàng có tồn tại và lấy thông tin trạng thái, sản phẩm
    SELECT product_id, quantity, status 
    INTO v_product_id, v_quantity, v_current_status
    FROM orders 
    WHERE id = p_order_id;

    -- Kiểm tra điều kiện hợp lệ để hủy
    IF v_current_status IS NULL THEN
        SELECT 'Lỗi: Đơn hàng không tồn tại!' AS message;
    ELSEIF v_current_status = 'Cancelled' THEN
        SELECT 'Lỗi: Đơn hàng này đã bị hủy trước đó!' AS message;
    ELSE
        -- Bắt đầu Transaction để đảm bảo tính toàn vẹn dữ liệu
        START TRANSACTION;

        -- Bước 1 & 2: Cập nhật trạng thái đơn hàng thành 'Cancelled'
        UPDATE orders 
        SET status = 'Cancelled' 
        WHERE id = p_order_id;

        -- Bước 3: Cộng lại số lượng vào kho (stock = stock + quantity) trong bảng products
        UPDATE products 
        SET stock = stock + v_quantity 
        WHERE id = v_product_id;

        -- Xác nhận giao dịch
        COMMIT;
        SELECT 'Hủy đơn hàng thành công! Đã hoàn tồn kho.' AS message;
    END IF;
END //

DELIMITER ;


-- 3. Testing
-- 3.1. Tạo một đơn hàng mới
CALL place_order(1, 3);

-- 3.2. Kiểm tra kho
SELECT * FROM products WHERE id = 1;

-- 3.3. Gọi thủ tục hủy đơn hàng
CALL cancel_order(3);

-- 3.4. Kiểm tra lại trạng thái đơn hàng đổi sang 'Cancelled' và kho đã tăng lại đúng số lượng
SELECT * FROM orders WHERE id = 3;
SELECT * FROM products WHERE id = 1;
