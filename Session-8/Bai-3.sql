-- 1. 
DELIMITER //

CREATE PROCEDURE sp_get_avg_salary()
BEGIN
    
    DECLARE v_avg_salary DECIMAL(10, 2);

    -- Tính lương trung bình và gán vào biến
    SELECT AVG(salary) INTO v_avg_salary
    FROM employees;

    -- Hiển thị giá trị
    SELECT v_avg_salary AS average_salary;
END //

DELIMITER ;

-- 2. Call Stored Procedure
CALL sp_get_avg_salary();
