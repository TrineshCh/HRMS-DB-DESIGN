-- =====================================================
-- HRMS Database Schema Creation Script
-- Human Resource Management System
-- Naming Convention: snake_case for all objects
-- =====================================================

-- Drop database if exists (for testing purposes)
-- IF EXISTS (SELECT * FROM sys.databases WHERE name = 'HRMS_DB')
-- DROP DATABASE HRMS_DB;
-- GO

-- Create database
-- CREATE DATABASE HRMS_DB;
-- GO

-- USE HRMS_DB;
-- GO

-- =====================================================
-- 1. DEPARTMENTS TABLE
-- =====================================================
CREATE TABLE departments (
    department_id INT PRIMARY KEY IDENTITY(1,1),
    department_name NVARCHAR(100) NOT NULL UNIQUE,
    department_code NVARCHAR(20) NOT NULL UNIQUE,
    description NVARCHAR(500),
    manager_id INT NULL, -- Foreign key to employees table (self-referencing after employees table is created)
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    is_active BIT DEFAULT 1
);

-- =====================================================
-- 2. DESIGNATIONS TABLE
-- =====================================================
CREATE TABLE designations (
    designation_id INT PRIMARY KEY IDENTITY(1,1),
    designation_name NVARCHAR(100) NOT NULL UNIQUE,
    designation_code NVARCHAR(20) NOT NULL UNIQUE,
    description NVARCHAR(500),
    grade_level INT,
    min_salary DECIMAL(10,2),
    max_salary DECIMAL(10,2),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    is_active BIT DEFAULT 1
);

