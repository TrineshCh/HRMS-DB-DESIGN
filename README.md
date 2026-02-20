# HRMS Database Design

## Overview

This repository contains a comprehensive relational database design for a Human Resource Management System (HRMS) that supports core HR operations including employee management, leave management, attendance tracking, and payroll processing.

## Database Schema

### Tables Overview

The database consists of 10 main tables organized into the following modules:

#### 1. Employee Information Management
- **departments**: Stores department information and hierarchy
- **designations**: Manages job roles and salary grades
- **employees**: Core employee data with personal and professional details

#### 2. Leave Management
- **leave_types**: Defines different types of leaves and their policies
- **leave_balances**: Tracks leave balances per employee per year
- **leave_requests**: Manages leave applications and approvals

#### 3. Attendance Tracking
- **attendance**: Records daily attendance with check-in/check-out details
- **holidays**: Manages company holidays and weekends

#### 4. Payroll Processing
- **salary_structures**: Defines salary components per designation
- **payrolls**: Monthly payroll records with detailed calculations

## Entity Relationship Diagram

```
┌─────────────────┐       ┌─────────────────┐
│   departments   │       │   designations  │
├─────────────────┤       ├─────────────────┤
│ department_id   │◄──────┤ designation_id  │
│ department_name │       │ designation_name│
│ manager_id      │       │ grade_level     │
└─────────────────┘       └─────────────────┘
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
         │  department_id  │        │
         │  designation_id │        │
         │  manager_id     │        │
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
│employee │ │employee_id  │ │employee_id  │ │ basic_salary│
│_id      │ │leave_type_id│ │leave_type_id│ │ net_salary  │
└─────────┘ └─────────────┘ └─────────────┘ └─────────────┘
                │                  │
                │                  │
         ┌─────────────┐   ┌─────────────┐
         │ leave_types │   │salary_struct│
         ├─────────────┤   ├─────────────┤
         │leave_type_id│   │salary_struct│
         │leave_type   │   │_id          │
         │_name        │   │designation_ │
         └─────────────┘   │id           │
                             └─────────────┘

┌─────────────┐
│   holidays  │
├─────────────┤
│ holiday_id  │
│ holiday_date│
│ holiday_type│
└─────────────┘
```

## Key Features and Design Decisions

### 1. Normalization
- **3NF Compliance**: All tables are designed to eliminate redundancy and ensure data integrity
- **Atomic Values**: Each column contains atomic values to ensure proper normalization
- **Proper Dependencies**: All non-key attributes are fully dependent on the primary key

### 2. Data Integrity
- **Primary Keys**: All tables have auto-incrementing primary keys
- **Foreign Keys**: Proper relationships maintained with referential integrity
- **Check Constraints**: Business rules enforced at database level
- **Unique Constraints**: Prevent duplicate data where applicable

### 3. Scalability Considerations
- **Indexing Strategy**: Strategic indexes on frequently queried columns
- **Identity Columns**: Efficient primary key generation
- **Optimized Data Types**: Appropriate data types for storage efficiency
- **Partitioning Ready**: Date-based tables ready for partitioning

### 4. Business Logic Implementation
- **Self-Referencing Relationships**: Manager-employee hierarchy
- **Audit Trail**: Created_at and updated_at timestamps with triggers
- **Status Management**: Enumerated status fields with check constraints
- **Automatic Calculations**: Triggers for maintaining derived data

## Table Relationships

### Core Relationships
1. **employees → departments**: Many-to-one (employees belong to one department)
2. **employees → designations**: Many-to-one (employees hold one designation)
3. **employees → employees**: Self-referencing (manager-employee relationship)
4. **departments → employees**: One-to-many (department has many employees)

### Leave Management
1. **leave_requests → employees**: Many-to-one (requests made by employees)
2. **leave_requests → leave_types**: Many-to-one (requests of specific type)
3. **leave_balances → employees**: Many-to-one (balances per employee)
4. **leave_balances → leave_types**: Many-to-one (balances per leave type)

### Payroll System
1. **payrolls → employees**: Many-to-one (payroll per employee)
2. **salary_structures → designations**: One-to-one (structure per designation)

## Constraints and Validations

### Employee Data Validation
- Email format and uniqueness
- PAN and Aadhaar number formats
- Date of birth validation
- Employment status enumeration

### Leave Management Rules
- Leave balance cannot be negative
- Overlapping leave prevention
- Approval workflow enforcement
- Minimum advance notice requirements

### Attendance Rules
- Check-out time must be after check-in
- Working hours calculation validation
- Unique attendance record per employee per day

### Payroll Calculations
- Gross salary = Basic + HRA + DA + Allowances
- Net salary = Gross salary - Deductions
- Paid days cannot exceed working days
- Overtime calculations

## Performance Optimization

### Indexing Strategy
- **Primary Key Indexes**: Automatic on all primary keys
- **Foreign Key Indexes**: On all foreign key columns
- **Composite Indexes**: On frequently queried column combinations
- **Covering Indexes**: For common query patterns

### Query Optimization
- **Filtered Indexes**: For active records only
- **Included Columns**: To avoid bookmark lookups
- **Statistics**: Regular statistics updates for optimal query plans

## Security Considerations

