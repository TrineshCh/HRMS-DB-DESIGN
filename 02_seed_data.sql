-- =====================================================
-- HRMS Database Seed Data
-- Human Resource Management System
-- =====================================================

-- USE HRMS_DB;
-- GO

-- =====================================================
-- 1. DEPARTMENTS SEED DATA
-- =====================================================
INSERT INTO departments (department_name, department_code, description, is_active) VALUES
('Human Resources', 'HR', 'Manages employee relations, recruitment, and HR policies', 1),
('Information Technology', 'IT', 'Handles technology infrastructure and software development', 1),
('Finance', 'FIN', 'Manages financial planning, accounting, and budgeting', 1),
('Marketing', 'MKT', 'Handles marketing strategies and brand management', 1),
('Operations', 'OPS', 'Manages day-to-day operations and logistics', 1),
('Sales', 'SAL', 'Handles sales and customer relationships', 1),
('Administration', 'ADM', 'Manages administrative tasks and facilities', 1);

-- =====================================================
-- 2. DESIGNATIONS SEED DATA
-- =====================================================
INSERT INTO designations (designation_name, designation_code, description, grade_level, min_salary, max_salary, is_active) VALUES
('Chief Executive Officer', 'CEO', 'Top executive responsible for overall company management', 1, 2000000, 5000000, 1),
('Chief Technology Officer', 'CTO', 'Head of technology and IT operations', 2, 1500000, 3000000, 1),
('Chief Financial Officer', 'CFO', 'Head of finance and accounting', 2, 1500000, 3000000, 1),
('Department Manager', 'MGR', 'Manages a specific department', 3, 800000, 1500000, 1),
('Senior Developer', 'SDEV', 'Experienced software developer', 4, 600000, 1000000, 1),
('Junior Developer', 'JDEV', 'Entry-level software developer', 5, 300000, 600000, 1),
('HR Manager', 'HRM', 'Manages human resources department', 3, 700000, 1200000, 1),
('Finance Manager', 'FMG', 'Manages finance department', 3, 700000, 1200000, 1),
('Marketing Manager', 'MMG', 'Manages marketing department', 3, 700000, 1200000, 1),
('Sales Manager', 'SMG', 'Manages sales team', 3, 700000, 1200000, 1),
('Operations Manager', 'OMG', 'Manages operations department', 3, 700000, 1200000, 1),
('Senior Accountant', 'SACC', 'Experienced accounting professional', 4, 400000, 700000, 1),
('Junior Accountant', 'JACC', 'Entry-level accounting professional', 5, 250000, 400000, 1),
('Marketing Executive', 'MEXE', 'Marketing team member', 5, 300000, 500000, 1),
('Sales Executive', 'SEXE', 'Sales team member', 5, 250000, 450000, 1),
('HR Executive', 'HEXE', 'HR team member', 5, 300000, 500000, 1),
('Admin Assistant', 'AADM', 'Administrative support staff', 6, 200000, 350000, 1);

-- =====================================================
-- 3. LEAVE_TYPES SEED DATA
-- =====================================================
INSERT INTO leave_types (leave_type_name, leave_type_code, description, max_days_per_year, is_paid, requires_approval, min_advance_days, max_consecutive_days, is_active) VALUES
('Casual Leave', 'CL', 'Short duration leave for personal reasons', 12, 1, 1, 1, 3, 1),
('Sick Leave', 'SL', 'Leave for medical reasons', 12, 1, 1, 0, 5, 1),
('Earned Leave', 'EL', 'Accumulated leave based on service', 15, 1, 1, 3, 15, 1),
('Maternity Leave', 'ML', 'Leave for female employees during pregnancy', 180, 1, 1, 30, 180, 1),
('Paternity Leave', 'PL', 'Leave for male employees during childbirth', 15, 1, 1, 7, 15, 1),
('Compensatory Off', 'CO', 'Leave for overtime work', 8, 1, 1, 1, 2, 1),
('Leave Without Pay', 'LWP', 'Unpaid leave for extended periods', 365, 0, 1, 7, 365, 1);