-- =====================================================
-- 3. EMPLOYEES TABLE
-- =====================================================
CREATE TABLE employees (
    employee_id INT PRIMARY KEY IDENTITY(1,1),
    employee_code NVARCHAR(20) NOT NULL UNIQUE,
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    phone NVARCHAR(20),
    date_of_birth DATE NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F', 'O')),
    address NVARCHAR(500),
    city NVARCHAR(50),
    state NVARCHAR(50),
    postal_code NVARCHAR(20),
    country NVARCHAR(50),
    department_id INT NOT NULL,
    designation_id INT NOT NULL,
    manager_id INT NULL, -- Self-referencing foreign key
    employment_status NVARCHAR(20) NOT NULL CHECK (employment_status IN ('Active', 'Inactive', 'Terminated', 'On Leave', 'Probation')),
    employment_type NVARCHAR(20) NOT NULL CHECK (employment_type IN ('Full-time', 'Part-time', 'Contract', 'Intern')),
    hire_date DATE NOT NULL,
    confirmation_date DATE,
    termination_date DATE,
    pan_number NVARCHAR(20),
    aadhaar_number NVARCHAR(20),
    bank_account_number NVARCHAR(50),
    bank_name NVARCHAR(100),
    bank_ifsc_code NVARCHAR(20),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    
    -- Foreign Keys
    CONSTRAINT fk_employees_department FOREIGN KEY (department_id) REFERENCES departments(department_id),
    CONSTRAINT fk_employees_designation FOREIGN KEY (designation_id) REFERENCES designations(designation_id),
    CONSTRAINT fk_employees_manager FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

-- =====================================================
-- 4. LEAVE_TYPES TABLE
-- =====================================================
CREATE TABLE leave_types (
    leave_type_id INT PRIMARY KEY IDENTITY(1,1),
    leave_type_name NVARCHAR(50) NOT NULL UNIQUE,
    leave_type_code NVARCHAR(10) NOT NULL UNIQUE,
    description NVARCHAR(200),
    max_days_per_year INT NOT NULL DEFAULT 0,
    is_paid BIT DEFAULT 1,
    requires_approval BIT DEFAULT 1,
    min_advance_days INT DEFAULT 0,
    max_consecutive_days INT DEFAULT 365,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    is_active BIT DEFAULT 1
);

-- =====================================================
-- 5. LEAVE_BALANCES TABLE
-- =====================================================
CREATE TABLE leave_balances (
    leave_balance_id INT PRIMARY KEY IDENTITY(1,1),
    employee_id INT NOT NULL,
    leave_type_id INT NOT NULL,
    total_allocated DECIMAL(5,2) NOT NULL DEFAULT 0,
    used_days DECIMAL(5,2) NOT NULL DEFAULT 0,
    balance_days DECIMAL(5,2) NOT NULL DEFAULT 0,
    year INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    
    -- Unique constraint for one record per employee per leave type per year
    CONSTRAINT uq_leave_balances UNIQUE (employee_id, leave_type_id, year),
    
    -- Foreign Keys
    CONSTRAINT fk_leave_balances_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    CONSTRAINT fk_leave_balances_leave_type FOREIGN KEY (leave_type_id) REFERENCES leave_types(leave_type_id),
    
    -- Check constraint
    CONSTRAINT chk_leave_balances CHECK (balance_days >= 0 AND used_days >= 0 AND total_allocated >= 0)
);

-- =====================================================
-- 6. LEAVE_REQUESTS TABLE
-- =====================================================
CREATE TABLE leave_requests (
    leave_request_id INT PRIMARY KEY IDENTITY(1,1),
    employee_id INT NOT NULL,
    leave_type_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_days DECIMAL(5,2) NOT NULL,
    reason NVARCHAR(500),
    status NVARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected', 'Cancelled')),
    approver_id INT NULL,
    approval_date DATETIME NULL,
    approval_comments NVARCHAR(500),
    applied_date DATETIME DEFAULT GETDATE(),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    
    -- Foreign Keys
    CONSTRAINT fk_leave_requests_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    CONSTRAINT fk_leave_requests_leave_type FOREIGN KEY (leave_type_id) REFERENCES leave_types(leave_type_id),
    CONSTRAINT fk_leave_requests_approver FOREIGN KEY (approver_id) REFERENCES employees(employee_id),
    
    -- Check constraints
    CONSTRAINT chk_leave_dates CHECK (end_date >= start_date),
    CONSTRAINT chk_leave_days CHECK (total_days > 0)
);

-- =====================================================
-- 7. ATTENDANCE TABLE
-- =====================================================
CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY IDENTITY(1,1),
    employee_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    check_in_time DATETIME,
    check_out_time DATETIME,
    break_duration_minutes INT DEFAULT 0,
    total_working_hours DECIMAL(4,2),
    overtime_hours DECIMAL(4,2) DEFAULT 0,
    status NVARCHAR(20) NOT NULL DEFAULT 'Present' CHECK (status IN ('Present', 'Absent', 'Half Day', 'Holiday', 'Weekend', 'Leave')),
    remarks NVARCHAR(200),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    
    -- Unique constraint for one record per employee per day
    CONSTRAINT uq_attendance UNIQUE (employee_id, attendance_date),
    
    -- Foreign Key
    CONSTRAINT fk_attendance_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    
    -- Check constraints
    CONSTRAINT chk_check_times CHECK (
        (check_in_time IS NULL AND check_out_time IS NULL) OR 
        (check_in_time IS NOT NULL AND check_out_time IS NULL) OR 
        (check_in_time IS NOT NULL AND check_out_time IS NOT NULL AND check_out_time > check_in_time)
    ),
    CONSTRAINT chk_working_hours CHECK (total_working_hours >= 0 AND overtime_hours >= 0)
);

-- =====================================================
-- 8. SALARY_STRUCTURES TABLE
-- =====================================================
CREATE TABLE salary_structures (
    salary_structure_id INT PRIMARY KEY IDENTITY(1,1),
    designation_id INT NOT NULL,
    basic_salary DECIMAL(10,2) NOT NULL,
    hra_percentage DECIMAL(5,2) DEFAULT 40, -- House Rent Allowance percentage
    da_percentage DECIMAL(5,2) DEFAULT 10, -- Dearness Allowance percentage
    medical_allowance DECIMAL(10,2) DEFAULT 0,
    transport_allowance DECIMAL(10,2) DEFAULT 0,
    other_allowances DECIMAL(10,2) DEFAULT 0,
    pf_percentage DECIMAL(5,2) DEFAULT 12, -- Provident Fund percentage
    esi_percentage DECIMAL(5,2) DEFAULT 1.75, -- Employee State Insurance percentage
    professional_tax DECIMAL(10,2) DEFAULT 200,
    tds_percentage DECIMAL(5,2) DEFAULT 0, -- Tax Deducted at Source percentage
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    is_active BIT DEFAULT 1,
    
    -- Foreign Key
    CONSTRAINT fk_salary_structures_designation FOREIGN KEY (designation_id) REFERENCES designations(designation_id),
    
    -- Check constraints
    CONSTRAINT chk_percentages CHECK (
        hra_percentage >= 0 AND da_percentage >= 0 AND 
        pf_percentage >= 0 AND esi_percentage >= 0 AND 
        tds_percentage >= 0 AND
        hra_percentage <= 100 AND da_percentage <= 100 AND 
        pf_percentage <= 100 && esi_percentage <= 100 && 
        tds_percentage <= 100
    )
);