### Data Protection
- **PII Handling**: Sensitive data encryption at rest
- **Access Control**: Role-based access permissions
- **Audit Logging**: Change tracking on sensitive tables
- **Data Masking**: For development environments

### Compliance
- **GDPR Ready**: Data retention and deletion capabilities
- **Audit Trail**: Complete change history
- **Privacy by Design**: Minimal data collection

## Edge Cases Handled

### 1. Employee Lifecycle
- **Termination**: Proper handling of terminated employees
- **Re-hiring**: Support for re-joining employees
- **Transfers**: Department and designation changes
- **Promotions**: Career progression tracking

### 2. Leave Scenarios
- **Backdated Leave**: Historical leave requests
- **Leave Encashment**: Converting leave to cash
- **Leave Carry Forward**: Annual leave balance management
- **Half-day Leave**: Partial day attendance

### 3. Attendance Edge Cases
- **Forgot Check-out**: Manual attendance correction
- **Multiple Shifts**: Support for different work schedules
- **Remote Work**: Work from home attendance
- **Overtime Approval**: Overtime authorization workflow

### 4. Payroll Complexities
- **Prorated Salary**: Mid-month joiners/leavers
- **Arrears**: Backdated salary adjustments
- **Bonuses**: Variable compensation handling
- **Tax Calculations**: Complex tax scenarios

## Installation and Setup

### Prerequisites
- SQL Server 2019 or later
- Azure Data Studio or SQL Server Management Studio
- Appropriate database creation permissions

### Setup Steps

1. **Create Database**
   ```sql
   CREATE DATABASE HRMS_DB;
   GO
   ```

2. **Execute Schema Script**
   ```sql
   USE HRMS_DB;
   GO
   -- Execute 01_create_tables.sql
   ```

3. **Insert Seed Data**
   ```sql
   -- Execute 02_seed_data.sql
   ```

## File Structure

```
HRMS_DB/
├── 01_create_tables.sql    # Database schema creation
├── 02_seed_data.sql        # Sample data insertion
├── 03_indexes.sql          # Performance optimization indexes
├── 04_procedures.sql       # Stored procedures
├── 05_functions.sql        # User-defined functions
├── README.md              # This documentation
└── ER_Diagram.png         # Visual ER diagram
```

## Sample Data

The seed data includes:
- **7 Departments**: HR, IT, Finance, Marketing, Operations, Sales, Administration
- **17 Designations**: From CEO to Admin Assistant with appropriate salary ranges
- **16 Employees**: Sample employees across all departments
- **7 Leave Types**: Common leave categories with policies
- **Leave Balances**: Current year leave balances for employees
- **Sample Records**: Leave requests, attendance, and payroll data

## Business Rules Implemented

### Leave Management
1. **Leave Balance Validation**: Cannot apply for leave exceeding available balance
2. **Approval Workflow**: Leave requires manager approval
3. **Overlapping Prevention**: Cannot apply for overlapping dates
4. **Advance Notice**: Minimum advance days requirement for certain leave types

### Attendance Management
1. **Unique Daily Record**: One attendance record per employee per day
2. **Time Validation**: Check-out must be after check-in
3. **Working Hours**: Automatic calculation based on check-in/out times
4. **Overtime Tracking**: Overtime hours calculation and approval

### Payroll Processing
1. **Monthly Processing**: One payroll record per employee per month
2. **Salary Structure**: Based on designation with configurable components
3. **Deduction Calculations**: Automatic PF, ESI, tax calculations
4. **Leave Impact**: Unpaid leave affects salary calculations

## Maintenance and Monitoring

### Regular Tasks
- **Database Backups**: Daily automated backups
- **Statistics Update**: Weekly statistics refresh
- **Index Maintenance**: Monthly index rebuild/reorganize
- **Archive Old Data**: Annual data archival for performance

### Monitoring
- **Performance Metrics**: Query performance monitoring
- **Storage Growth**: Database size tracking
- **User Activity**: Access pattern analysis
- **Error Logs**: Regular error log review

## Future Enhancements

### Planned Features
1. **Performance Reviews**: Employee appraisal system
2. **Training Management**: Training program tracking
3. **Recruitment Module**: Complete hiring workflow
4. **Employee Self-Service**: Portal for employee access
5. **Mobile App**: Mobile attendance and leave requests

### Technical Improvements
1. **Data Warehouse**: Analytics and reporting database
2. **API Layer**: RESTful API for application integration
3. **Microservices**: Modular service architecture
4. **Cloud Migration**: Azure SQL Database deployment

## Assumptions Made

1. **Company Structure**: Single company with multiple departments
2. **Work Schedule**: Standard 5-day work week (Monday-Friday)
3. **Leave Policy**: Annual leave allocation with carry-forward
4. **Payroll Cycle**: Monthly payroll processing
5. **Currency**: Indian Rupees (INR) for all monetary values
6. **Tax Regime**: Indian tax laws and regulations
7. **Work Hours**: 8-hour work day with 1-hour break

## Contact Information

For questions or support regarding this database design:
- **Database Administrator**: dba@company.com
- **Development Team**: dev@company.com
- **HR Department**: hr@company.com

## License

This database design is proprietary to the organization and should not be distributed without proper authorization.

---

**Version**: 1.0  
**Last Updated**: December 2024  
**Database Version**: SQL Server 2019+  
**Documentation Version**: 1.0