-- =====================================================
-- 4. EMPLOYEES SEED DATA
-- =====================================================
INSERT INTO employees (
    employee_code, first_name, last_name, email, phone, date_of_birth, gender,
    address, city, state, postal_code, country,
    department_id, designation_id, manager_id, employment_status, employment_type,
    hire_date, confirmation_date, pan_number, aadhaar_number,
    bank_account_number, bank_name, bank_ifsc_code
) VALUES
-- Top Management
('EMP001', 'John', 'Smith', 'john.smith@company.com', '9876543210', '1980-01-15', 'M',
 '123 CEO Street', 'Mumbai', 'Maharashtra', '400001', 'India',
 1, 1, NULL, 'Active', 'Full-time',
 '2015-01-01', '2015-04-01', 'ABCDE1234F', '123456789012',
 '1234567890123456', 'State Bank of India', 'SBIN0000001'),

-- IT Department
('EMP002', 'Sarah', 'Johnson', 'sarah.johnson@company.com', '9876543211', '1985-03-22', 'F',
 '456 Tech Park', 'Bangalore', 'Karnataka', '560001', 'India',
 2, 2, 1, 'Active', 'Full-time',
 '2016-06-15', '2016-09-15', 'FGHIJ5678K', '234567890123',
 '2345678901234567', 'HDFC Bank', 'HDFC0000002'),

('EMP003', 'Mike', 'Wilson', 'mike.wilson@company.com', '9876543212', '1988-07-10', 'M',
 '789 Developer Lane', 'Bangalore', 'Karnataka', '560002', 'India',
 2, 4, 2, 'Active', 'Full-time',
 '2017-03-20', '2017-06-20', 'KLMNO9012P', '345678901234',
 '3456789012345678', 'ICICI Bank', 'ICIC0000003'),

('EMP004', 'Emily', 'Brown', 'emily.brown@company.com', '9876543213', '1992-11-25', 'F',
 '101 Software Ave', 'Bangalore', 'Karnataka', '560003', 'India',
 2, 5, 3, 'Active', 'Full-time',
 '2019-01-10', '2019-04-10', 'QRSTU3456V', '456789012345',
 '4567890123456789', 'Axis Bank', 'UTIB0000004'),

('EMP005', 'David', 'Lee', 'david.lee@company.com', '9876543214', '1990-05-18', 'M',
 '202 Code Street', 'Bangalore', 'Karnataka', '560004', 'India',
 2, 5, 3, 'Active', 'Full-time',
 '2018-08-15', '2018-11-15', 'WXYZA7890B', '567890123456',
 '5678901234567890', 'Bank of Baroda', 'BARB0000005'),

-- Finance Department
('EMP006', 'Robert', 'Taylor', 'robert.taylor@company.com', '9876543215', '1982-09-30', 'M',
 '303 Finance Road', 'Mumbai', 'Maharashtra', '400002', 'India',
 3, 3, 1, 'Active', 'Full-time',
 '2016-02-01', '2016-05-01', 'BCDEF2345G', '678901234567',
 '6789012345678901', 'Punjab National Bank', 'PUNB0000006'),

('EMP007', 'Lisa', 'Anderson', 'lisa.anderson@company.com', '9876543216', '1987-12-08', 'F',
 '404 Account Lane', 'Mumbai', 'Maharashtra', '400003', 'India',
 3, 12, 6, 'Active', 'Full-time',
 '2017-07-22', '2017-10-22', 'HIJKL6789M', '789012345678',
 '7890123456789012', 'Canara Bank', 'CNRB0000007'),

('EMP008', 'James', 'Martinez', 'james.martinez@company.com', '9876543217', '1991-04-15', 'M',
 '505 Tax Street', 'Mumbai', 'Maharashtra', '400004', 'India',
 3, 13, 7, 'Active', 'Full-time',
 '2018-11-10', '2019-02-10', 'MNOPQ0123R', '890123456789',
 '8901234567890123', 'Union Bank of India', 'UBIN0000008'),