-- =====================================================
-- 9. PAYROLLS TABLE
-- =====================================================
CREATE TABLE payrolls (
    payroll_id INT PRIMARY KEY IDENTITY(1,1),
    employee_id INT NOT NULL,
    payroll_month INT NOT NULL CHECK (payroll_month BETWEEN 1 AND 12),
    payroll_year INT NOT NULL,
    basic_salary DECIMAL(10,2) NOT NULL,
    hra_amount DECIMAL(10,2) NOT NULL,
    da_amount DECIMAL(10,2) NOT NULL,
    medical_allowance DECIMAL(10,2) NOT NULL,
    transport_allowance DECIMAL(10,2) NOT NULL,
    other_allowances DECIMAL(10,2) NOT NULL,
    gross_salary DECIMAL(10,2) NOT NULL,
    pf_deduction DECIMAL(10,2) NOT NULL,
    esi_deduction DECIMAL(10,2) NOT NULL,
    professional_tax DECIMAL(10,2) NOT NULL,
    tds_deduction DECIMAL(10,2) NOT NULL,
    other_deductions DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_deductions DECIMAL(10,2) NOT NULL,
    net_salary DECIMAL(10,2) NOT NULL,
    working_days INT NOT NULL,
    paid_days INT NOT NULL,
    unpaid_days DECIMAL(5,2) NOT NULL DEFAULT 0,
    overtime_hours DECIMAL(4,2) NOT NULL DEFAULT 0,
    overtime_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    leave_deduction DECIMAL(10,2) NOT NULL DEFAULT 0,
    status NVARCHAR(20) NOT NULL DEFAULT 'Draft' CHECK (status IN ('Draft', 'Processed', 'Paid', 'Cancelled')),
    processed_date DATETIME,
    processed_by INT NULL,
    payment_date DATE,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    
    -- Unique constraint for one record per employee per month
    CONSTRAINT uq_payroll UNIQUE (employee_id, payroll_month, payroll_year),
    
    -- Foreign Keys
    CONSTRAINT fk_payrolls_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    CONSTRAINT fk_payrolls_processed_by FOREIGN KEY (processed_by) REFERENCES employees(employee_id),
    
    -- Check constraints
    CONSTRAINT chk_payroll_days CHECK (
        working_days > 0 AND paid_days >= 0 AND unpaid_days >= 0 AND
        paid_days <= working_days
    ),
    CONSTRAINT chk_payroll_amounts CHECK (
        gross_salary >= 0 AND net_salary >= 0 AND 
        total_deductions >= 0 && overtime_amount >= 0
    )
);

-- =====================================================
-- 10. HOLIDAYS TABLE
-- =====================================================
CREATE TABLE holidays (
    holiday_id INT PRIMARY KEY IDENTITY(1,1),
    holiday_name NVARCHAR(100) NOT NULL,
    holiday_date DATE NOT NULL UNIQUE,
    holiday_type NVARCHAR(20) NOT NULL CHECK (holiday_type IN ('National', 'State', 'Festival', 'Weekend')),
    is_optional BIT DEFAULT 0,
    description NVARCHAR(200),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    is_active BIT DEFAULT 1
);

-- =====================================================
-- Add foreign key constraint for departments.manager_id
-- =====================================================
ALTER TABLE departments 
ADD CONSTRAINT fk_departments_manager 
FOREIGN KEY (manager_id) REFERENCES employees(employee_id);

-- =====================================================
-- Create indexes for performance optimization
-- =====================================================
-- Employees table indexes
CREATE INDEX idx_employees_department ON employees(department_id);
CREATE INDEX idx_employees_designation ON employees(designation_id);
CREATE INDEX idx_employees_manager ON employees(manager_id);
CREATE INDEX idx_employees_status ON employees(employment_status);
CREATE INDEX idx_employees_email ON employees(email);

