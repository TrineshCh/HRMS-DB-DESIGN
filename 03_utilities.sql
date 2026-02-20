-- =====================================================
-- HRMS Database Utility Scripts
-- Stored Procedures, Functions, and Additional Indexes
-- =====================================================

-- USE HRMS_DB;
-- GO

-- =====================================================
-- 1. ADDITIONAL INDEXES FOR PERFORMANCE
-- =====================================================

-- Composite indexes for common query patterns
CREATE INDEX idx_employees_dept_desig ON employees(department_id, designation_id);
CREATE INDEX idx_employees_status_type ON employees(employment_status, employment_type);
CREATE INDEX idx_leave_requests_employee_status ON leave_requests(employee_id, status);
CREATE INDEX idx_leave_requests_dates_status ON leave_requests(start_date, end_date, status);
CREATE INDEX idx_attendance_employee_date ON attendance(employee_id, attendance_date);
CREATE INDEX idx_attendance_date_status ON attendance(attendance_date, status);
CREATE INDEX idx_payrolls_employee_month_year ON payrolls(employee_id, payroll_month, payroll_year);
CREATE INDEX idx_leave_balances_employee_year ON leave_balances(employee_id, year);

-- Filtered indexes for active records only
CREATE INDEX idx_departments_active ON departments(department_name) WHERE is_active = 1;
CREATE INDEX idx_designations_active ON designations(designation_name) WHERE is_active = 1;
CREATE INDEX idx_employees_active ON employees(employee_code) WHERE employment_status = 'Active';
CREATE INDEX idx_leave_types_active ON leave_types(leave_type_name) WHERE is_active = 1;
CREATE INDEX idx_holidays_active ON holidays(holiday_date) WHERE is_active = 1;

-- =====================================================
-- 2. STORED PROCEDURES
-- =====================================================

-- Procedure to get employee details with department and designation
CREATE PROCEDURE sp_get_employee_details
    @employee_id INT = NULL,
    @department_id INT = NULL,
    @designation_id INT = NULL
AS
BEGIN
    SELECT 
        e.employee_id,
        e.employee_code,
        e.first_name,
        e.last_name,
        e.email,
        e.phone,
        e.employment_status,
        e.employment_type,
        e.hire_date,
        d.department_name,
        des.designation_name,
        m.first_name + ' ' + m.last_name AS manager_name,
        e.created_at,
        e.updated_at
    FROM employees e
    LEFT JOIN departments d ON e.department_id = d.department_id
    LEFT JOIN designations des ON e.designation_id = des.designation_id
    LEFT JOIN employees m ON e.manager_id = m.employee_id
    WHERE 
        (@employee_id IS NULL OR e.employee_id = @employee_id) AND
        (@department_id IS NULL OR e.department_id = @department_id) AND
        (@designation_id IS NULL OR e.designation_id = @designation_id)
    ORDER BY e.first_name, e.last_name;
END;

-- Procedure to get leave balance for an employee
CREATE PROCEDURE sp_get_employee_leave_balance
    @employee_id INT,
    @year INT = NULL
AS
BEGIN
    SET @year = ISNULL(@year, YEAR(GETDATE()));
    
    SELECT 
        lt.leave_type_name,
        lt.leave_type_code,
        lb.total_allocated,
        lb.used_days,
        lb.balance_days,
        lt.max_days_per_year,
        lt.is_paid
    FROM leave_balances lb
    JOIN leave_types lt ON lb.leave_type_id = lt.leave_type_id
    WHERE lb.employee_id = @employee_id AND lb.year = @year AND lt.is_active = 1
    ORDER BY lt.leave_type_name;
END;

-- Procedure to submit leave request
CREATE PROCEDURE sp_submit_leave_request
    @employee_id INT,
    @leave_type_id INT,
    @start_date DATE,
    @end_date DATE,
    @total_days DECIMAL(5,2),
    @reason NVARCHAR(500)
