

CREATE DATABASE [COLUMN DISTRIBUTION]


USE [COLUMN DISTRIBUTION]




CREATE TABLE SampleData (
    ID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Age INT,
    BirthDate DATE,
    Salary DECIMAL(10, 2),
    IsActive BIT,
    JoinDate DATETIME,
    Description NVARCHAR(255),
    Rating FLOAT,
    Department CHAR(3)
);


INSERT INTO SampleData (ID, Name, Age, BirthDate, Salary, IsActive, JoinDate, Description, Rating, Department)
VALUES
(1, 'Alice Smith', 30, '1993-01-15', 60000.00, 1, '2020-06-01 09:00:00', 'Senior Developer', 4.5, 'DEV'),
(2, 'Bob Johnson', 45, '1978-03-22', 75000.00, 1, '2019-04-15 08:30:00', 'Project Manager', 4.2, 'MNG'),
(3, 'Charlie Brown', 28, '1995-07-30', 50000.00, 1, '2021-09-10 10:15:00', 'Junior Developer', 4.0, 'DEV'),
(4, 'Diana Prince', 35, '1988-02-14', 70000.00, 0, '2018-12-05 11:00:00', 'Designer', 4.3, 'DSN'),
(5, 'Ethan Hunt', 50, '1973-11-25', 90000.00, 1, '2015-03-22 14:00:00', 'Director', 4.8, 'DIR'),
(6, 'Fiona Gallagher', 29, '1994-05-05', 48000.00, 1, '2022-01-10 09:45:00', 'Intern', 3.9, 'INT'),
(7, 'George Washington', 40, '1983-06-12', 85000.00, 0, '2017-08-01 16:30:00', 'Consultant', 4.6, 'CNS'),
(8, 'Hannah Baker', 33, '1990-12-21', 52000.00, 1, '2020-11-15 13:20:00', 'Tester', 4.1, 'TST'),
(9, 'Ian Malcolm', 38, '1985-09-30', 65000.00, 1, '2016-05-10 12:00:00', 'Analyst', 4.4, 'ANL'),
(10, 'Jack Sparrow', 44, '1979-04-01', 72000.00, 1, '2014-07-20 15:00:00', 'Captain', 4.7, 'CAP');
