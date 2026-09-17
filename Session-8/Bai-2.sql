-- 1. 
DELIMITER //

CREATE PROCEDURE sp_get_products_by_category(
    IN p_category VARCHAR(100)
)
BEGIN
    SELECT 
        product_id,
        product_name,
        price,
        category
    FROM products
    WHERE category = p_category;
END //

DELIMITER ;

-- 2. Call Stored Procedure
CALL sp_get_products_by_category('Laptop');