AS
BEGIN
    DECLARE @balance_days DECIMAL(5,2);
    DECLARE @year INT = YEAR(@start_date);
    DECLARE @manager_id INT;
    
    -- Get leave balance
    SELECT @balance_days = balance_days 
    FROM leave_balances 
    WHERE employee_id = @employee_id AND leave_type_id = @leave_type_id AND year = @year;
    
    -- Get manager
    SELECT @manager_id = manager_id 
    FROM employees 
    WHERE employee_id = @employee_id;
    
    -- Validate leave balance
    IF @balance_days >= @total_days
    BEGIN
        -- Check for overlapping leaves
        IF NOT EXISTS (
            SELECT 1 FROM leave_requests 
            WHERE employee_id = @employee_id 
            AND status IN ('Pending', 'Approved')
            AND (
                (@start_date BETWEEN start_date AND end_date) OR
                (@end_date BETWEEN start_date AND end_date) OR
                (start_date BETWEEN @start_date AND @end_date)
            )
        )
        BEGIN
            INSERT INTO leave_requests (
                employee_id, leave_type_id, start_date, end_date, 
                total_days, reason, approver_id
            )
            VALUES (
                @employee_id, @leave_type_id, @start_date, @end_date, 
                @total_days, @reason, @manager_id
            );
            
            SELECT 'Leave request submitted successfully' AS message, 1 AS success;
        END
        ELSE
        BEGIN
            SELECT 'Overlapping leave dates found' AS message, 0 AS success;
        END
    END
    ELSE
    BEGIN
        SELECT 'Insufficient leave balance' AS message, 0 AS success;
    END
END;

-- Procedure to approve/reject leave request
CREATE PROCEDURE sp_process_leave_request
    @leave_request_id INT,
    @approver_id INT,
    @status NVARCHAR(20),
    @approval_comments NVARCHAR(500) = NULL
AS
BEGIN
    DECLARE @employee_id INT;
    DECLARE @leave_type_id INT;
    DECLARE @total_days DECIMAL(5,2);
    DECLARE @year INT;
    DECLARE @current_status NVARCHAR(20);
    
    -- Get current request details
    SELECT 
        @employee_id = employee_id,
        @leave_type_id = leave_type_id,
        @total_days = total_days,
        @year = YEAR(start_date),
        @current_status = status
    FROM leave_requests 
    WHERE leave_request_id = @leave_request_id;
    
    -- Validate approver
    IF EXISTS (
        SELECT 1 FROM employees 
        WHERE employee_id = @approver_id 
        AND employee_id = (SELECT manager_id FROM employees WHERE employee_id = @employee_id)
    )
    BEGIN
        IF @current_status = 'Pending'
        BEGIN
            -- Update leave request
            UPDATE leave_requests 
            SET status = @status,
                approver_id = @approver_id,
                approval_date = GETDATE(),
                approval_comments = @approval_comments
            WHERE leave_request_id = @leave_request_id;
            
            -- If approved, update leave balance
            IF @status = 'Approved'
            BEGIN
                UPDATE leave_balances 
                SET used_days = used_days + @total_days,
                    balance_days = balance_days - @total_days
                WHERE employee_id = @employee_id 
                AND leave_type_id = @leave_type_id 
                AND year = @year;
            END
            
            SELECT 'Leave request processed successfully' AS message, 1 AS success;
        END
        ELSE
        BEGIN
            SELECT 'Leave request already processed' AS message, 0 AS success;
        END
    END
    ELSE
    BEGIN
        SELECT 'Unauthorized approver' AS message, 0 AS success;
    END
END;

-- Procedure to mark attendance
CREATE PROCEDURE sp_mark_attendance
    @employee_id INT,
    @attendance_date DATE,
    @check_in_time DATETIME = NULL,
    @check_out_time DATETIME = NULL,
    @break_duration_minutes INT = 0,
    @remarks NVARCHAR(200) = NULL