-- HR Department
('EMP009', 'Jennifer', 'Garcia', 'jennifer.garcia@company.com', '9876543218', '1986-06-20', 'F',
 '606 HR Avenue', 'Mumbai', 'Maharashtra', '400005', 'India',
 1, 7, 1, 'Active', 'Full-time',
 '2016-09-05', '2016-12-05', 'STUVW4567X', '901234567890',
 '9012345678901234', 'Bank of India', 'BKID0000009'),

('EMP010', 'William', 'Rodriguez', 'william.rodriguez@company.com', '9876543219', '1993-08-12', 'M',
 '707 Recruitment Road', 'Mumbai', 'Maharashtra', '400006', 'India',
 1, 16, 9, 'Active', 'Full-time',
 '2019-04-15', '2019-07-15', 'YZABC8901D', '012345678901',
 '0123456789012345', 'Central Bank of India', 'CBIN0000010'),

-- Marketing Department
('EMP011', 'Maria', 'Hernandez', 'maria.hernandez@company.com', '9876543220', '1984-02-28', 'F',
 '808 Marketing Blvd', 'Delhi', 'Delhi', '110001', 'India',
 4, 9, 1, 'Active', 'Full-time',
 '2015-11-20', '2016-02-20', 'CDEFG2345H', '123456789012',
 '1234567890123456', 'IDFC First Bank', 'IDFB0000011'),

('EMP012', 'Charles', 'Lopez', 'charles.lopez@company.com', '9876543221', '1989-10-05', 'M',
 '909 Brand Street', 'Delhi', 'Delhi', '110002', 'India',
 4, 15, 11, 'Active', 'Full-time',
 '2018-02-28', '2018-05-28', 'IJKLM5678N', '234567890123',
 '2345678901234567', 'Yes Bank', 'YESB0000012'),

-- Sales Department
('EMP013', 'Patricia', 'Gonzalez', 'patricia.gonzalez@company.com', '9876543222', '1983-07-14', 'F',
 '1010 Sales Avenue', 'Delhi', 'Delhi', '110003', 'India',
 5, 10, 1, 'Active', 'Full-time',
 '2015-08-10', '2015-11-10', 'OPQRS9012T', '345678901234',
 '3456789012345678', 'Kotak Mahindra Bank', 'KKBK0000013'),

('EMP014', 'Daniel', 'Perez', 'daniel.perez@company.com', '9876543223', '1991-01-30', 'M',
 '1111 Client Road', 'Delhi', 'Delhi', '110004', 'India',
 5, 16, 13, 'Active', 'Full-time',
 '2019-06-01', '2019-09-01', 'TUVWX3456Y', '456789012345',
 '4567890123456789', 'IndusInd Bank', 'INDB0000014'),

-- Operations Department
('EMP015', 'Nancy', 'Sanchez', 'nancy.sanchez@company.com', '9876543224', '1985-12-03', 'F',
 '1212 Operations Lane', 'Chennai', 'Tamil Nadu', '600001', 'India',
 6, 11, 1, 'Active', 'Full-time',
 '2016-04-18', '2016-07-18', 'WXYZA7890Z', '567890123456',
 '5678901234567890', 'Federal Bank', 'FDRL0000015'),

-- Administration
('EMP016', 'Thomas', 'Ramirez', 'thomas.ramirez@company.com', '9876543225', '1992-09-25', 'M',
 '1313 Admin Street', 'Chennai', 'Tamil Nadu', '600002', 'India',
 7, 17, 15, 'Active', 'Full-time',
 '2018-10-12', '2019-01-12', 'ABCDE1234A', '678901234567',
 '6789012345678901', 'South Indian Bank', 'SIBL0000016');