-- Leave requests indexes
CREATE INDEX idx_leave_requests_employee ON leave_requests(employee_id);
CREATE INDEX idx_leave_requests_status ON leave_requests(status);
CREATE INDEX idx_leave_requests_dates ON leave_requests(start_date, end_date);

-- Attendance indexes
CREATE INDEX idx_attendance_employee ON attendance(employee_id);
CREATE INDEX idx_attendance_date ON attendance(attendance_date);
CREATE INDEX idx_attendance_status ON attendance(status);

-- Payroll indexes
CREATE INDEX idx_payrolls_employee ON payrolls(employee_id);
CREATE INDEX idx_payrolls_month_year ON payrolls(payroll_month, payroll_year);
CREATE INDEX idx_payrolls_status ON payrolls(status);

-- Leave balances indexes
CREATE INDEX idx_leave_balances_employee ON leave_balances(employee_id);
CREATE INDEX idx_leave_balances_year ON leave_balances(year);

-- =====================================================
-- Create triggers for automatic timestamp updates
-- =====================================================

-- Trigger for departments table
CREATE TRIGGER tr_departments_update_timestamp
ON departments
AFTER UPDATE
AS
BEGIN
    UPDATE departments 
    SET updated_at = GETDATE()
    WHERE department_id IN (SELECT department_id FROM inserted);
END;

-- Trigger for designations table
CREATE TRIGGER tr_designations_update_timestamp
ON designations
AFTER UPDATE
AS
BEGIN
    UPDATE designations 
    SET updated_at = GETDATE()
    WHERE designation_id IN (SELECT designation_id FROM inserted);
END;

-- Trigger for employees table
CREATE TRIGGER tr_employees_update_timestamp
ON employees
AFTER UPDATE
AS
BEGIN
    UPDATE employees 
    SET updated_at = GETDATE()
    WHERE employee_id IN (SELECT employee_id FROM inserted);
END;

-- Trigger for leave_types table
CREATE TRIGGER tr_leave_types_update_timestamp
ON leave_types
AFTER UPDATE
AS
BEGIN
    UPDATE leave_types 
    SET updated_at = GETDATE()
    WHERE leave_type_id IN (SELECT leave_type_id FROM inserted);
END;

-- Trigger for leave_balances table
CREATE TRIGGER tr_leave_balances_update_timestamp
ON leave_balances
AFTER UPDATE
AS
BEGIN
    UPDATE leave_balances 
    SET updated_at = GETDATE()
    WHERE leave_balance_id IN (SELECT leave_balance_id FROM inserted);
END;

-- Trigger for leave_requests table
CREATE TRIGGER tr_leave_requests_update_timestamp
ON leave_requests
AFTER UPDATE
AS
BEGIN
    UPDATE leave_requests 
    SET updated_at = GETDATE()
    WHERE leave_request_id IN (SELECT leave_request_id FROM inserted);
END;

-- Trigger for attendance table
CREATE TRIGGER tr_attendance_update_timestamp
ON attendance
AFTER UPDATE
AS
BEGIN
    UPDATE attendance 
    SET updated_at = GETDATE()
    WHERE attendance_id IN (SELECT attendance_id FROM inserted);
END;

-- Trigger for salary_structures table
CREATE TRIGGER tr_salary_structures_update_timestamp
ON salary_structures
AFTER UPDATE
AS
BEGIN
    UPDATE salary_structures 
    SET updated_at = GETDATE()
    WHERE salary_structure_id IN (SELECT salary_structure_id FROM inserted);
END;

-- Trigger for payrolls table
CREATE TRIGGER tr_payrolls_update_timestamp
ON payrolls
AFTER UPDATE
AS
BEGIN
    UPDATE payrolls 
    SET updated_at = GETDATE()
    WHERE payroll_id IN (SELECT payroll_id FROM inserted);
END;

-- Trigger for holidays table
CREATE TRIGGER tr_holidays_update_timestamp
ON holidays
AFTER UPDATE
AS
BEGIN
    UPDATE holidays 
    SET updated_at = GETDATE()
    WHERE holiday_id IN (SELECT holiday_id FROM inserted);
END;

PRINT 'HRMS Database tables created successfully!';