AS
BEGIN
    DECLARE @working_hours DECIMAL(4,2) = 0;
    DECLARE @overtime_hours DECIMAL(4,2) = 0;
    DECLARE @status NVARCHAR(20) = 'Present';
    
    -- Calculate working hours if both times are provided
    IF @check_in_time IS NOT NULL AND @check_out_time IS NOT NULL
    BEGIN
        SET @working_hours = DATEDIFF(MINUTE, @check_in_time, @check_out_time) / 60.0 - (@break_duration_minutes / 60.0);
        
        -- Calculate overtime (after 8 hours)
        IF @working_hours > 8
        BEGIN
            SET @overtime_hours = @working_hours - 8;
            SET @working_hours = 8; -- Regular hours capped at 8
        END
        
        -- Determine status based on working hours
        IF @working_hours < 4
            SET @status = 'Half Day';
        ELSE IF @working_hours = 0
            SET @status = 'Absent';
    END
    ELSE IF @check_in_time IS NULL AND @check_out_time IS NULL
    BEGIN
        SET @status = 'Absent';
    END
    
    -- Check if record exists
    IF EXISTS (SELECT 1 FROM attendance WHERE employee_id = @employee_id AND attendance_date = @attendance_date)
    BEGIN
        -- Update existing record
        UPDATE attendance 
        SET check_in_time = @check_in_time,
            check_out_time = @check_out_time,
            break_duration_minutes = @break_duration_minutes,
            total_working_hours = @working_hours,
            overtime_hours = @overtime_hours,
            status = @status,
            remarks = @remarks
        WHERE employee_id = @employee_id AND attendance_date = @attendance_date;
    END
    ELSE
    BEGIN
        -- Insert new record
        INSERT INTO attendance (
            employee_id, attendance_date, check_in_time, check_out_time,
            break_duration_minutes, total_working_hours, overtime_hours,
            status, remarks
        )
        VALUES (
            @employee_id, @attendance_date, @check_in_time, @check_out_time,
            @break_duration_minutes, @working_hours, @overtime_hours,
            @status, @remarks
        );
    END
    
    SELECT 'Attendance marked successfully' AS message, 1 AS success;
END;

-- Procedure to process monthly payroll
CREATE PROCEDURE sp_process_monthly_payroll
    @month INT,
    @year INT,
    @processed_by INT
AS
BEGIN
    DECLARE @employee_id INT;
    DECLARE @basic_salary DECIMAL(10,2);
    DECLARE @hra_percentage DECIMAL(5,2);
    DECLARE @da_percentage DECIMAL(5,2);
    DECLARE @medical_allowance DECIMAL(10,2);
    DECLARE @transport_allowance DECIMAL(10,2);
    DECLARE @other_allowances DECIMAL(10,2);
    DECLARE @pf_percentage DECIMAL(5,2);
    DECLARE @esi_percentage DECIMAL(5,2);
    DECLARE @professional_tax DECIMAL(10,2);
    DECLARE @tds_percentage DECIMAL(5,2);
    
    DECLARE @hra_amount DECIMAL(10,2);
    DECLARE @da_amount DECIMAL(10,2);
    DECLARE @gross_salary DECIMAL(10,2);
    DECLARE @pf_deduction DECIMAL(10,2);
    DECLARE @esi_deduction DECIMAL(10,2);
    DECLARE @tds_deduction DECIMAL(10,2);
    DECLARE @total_deductions DECIMAL(10,2);
    DECLARE @net_salary DECIMAL(10,2);
    
    DECLARE @working_days INT;
    DECLARE @paid_days INT;
    DECLARE @unpaid_days DECIMAL(5,2);
    DECLARE @overtime_hours DECIMAL(4,2);
    DECLARE @overtime_amount DECIMAL(10,2);
    DECLARE @leave_deduction DECIMAL(10,2);
    
    -- Cursor for active employees
    DECLARE employee_cursor CURSOR FOR
    SELECT e.employee_id 
    FROM employees e
    WHERE e.employment_status = 'Active'
    AND NOT EXISTS (
        SELECT 1 FROM payrolls p 
        WHERE p.employee_id = e.employee_id 
        AND p.payroll_month = @month 
        AND p.payroll_year = @year
    );
    
    OPEN employee_cursor;
    FETCH NEXT FROM employee_cursor INTO @employee_id;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Get salary structure
        SELECT 
            @basic_salary = ss.basic_salary,
            @hra_percentage = ss.hra_percentage,
            @da_percentage = ss.da_percentage,
            @medical_allowance = ss.medical_allowance,
            @transport_allowance = ss.transport_allowance,
            @other_allowances = ss.other_allowances,
            @pf_percentage = ss.pf_percentage,
            @esi_percentage = ss.esi_percentage,
            @professional_tax = ss.professional_tax,
            @tds_percentage = ss.tds_percentage
        FROM salary_structures ss
        JOIN designations d ON ss.designation_id = d.designation_id
        JOIN employees e ON e.designation_id = d.designation_id
        WHERE e.employee_id = @employee_id AND ss.is_active = 1;
        
        -- Calculate allowances
        SET @hra_amount = @basic_salary * (@hra_percentage / 100);
        SET @da_amount = @basic_salary * (@da_percentage / 100);
        SET @gross_salary = @basic_salary + @hra_amount + @da_amount + 
                           @medical_allowance + @transport_allowance + @other_allowances;
        
        -- Calculate deductions
        SET @pf_deduction = @basic_salary * (@pf_percentage / 100);
        SET @esi_deduction = @gross_salary * (@esi_percentage / 100);
        SET @tds_deduction = @gross_salary * (@tds_percentage / 100);
        SET @total_deductions = @pf_deduction + @esi_deduction + @professional_tax + @tds_deduction;
        SET @net_salary = @gross_salary - @total_deductions;
        
        -- Get attendance summary for the month
        SELECT 
            @working_days = COUNT(DISTINCT attendance_date),
            @paid_days = SUM(CASE WHEN status IN ('Present', 'Half Day') THEN 
                              CASE WHEN status = 'Half Day' THEN 0.5 ELSE 1 END ELSE 0 END),
            @overtime_hours = SUM(overtime_hours)
        FROM attendance 
        WHERE employee_id = @employee_id 
        AND MONTH(attendance_date) = @month 
        AND YEAR(attendance_date) = @year;
        
        -- Calculate unpaid days and leave deduction
        SET @unpaid_days = @working_days - @paid_days;
        SET @leave_deduction = (@basic_salary / @working_days) * @unpaid_days;
        
        -- Calculate overtime amount (assuming overtime rate = 1.5x basic hourly rate)
        SET @overtime_amount = (@basic_salary / (@working_days * 8)) * @overtime_hours * 1.5;
        
        -- Adjust net salary for leave deduction and overtime
        SET @net_salary = @net_salary - @leave_deduction + @overtime_amount;
        
        -- Insert payroll record
        INSERT INTO payrolls (
            employee_id, payroll_month, payroll_year, basic_salary, hra_amount, da_amount,
            medical_allowance, transport_allowance, other_allowances, gross_salary,
            pf_deduction, esi_deduction, professional_tax, tds_deduction, other_deductions,
            total_deductions, net_salary, working_days, paid_days, unpaid_days,
            overtime_hours, overtime_amount, leave_deduction, status, 
            processed_date, processed_by
        )
        VALUES (
            @employee_id, @month, @year, @basic_salary, @hra_amount, @da_amount,
            @medical_allowance, @transport_allowance, @other_allowances, @gross_salary,
            @pf_deduction, @esi_deduction, @professional_tax, @tds_deduction, 0,
            @total_deductions, @net_salary, @working_days, @paid_days, @unpaid_days,
            @overtime_hours, @overtime_amount, @leave_deduction, 'Processed',
            GETDATE(), @processed_by
        );
        
        FETCH NEXT FROM employee_cursor INTO @employee_id;
    END
    
    CLOSE employee_cursor;
    DEALLOCATE employee_cursor;
    
    SELECT 'Payroll processed successfully' AS message, 1 AS success;
