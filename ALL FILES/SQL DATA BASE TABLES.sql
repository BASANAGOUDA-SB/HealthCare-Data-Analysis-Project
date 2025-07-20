CREATE DATABASE [WINDOW FUN]


--select * from [dbo].[EmpSalary1]

create table [dbo].[EmpSalary1] (Employeeid int, employeename varchar(max),salary int, department varchar(max))

select top 0 * into [dbo].[EmpSalary2] from [dbo].[EmpSalary1]

select top 0 * into [dbo].[EmpSalary3] from [dbo].[EmpSalary1]

select top 0 * into [dbo].[EmpSalary4] from [dbo].[EmpSalary1]

INSERT INTO [dbo].[EmpSalary1] (EmployeeID, EmployeeName, Salary, Department)
VALUES 
    (1, 'Alice', 50000, 'HR'),
    (2, 'Bob', 60000, 'HR');


	INSERT INTO [dbo].[EmpSalary2] (EmployeeID, EmployeeName, Salary, Department)
VALUES 
    (3, 'Charlie', 55000, 'HR'),
    (4, 'David', 75000, 'Finance');


	INSERT INTO [dbo].[EmpSalary3] (EmployeeID, EmployeeName, Salary, Department)
VALUES 
    (5, 'Eve', 80000, 'Finance'),
    (6, 'Frank', 72000, 'Finance');

	INSERT INTO [dbo].[EmpSalary4] (EmployeeID, EmployeeName, Salary, Department)
VALUES 
    (7, 'Grace', 90000, 'IT'),
    (8, 'Heidi', 95000, 'IT'),
    (9, 'Ivan', 87000, 'IT');



