-- 1. 
DELIMITER //

CREATE PROCEDURE sp_check_order_value(
    IN p_total_amount DECIMAL(10, 2)
)
BEGIN
    IF p_total_amount >= 5000000 THEN
        SELECT 'Đơn hàng giá trị cao' AS message;
    ELSE
        SELECT 'Đơn hàng bình thường' AS message;
    END IF;
END //

DELIMITER ;

-- 2. 
CALL sp_check_order_value(5500000); -- Return: Đơn hàng giá trị cao
CALL sp_check_order_value(2000000); -- Return: Đơn hàng bình thường