END;

-- =====================================================
-- 3. USER-DEFINED FUNCTIONS
-- =====================================================

-- Function to calculate working days between two dates
CREATE FUNCTION fn_calculate_working_days (@start_date DATE, @end_date DATE)
RETURNS INT
AS
BEGIN
    DECLARE @working_days INT = 0;
    DECLARE @current_date DATE = @start_date;
    
    WHILE @current_date <= @end_date
    BEGIN
        -- Exclude weekends (Saturday = 7, Sunday = 1)
        IF DATEPART(WEEKDAY, @current_date) NOT IN (1, 7)
        BEGIN
            -- Exclude holidays
            IF NOT EXISTS (SELECT 1 FROM holidays WHERE holiday_date = @current_date AND is_active = 1)
            BEGIN
                SET @working_days = @working_days + 1;
            END
        END
        
        SET @current_date = DATEADD(DAY, 1, @current_date);
    END
    
    RETURN @working_days;
END;

-- Function to get employee hierarchy
CREATE FUNCTION fn_get_employee_hierarchy (@employee_id INT)
RETURNS TABLE
AS
RETURN
(
    WITH EmployeeHierarchy AS (
        SELECT 
            employee_id,
            employee_code,
            first_name,
            last_name,
            manager_id,
            0 AS level
        FROM employees
        WHERE employee_id = @employee_id
        
        UNION ALL
        
        SELECT 
            e.employee_id,
            e.employee_code,
            e.first_name,
            e.last_name,
            e.manager_id,
            eh.level + 1
        FROM employees e
        JOIN EmployeeHierarchy eh ON e.employee_id = eh.manager_id
        WHERE eh.level < 10 -- Prevent infinite recursion
    )
    SELECT * FROM EmployeeHierarchy
);