-- =====================================================
-- 5. SALARY_STRUCTURES SEED DATA
-- =====================================================
INSERT INTO salary_structures (
    designation_id, basic_salary, hra_percentage, da_percentage,
    medical_allowance, transport_allowance, other_allowances,
    pf_percentage, esi_percentage, professional_tax, tds_percentage, is_active
) VALUES
(1, 300000, 40, 10, 50000, 30000, 100000, 12, 1.75, 200, 30, 1), -- CEO
(2, 250000, 40, 10, 40000, 25000, 75000, 12, 1.75, 200, 30, 1), -- CTO
(3, 250000, 40, 10, 40000, 25000, 75000, 12, 1.75, 200, 30, 1), -- CFO
(3, 120000, 40, 10, 20000, 15000, 30000, 12, 1.75, 200, 20, 1), -- Department Manager
(4, 80000, 40, 10, 15000, 10000, 20000, 12, 1.75, 200, 15, 1), -- Senior Developer
(5, 45000, 40, 10, 10000, 8000, 12000, 12, 1.75, 200, 10, 1), -- Junior Developer
(3, 100000, 40, 10, 18000, 12000, 25000, 12, 1.75, 200, 20, 1), -- HR Manager
(3, 100000, 40, 10, 18000, 12000, 25000, 12, 1.75, 200, 20, 1), -- Finance Manager
(3, 100000, 40, 10, 18000, 12000, 25000, 12, 1.75, 200, 20, 1), -- Marketing Manager
(3, 100000, 40, 10, 18000, 12000, 25000, 12, 1.75, 200, 20, 1), -- Sales Manager
(3, 100000, 40, 10, 18000, 12000, 25000, 12, 1.75, 200, 20, 1), -- Operations Manager
(4, 55000, 40, 10, 12000, 9000, 15000, 12, 1.75, 200, 12, 1), -- Senior Accountant
(5, 35000, 40, 10, 8000, 6000, 10000, 12, 1.75, 200, 8, 1), -- Junior Accountant
(5, 40000, 40, 10, 10000, 7000, 12000, 12, 1.75, 200, 10, 1), -- Marketing Executive
(5, 35000, 40, 10, 8000, 6000, 10000, 12, 1.75, 200, 8, 1), -- Sales Executive
(5, 40000, 40, 10, 10000, 7000, 12000, 12, 1.75, 200, 10, 1), -- HR Executive
(6, 25000, 40, 10, 6000, 5000, 8000, 12, 1.75, 200, 5, 1); -- Admin Assistant

-- =====================================================
-- 6. LEAVE_BALANCES SEED DATA (for current year)
-- =====================================================
INSERT INTO leave_balances (employee_id, leave_type_id, total_allocated, used_days, balance_days, year) VALUES
-- Employee 1 (CEO)
(1, 1, 12, 2, 10, 2024), (1, 2, 12, 1, 11, 2024), (1, 3, 15, 5, 10, 2024),

-- Employee 2 (CTO)
(2, 1, 12, 3, 9, 2024), (2, 2, 12, 2, 10, 2024), (2, 3, 15, 4, 11, 2024),

-- Employee 3 (IT Manager)
(3, 1, 12, 4, 8, 2024), (3, 2, 12, 1, 11, 2024), (3, 3, 15, 6, 9, 2024),

-- Employee 4 (Senior Developer)
(4, 1, 12, 2, 10, 2024), (4, 2, 12, 3, 9, 2024), (4, 3, 15, 3, 12, 2024),

-- Employee 5 (Junior Developer)
(5, 1, 12, 1, 11, 2024), (5, 2, 12, 0, 12, 2024), (5, 3, 15, 2, 13, 2024),

-- Employee 6 (Finance Manager)
(6, 1, 12, 3, 9, 2024), (6, 2, 12, 2, 10, 2024), (6, 3, 15, 4, 11, 2024),

-- Employee 7 (Senior Accountant)
(7, 1, 12, 2, 10, 2024), (7, 2, 12, 1, 11, 2024), (7, 3, 15, 3, 12, 2024),

-- Employee 8 (Junior Accountant)
(8, 1, 12, 1, 11, 2024), (8, 2, 12, 0, 12, 2024), (8, 3, 15, 2, 13, 2024),

-- Employee 9 (HR Manager)
(9, 1, 12, 3, 9, 2024), (9, 2, 12, 2, 10, 2024), (9, 3, 15, 5, 10, 2024),

-- Employee 10 (HR Executive)
(10, 1, 12, 2, 10, 2024), (10, 2, 12, 1, 11, 2024), (10, 3, 15, 3, 12, 2024);

