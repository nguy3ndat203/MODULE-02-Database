-- Tạo bảng employees
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15)
);

-- Tạo bảng salary_log
CREATE TABLE salary_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    old_salary DECIMAL(10, 2) NOT NULL,
    new_salary DECIMAL(10, 2) NOT NULL,
    change_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_salary_log_employees 
        FOREIGN KEY (employee_id) REFERENCES employees(id) 
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Chèn 10 bản ghi mẫu vào bảng employees
INSERT INTO employees (first_name, last_name, salary, email, phone_number) VALUES
('Nam', 'Nguyễn', 12000000.00, 'nam.nguyen@example.com', '0901234567'),
('Hoa', 'Trần', 15000000.00, 'hoa.tran@example.com', '0912345678'),
('Huy', 'Lê', 9500000.00, 'huy.le@example.com', '0923456789'),
('Bảo', 'Phạm', 18000000.00, 'bao.pham@example.com', '0934567890'),
('Công', 'Võ', 8000000.00, 'cong.vo@example.com', '0945678901'),
('Thu', 'Đặng', 11000000.00, 'thu.dang@example.com', '0956789012'),
('Hoàng', 'Bùi', 13500000.00, 'hoang.bui@example.com', '0967890123'),
('Mai', 'Đỗ', 16000000.00, 'mai.do@example.com', '0978901234'),
('Tuấn', 'Hồ', 10500000.00, 'tuan.ho@example.com', '0989012345'),
('Linh', 'Ngo', 20000000.00, 'linh.ngo@example.com', '0990123456');


-- Tạo Trigger
DELIMITER //

CREATE TRIGGER trg_after_update_salary
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
	INSERT INTO salary_log (employee_id, old_salary, new_salary, change_date)
	VALUES (NEW.id, OLD.salary, NEW.salary, NOW());
END //

DELIMITER ;


-- Test
-- Cập nhật lương nhân viên id = 1 từ 12.000.000 lên 14.000.000
UPDATE employees 
SET salary = 14000000.00 
WHERE id = 1;

-- Kiểm tra bảng ghi nhật ký salary_log
SELECT * FROM salary_log;
