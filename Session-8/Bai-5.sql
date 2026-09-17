-- 1. 
DELIMITER //

CREATE PROCEDURE sp_check_employee_income(
    IN p_full_name VARCHAR(100),
    IN p_salary DECIMAL(15, 2)
)
BEGIN
    DECLARE v_income_level VARCHAR(50);

    -- Xác định mức thu nhập theo điều kiện
    IF p_salary >= 15000000 THEN
        SET v_income_level = 'Thu nhập cao';
    ELSEIF p_salary >= 8000000 THEN
        SET v_income_level = 'Thu nhập trung bình';
    ELSE
        SET v_income_level = 'Thu nhập thấp';
    END IF;

    -- Hiển thị kết quả
    SELECT 
        p_full_name AS full_name,
        v_income_level AS income_level;
END //

DELIMITER ;

-- 2. 
CALL sp_check_employee_income('Nguyễn Văn Đạt', 18000000); -- Thu nhập cao
CALL sp_check_employee_income('Trần Thị B', 10000000);  -- Thu nhập trung bình
CALL sp_check_employee_income('Lê Văn C', 6000000);     -- Thu nhập thấp