-- Function to calculate leave days
CREATE FUNCTION fn_calculate_leave_days (@start_date DATE, @end_date DATE)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @total_days DECIMAL(5,2) = 0;
    DECLARE @current_date DATE = @start_date;
    
    WHILE @current_date <= @end_date
    BEGIN
        -- Exclude weekends
        IF DATEPART(WEEKDAY, @current_date) NOT IN (1, 7)
        BEGIN
            -- Exclude holidays
            IF NOT EXISTS (SELECT 1 FROM holidays WHERE holiday_date = @current_date AND is_active = 1)
            BEGIN
                SET @total_days = @total_days + 1;
            END
        END
        
        SET @current_date = DATEADD(DAY, 1, @current_date);
    END
    
    RETURN @total_days;
END;

-- =====================================================
-- 4. VIEWS FOR COMMON REPORTS
-- =====================================================

-- View for employee directory
CREATE VIEW vw_employee_directory AS
SELECT 
    e.employee_id,
    e.employee_code,
    e.first_name,
    e.last_name,
    e.email,
    e.phone,
    d.department_name,
    des.designation_name,
    e.employment_status,
    e.employment_type,
    e.hire_date,
    m.first_name + ' ' + m.last_name AS manager_name,
    CASE 
        WHEN e.employment_status = 'Active' THEN 'Green'
        WHEN e.employment_status = 'On Leave' THEN 'Yellow'
        ELSE 'Red'
    END AS status_color
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN designations des ON e.designation_id = des.designation_id
LEFT JOIN employees m ON e.manager_id = m.employee_id;

-- View for leave summary
CREATE VIEW vw_leave_summary AS
SELECT 
    e.employee_id,
    e.first_name + ' ' + e.last_name AS employee_name,
    d.department_name,
    lt.leave_type_name,
    lb.year,
    lb.total_allocated,
    lb.used_days,
    lb.balance_days,
    CAST((lb.used_days / lb.total_allocated) * 100 AS DECIMAL(5,2)) AS utilization_percentage
FROM employees e
JOIN leave_balances lb ON e.employee_id = lb.employee_id
JOIN leave_types lt ON lb.leave_type_id = lt.leave_type_id
JOIN departments d ON e.department_id = d.department_id
WHERE lt.is_active = 1;

-- View for attendance summary
CREATE VIEW vw_attendance_summary AS
SELECT 
    e.employee_id,
    e.first_name + ' ' + e.last_name AS employee_name,
    d.department_name,
    MONTH(a.attendance_date) AS month,
    YEAR(a.attendance_date) AS year,
    COUNT(*) AS total_days,
    SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) AS present_days,
    SUM(CASE WHEN a.status = 'Absent' THEN 1 ELSE 0 END) AS absent_days,
    SUM(CASE WHEN a.status = 'Half Day' THEN 1 ELSE 0 END) AS half_days,
    SUM(CASE WHEN a.status = 'Leave' THEN 1 ELSE 0 END) AS leave_days,
    SUM(a.total_working_hours) AS total_working_hours,
    SUM(a.overtime_hours) AS total_overtime_hours,
    CAST(AVG(a.total_working_hours) AS DECIMAL(4,2)) AS avg_working_hours
FROM employees e
JOIN attendance a ON e.employee_id = a.employee_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY e.employee_id, e.first_name, e.last_name, d.department_name, 
         MONTH(a.attendance_date), YEAR(a.attendance_date);

-- View for payroll summary
CREATE VIEW vw_payroll_summary AS
SELECT 
    e.employee_id,
    e.first_name + ' ' + e.last_name AS employee_name,
    d.department_name,
    des.designation_name,
    p.payroll_month,
    p.payroll_year,
    p.gross_salary,
    p.total_deductions,
    p.net_salary,
    p.working_days,
    p.paid_days,
    p.unpaid_days,
    p.overtime_hours,
    p.overtime_amount,
    p.status
FROM employees e
JOIN payrolls p ON e.employee_id = p.employee_id
JOIN departments d ON e.department_id = d.department_id
JOIN designations des ON e.designation_id = des.designation_id;

PRINT 'HRMS Database utilities created successfully!';
