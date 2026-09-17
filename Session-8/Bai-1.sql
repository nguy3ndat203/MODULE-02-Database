-- 1. Define Stored Procedure
DELIMITER //

CREATE PROCEDURE sp_get_all_students()
BEGIN
    SELECT 
        student_id,
        full_name,
        class_name
    FROM students;
END //

DELIMITER ;

-- 2. Execute Stored Procedure
CALL sp_get_all_students();
