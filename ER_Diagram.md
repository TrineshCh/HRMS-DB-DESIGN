# HRMS Database Entity Relationship Diagram

## Visual ER Diagram (Text Representation)

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                                    HRMS DATABASE ER DIAGRAM                            │
└─────────────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────┐       ┌─────────────────┐
│   departments   │       │   designations  │
├─────────────────┤       ├─────────────────┤
│ department_id   │◄──────┤ designation_id  │
│ department_name │       │ designation_name│
│ department_code │       │ designation_code│
│ description     │       │ description     │
│ manager_id      │       │ grade_level     │
│ created_at      │       │ min_salary      │
│ updated_at      │       │ max_salary      │
│ is_active       │       │ created_at      │
└─────────────────┘       │ updated_at      │
         │                │ is_active       │
         │                └─────────────────┘
         │                         │
         │                         │
         └─────────────┬───────────┘
                       │
         ┌─────────────────┐
         │    employees    │
         ├─────────────────┤
         │  employee_id    │◄───────┐
         │  employee_code  │        │
         │  first_name     │        │
         │  last_name      │        │
         │  email          │        │
         │  phone          │        │
         │  date_of_birth  │        │
         │  gender         │        │
         │  address        │        │
         │  city           │        │
         │  state          │        │
         │  postal_code    │        │
         │  country        │        │
         │  department_id  │        │
         │  designation_id │        │
         │  manager_id     │        │
         │  employment_    │        │
         │  status         │        │
         │  employment_    │        │
         │  type           │        │
         │  hire_date      │        │
         │  confirmation_  │        │
         │  date           │        │
         │  termination_   │        │
         │  date           │        │
         │  pan_number     │        │
         │  aadhaar_number │        │
         │  bank_account_  │        │
         │  number         │        │
         │  bank_name      │        │
         │  bank_ifsc_code │        │
         │  created_at     │        │
         │  updated_at     │        │
         └─────────────────┘        │
                │                  │
                │                  │
    ┌───────────┼──────────────────┼───────────────┐
    │           │                  │               │
    │           │                  │               │
┌─────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│attendance│ │leave_requests│ │leave_balances│ │  payrolls   │
├─────────┤ ├─────────────┤ ├─────────────┤ ├─────────────┤
│attendance│ │leave_request│ │leave_balance│ │ payroll_id  │
│_id      │ │_id          │ │_id          │ │ employee_id │
│employee │ │employee_id  │ │employee_id  │ │ payroll_    │
│_id      │ │leave_type_id│ │leave_type_id│ │ month       │
│attendance│ │start_date   │ │total_       │ │ payroll_    │
│_date    │ │end_date     │ │allocated    │ │ year        │
│check_in │ │total_days   │ │used_days    │ │ basic_salary│
│_time    │ │reason       │ │balance_days │ │ hra_amount  │
│check_out│ │status       │ │year         │ │ da_amount   │
│_time    │ │approver_id  │ │created_at   │ │ medical_    │
│break_   │ │approval_date│ │updated_at   │ │ allowance   │
│duration_│ │approval_    │ └─────────────┘ │ transport_  │
│minutes  │ │comments     │                │ allowance   │
│total_   │ │applied_date │                │ other_      │
│working_ │ │created_at   │                │ allowances  │
│hours    │ │updated_at   │                │ gross_salary│
│overtime │ └─────────────┘                │ pf_deduction│
│_hours   │                │               │ esi_deduction│
│status   │                │               │ professional│
│remarks  │                │               │ _tax        │
│created_ │                │               │ tds_deduction│
│at      │                │               │ other_      │
│updated_ │                │               │ deductions  │
│at      │                │               │ total_      │
└─────────┘                │               │ deductions  │
                            │               │ net_salary  │
                            │               │ working_days│
                            │               │ paid_days   │
                            │               │ unpaid_days │
                            │               │ overtime_   │
                            │               │ hours       │
                            │               │ overtime_   │
                            │               │ amount      │
                            │               │ leave_      │
                            │               │ deduction   │
                            │               │ status      │
                            │               │ processed_  │
                            │               │ date        │
                            │               │ processed_by│
                            │               │ payment_date│
                            │               │ created_at  │
                            │               │ updated_at  │
                            │               └─────────────┘
                            │
                │           │
                │           │
         ┌─────────────┐   ┌─────────────┐
         │ leave_types │   │salary_struct│
         ├─────────────┤   ├─────────────┤
         │leave_type_id│   │salary_struct│
         │leave_type   │   │_id          │
         │_name        │   │designation_ │
         │leave_type   │   │id           │
         │_code        │   │basic_salary │
         │description  │   │hra_percent  │
         │max_days_per │   │da_percent   │
         │_year        │   │medical_     │
         │is_paid      │   │ allowance   │
         │requires_    │   │ transport_  │
         │approval     │   │ allowance   │
         │min_advance_ │   │ other_      │
         │days         │   │ allowances  │
         │max_consecutive│  │ pf_percent  │
         │_days        │   │ esi_percent │
         │created_at   │   │ professional│
         │updated_at   │   │ _tax        │
         │is_active    │   │ tds_percent │
         └─────────────┘   │ created_at  │
                            │ updated_at  │
                            │ is_active   │
                            └─────────────┘

