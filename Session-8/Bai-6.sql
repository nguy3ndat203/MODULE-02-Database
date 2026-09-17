-- 1. 
DELIMITER //

CREATE PROCEDURE sp_classify_student(
    IN p_gpa DECIMAL(3, 1),
    OUT p_classification VARCHAR(20)
)
BEGIN
    -- Khai báo biến trung gian
    DECLARE v_result VARCHAR(20);

    -- Phân loại học lực 
    CASE 
        WHEN p_gpa >= 8.0 THEN 
            SET v_result = 'Giỏi';
        WHEN p_gpa >= 6.5 THEN 
            SET v_result = 'Khá';
        WHEN p_gpa >= 5.0 THEN 
            SET v_result = 'Trung bình';
        ELSE 
            SET v_result = 'Yếu';
    END CASE;

    -- Gán kết quả từ biến trung gian vào tham số OUT
    SET p_classification = v_result;
END //

DELIMITER ;

-- 2. Call Stored Procedure và kiểm tra kết quả bằng biến Session
CALL sp_classify_student(7.5, @result_rank);

SELECT @result_rank AS student_classification;