-- =====================================================
-- 7. HOLIDAYS SEED DATA
-- =====================================================
INSERT INTO holidays (holiday_name, holiday_date, holiday_type, is_optional, description, is_active) VALUES
('Republic Day', '2024-01-26', 'National', 0, 'Indian Republic Day', 1),
('Independence Day', '2024-08-15', 'National', 0, 'Indian Independence Day', 1),
('Gandhi Jayanti', '2024-10-02', 'National', 0, 'Mahatma Gandhi Birthday', 1),
('Diwali', '2024-11-01', 'Festival', 0, 'Festival of Lights', 1),
('Holi', '2024-03-25', 'Festival', 0, 'Festival of Colors', 1),
('Eid', '2024-04-10', 'Festival', 0, 'Eid-ul-Fitr', 1),
('Christmas', '2024-12-25', 'Festival', 0, 'Christmas Day', 1),
('New Year', '2024-01-01', 'National', 0, 'New Year Day', 1);

-- =====================================================
-- 8. SAMPLE LEAVE_REQUESTS
-- =====================================================
INSERT INTO leave_requests (employee_id, leave_type_id, start_date, end_date, total_days, reason, status, approver_id, approval_date, approval_comments) VALUES
(4, 1, '2024-12-20', '2024-12-22', 3, 'Personal work', 'Approved', 3, '2024-12-15', 'Approved as per policy'),
(5, 2, '2024-11-10', '2024-11-12', 3, 'Medical emergency', 'Approved', 3, '2024-11-09', 'Medical certificate attached'),
(7, 3, '2024-12-25', '2024-12-31', 7, 'Family vacation', 'Pending', 6, NULL, NULL),
(10, 1, '2024-12-15', '2024-12-16', 2, 'Personal reasons', 'Approved', 9, '2024-12-10', 'Short duration approved');

-- =====================================================
-- 9. SAMPLE ATTENDANCE (last 7 days)
-- =====================================================
INSERT INTO attendance (employee_id, attendance_date, check_in_time, check_out_time, break_duration_minutes, total_working_hours, overtime_hours, status, remarks) VALUES
-- Today's attendance
(1, '2024-12-20', '2024-12-20 09:00:00', '2024-12-20 18:30:00', 60, 8.5, 0.5, 'Present', 'Regular working day'),
(2, '2024-12-20', '2024-12-20 08:45:00', '2024-12-20 17:45:00', 45, 8.0, 0.0, 'Present', 'Regular working day'),
(3, '2024-12-20', '2024-12-20 09:15:00', '2024-12-20 19:15:00', 60, 8.5, 1.0, 'Present', 'Worked overtime'),
(4, '2024-12-20', '2024-12-20 09:00:00', '2024-12-20 18:00:00', 60, 8.0, 0.0, 'Present', 'Regular working day'),
(5, '2024-12-20', '2024-12-20 09:30:00', '2024-12-20 18:30:00', 60, 8.0, 0.0, 'Present', 'Late arrival'),
(6, '2024-12-20', '2024-12-20 08:30:00', '2024-12-20 17:30:00', 60, 8.0, 0.0, 'Present', 'Early arrival'),
(7, '2024-12-20', '2024-12-20 09:00:00', NULL, 0, 0.0, 0.0, 'Present', 'Check-in only'),
(8, '2024-12-20', NULL, NULL, 0, 0.0, 0.0, 'Absent', 'No attendance'),
(9, '2024-12-20', '2024-12-20 09:00:00', '2024-12-20 18:00:00', 60, 8.0, 0.0, 'Present', 'Regular working day'),
(10, '2024-12-20', '2024-12-20 09:00:00', '2024-12-20 18:00:00', 60, 8.0, 0.0, 'Present', 'Regular working day'),