┌─────────────┐
│   holidays  │
├─────────────┤
│ holiday_id  │
│ holiday_name│
│ holiday_date│
│ holiday_type│
│ is_optional │
│ description │
│ created_at  │
│ updated_at  │
│ is_active   │
└─────────────┘
```

## Relationship Details

### Primary Key Relationships

1. **departments (1) → many employees**
   - `departments.department_id` → `employees.department_id`
   - One department can have many employees
   - Each employee belongs to exactly one department

2. **designations (1) → many employees**
   - `designations.designation_id` → `employees.designation_id`
   - One designation can be held by many employees
   - Each employee has exactly one designation

3. **employees (1) → many employees (Self-referencing)**
   - `employees.employee_id` → `employees.manager_id`
   - One manager can manage many employees
   - Each employee reports to exactly one manager (except top-level)

4. **employees (1) → many departments**
   - `employees.employee_id` → `departments.manager_id`
   - One employee can manage multiple departments
   - Each department has exactly one manager

### Leave Management Relationships

5. **employees (1) → many leave_requests**
   - `employees.employee_id` → `leave_requests.employee_id`
   - One employee can make many leave requests
   - Each leave request belongs to exactly one employee

6. **leave_types (1) → many leave_requests**
   - `leave_types.leave_type_id` → `leave_requests.leave_type_id`
   - One leave type can have many requests
   - Each leave request is of exactly one type

7. **employees (1) → many leave_balances**
   - `employees.employee_id` → `leave_balances.employee_id`
   - One employee has multiple leave balances (one per type per year)
   - Each leave balance belongs to exactly one employee

8. **leave_types (1) → many leave_balances**
   - `leave_types.leave_type_id` → `leave_balances.leave_type_id`
   - One leave type can have many balances
   - Each leave balance is for exactly one leave type

### Attendance Relationships

9. **employees (1) → many attendance**
   - `employees.employee_id` → `attendance.employee_id`
   - One employee can have many attendance records
   - Each attendance record belongs to exactly one employee

### Payroll Relationships

10. **employees (1) → many payrolls**
    - `employees.employee_id` → `payrolls.employee_id`
    - One employee can have many payroll records
    - Each payroll record belongs to exactly one employee

11. **designations (1) → many salary_structures**
    - `designations.designation_id` → `salary_structures.designation_id`
    - One designation has one salary structure
    - Each salary structure belongs to exactly one designation

### Approval Relationships

12. **employees (1) → many leave_requests (as approver)**
    - `employees.employee_id` → `leave_requests.approver_id`
    - One employee can approve many leave requests
    - Each leave request is approved by exactly one employee

13. **employees (1) → many payrolls (as processor)**
    - `employees.employee_id` → `payrolls.processed_by`
    - One employee can process many payrolls
    - Each payroll is processed by exactly one employee

## Cardinality Summary

| Relationship | Cardinality | Description |
|--------------|-------------|-------------|
| departments → employees | 1:N | One department, many employees |
| designations → employees | 1:N | One designation, many employees |
| employees → employees | 1:N | One manager, many subordinates |
| employees → departments | 1:N | One manager, many departments |
| employees → leave_requests | 1:N | One employee, many requests |
| leave_types → leave_requests | 1:N | One type, many requests |
| employees → leave_balances | 1:N | One employee, many balances |
| leave_types → leave_balances | 1:N | One type, many balances |
| employees → attendance | 1:N | One employee, many records |
| employees → payrolls | 1:N | One employee, many payrolls |
| designations → salary_structures | 1:1 | One designation, one structure |
| employees → leave_requests (approver) | 1:N | One approver, many requests |
| employees → payrolls (processor) | 1:N | One processor, many payrolls |

## Key Constraints

### Unique Constraints
- `employees.employee_code`
- `employees.email`
- `departments.department_name`
- `departments.department_code`
- `designations.designation_name`
- `designations.designation_code`
- `leave_types.leave_type_name`
- `leave_types.leave_type_code`
- `attendance.employee_id + attendance.date`
- `payrolls.employee_id + payrolls.month + payrolls.year`
- `leave_balances.employee_id + leave_balances.leave_type_id + leave_balances.year`
- `holidays.holiday_date`

### Check Constraints
- `employees.gender IN ('M', 'F', 'O')`
- `employees.employment_status IN ('Active', 'Inactive', 'Terminated', 'On Leave', 'Probation')`
- `employees.employment_type IN ('Full-time', 'Part-time', 'Contract', 'Intern')`
- `leave_requests.status IN ('Pending', 'Approved', 'Rejected', 'Cancelled')`
- `attendance.status IN ('Present', 'Absent', 'Half Day', 'Holiday', 'Weekend', 'Leave')`
- `payrolls.status IN ('Draft', 'Processed', 'Paid', 'Cancelled')`
- `holidays.holiday_type IN ('National', 'State', 'Festival', 'Weekend')`

## Index Strategy

### Clustered Indexes (Primary Keys)
- All primary key columns have clustered indexes by default

### Non-Clustered Indexes
- **Foreign Key Indexes**: All foreign key columns
- **Unique Indexes**: All unique constraint columns
- **Composite Indexes**: Frequently queried column combinations
- **Covering Indexes**: For common query patterns

### Performance Indexes
- `idx_employees_department` on `employees(department_id)`
- `idx_employees_designation` on `employees(designation_id)`
- `idx_employees_manager` on `employees(manager_id)`
- `idx_leave_requests_employee` on `leave_requests(employee_id)`
- `idx_leave_requests_status` on `leave_requests(status)`
- `idx_attendance_employee` on `attendance(employee_id)`
- `idx_attendance_date` on `attendance(attendance_date)`
- `idx_payrolls_employee` on `payrolls(employee_id)`
- `idx_payrolls_month_year` on `payrolls(payroll_month, payroll_year)`

## Data Flow Diagram

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Employee  │───▶│ Attendance  │───▶│   Payroll   │
│   Data      │    │   Tracking  │    │ Processing │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ Leave       │    │ Working     │    │ Salary      │
│ Management  │    │ Hours Calc  │    │ Calculation │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       └───────────────────┼───────────────────┘
                           ▼
                   ┌─────────────┐
                   │   Reports   │
                   │ & Analytics │
                   └─────────────┘
```

## Normalization Levels

### First Normal Form (1NF)
- All tables have primary keys
- All columns contain atomic values
- No repeating groups

### Second Normal Form (2NF)
- All non-key attributes are fully dependent on primary key
- No partial dependencies

### Third Normal Form (3NF)
- No transitive dependencies
- All non-key attributes depend only on primary key
- Proper normalization achieved

## Business Rules Enforcement

### Database Level Constraints
- **Referential Integrity**: Foreign key constraints
- **Domain Integrity**: Check constraints and data types
- **Entity Integrity**: Primary key constraints
- **User-Defined Integrity**: Triggers and stored procedures

### Application Level Validation
- **Business Logic**: Complex business rules
- **Workflow Management**: Approval processes
- **Security**: Access control and permissions
- **Audit Trail**: Change tracking and logging

---

**Note**: This ER diagram represents the complete HRMS database structure with all relationships, constraints, and business rules implemented at the database level.