-- Yesterday's attendance
(1, '2024-12-19', '2024-12-19 09:00:00', '2024-12-19 18:00:00', 60, 8.0, 0.0, 'Present', 'Regular working day'),
(2, '2024-12-19', '2024-12-19 08:45:00', '2024-12-19 17:45:00', 45, 8.0, 0.0, 'Present', 'Regular working day'),
(3, '2024-12-19', '2024-12-19 09:00:00', '2024-12-19 18:00:00', 60, 8.0, 0.0, 'Present', 'Regular working day'),
(4, '2024-12-19', '2024-12-19 09:00:00', '2024-12-19 18:00:00', 60, 8.0, 0.0, 'Present', 'Regular working day'),
(5, '2024-12-19', '2024-12-19 09:00:00', '2024-12-19 18:00:00', 60, 8.0, 0.0, 'Present', 'Regular working day'),
(6, '2024-12-19', '2024-12-19 08:30:00', '2024-12-19 17:30:00', 60, 8.0, 0.0, 'Present', 'Regular working day'),
(7, '2024-12-19', '2024-12-19 09:00:00', '2024-12-19 18:00:00', 60, 8.0, 0.0, 'Present', 'Regular working day'),
(8, '2024-12-19', '2024-12-19 09:00:00', '2024-12-19 18:00:00', 60, 8.0, 0.0, 'Present', 'Regular working day'),
(9, '2024-12-19', '2024-12-19 09:00:00', '2024-12-19 18:00:00', 60, 8.0, 0.0, 'Present', 'Regular working day'),
(10, '2024-12-19', '2024-12-19 09:00:00', '2024-12-19 18:00:00', 60, 8.0, 0.0, 'Present', 'Regular working day');

-- =====================================================
-- 10. SAMPLE PAYROLL (December 2024)
-- =====================================================
INSERT INTO payrolls (
    employee_id, payroll_month, payroll_year, basic_salary, hra_amount, da_amount,
    medical_allowance, transport_allowance, other_allowances, gross_salary,
    pf_deduction, esi_deduction, professional_tax, tds_deduction, other_deductions,
    total_deductions, net_salary, working_days, paid_days, unpaid_days,
    overtime_hours, overtime_amount, leave_deduction, status, processed_date, processed_by
) VALUES
(1, 12, 2024, 300000, 120000, 30000, 50000, 30000, 100000, 630000, 36000, 11025, 200, 189000, 0, 236225, 393775, 22, 22, 0, 0, 0, 0, 'Processed', '2024-12-20', 1),
(2, 12, 2024, 250000, 100000, 25000, 40000, 25000, 75000, 515000, 30000, 9012.50, 200, 154500, 0, 193712.50, 321287.50, 22, 22, 0, 0, 0, 0, 'Processed', '2024-12-20', 1),
(3, 12, 2024, 120000, 48000, 12000, 20000, 15000, 30000, 245000, 14400, 4287.50, 200, 73500, 0, 92387.50, 152612.50, 22, 22, 0, 0, 0, 0, 'Processed', '2024-12-20', 1),
(4, 12, 2024, 80000, 32000, 8000, 15000, 10000, 20000, 165000, 9600, 2887.50, 200, 24750, 0, 37437.50, 127562.50, 22, 22, 0, 0, 0, 0, 'Processed', '2024-12-20', 1),
(5, 12, 2024, 45000, 18000, 4500, 10000, 8000, 12000, 97500, 5400, 1706.25, 200, 9750, 0, 17056.25, 80443.75, 22, 22, 0, 0, 0, 0, 'Processed', '2024-12-20', 1);

-- =====================================================
-- Update department managers
-- =====================================================
UPDATE departments SET manager_id = 1 WHERE department_id = 1; -- HR Department managed by CEO
UPDATE departments SET manager_id = 2 WHERE department_id = 2; -- IT Department managed by CTO
UPDATE departments SET manager_id = 6 WHERE department_id = 3; -- Finance Department managed by Finance Manager
UPDATE departments SET manager_id = 11 WHERE department_id = 4; -- Marketing Department managed by Marketing Manager
UPDATE departments SET manager_id = 13 WHERE department_id = 5; -- Sales Department managed by Sales Manager
UPDATE departments SET manager_id = 15 WHERE department_id = 6; -- Operations Department managed by Operations Manager
UPDATE departments SET manager_id = 1 WHERE department_id = 7; -- Admin Department managed by CEO

PRINT 'HRMS Database seed data inserted successfully!';
