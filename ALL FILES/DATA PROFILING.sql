CREATE DATABASE[data profiling]

use[data profiling]


CREATE TABLE EmployeeData (
    EmployeeID INT,
    FullName NVARCHAR(100) NOT NULL,
    Age INT NULL,
    HireDate DATE NULL,
    Salary DECIMAL(10, 2) DEFAULT 0.00,
    IsActive BIT NOT NULL,
    Department NVARCHAR(50) NULL,
    PerformanceScore FLOAT NULL,
    Position NVARCHAR(100) NOT NULL,
    ManagerID INT NULL
);

INSERT INTO EmployeeData (EmployeeID, FullName, Age, HireDate, Salary, IsActive, Department, PerformanceScore, Position, ManagerID)
VALUES
(1, 'Alice Smith', 30, '2020-06-01', 60000.00, 1, 'Development', 4.5, 'Senior Developer', NULL),
(2, 'Bob Johnson', NULL, NULL, 75000.00, 1, 'Management', 4.2, 'Project Manager', 1),
(3, 'Charlie Brown', 28, '2021-09-10', 0.00, 1, 'Development', 4.0, 'Junior Developer', 1),
(5, 'Ethan Hunt', 50, '2015-03-22', 90000.00, 1, 'Management', 4.8, 'Director', 1),
(6, 'Fiona Gallagher', 29, '2022-01-10', 48000.00, 1, 'Intern', 3.9, 'Intern', 3),
(7, 'Bob Johnson', 45, '2019-04-15', 75000.00, 1, 'Management', 4.2, 'Project Manager', 1), -- Duplicate
(8, 'Hannah Baker', 33, NULL, 52000.00, 1, 'Quality Assurance', 4.1, 'Tester', 4),
(9, 'Ian Malcolm', NULL, '2016-05-10', 55000.00, 1, 'Analysis', 4.4, 'Analyst', 2),
(10, 'Jack Sparrow', 44, '2014-07-20', 72000.00, 1, 'Management', 4.7, 'Captain', 5);


----------------------------





select * from EmployeeData

select * from INFORMATION_SCHEMA.columns where TABLE_NAME like 'employeedata'

select column_name,ordinal_position, data_type, character_maximum_length into #1
from INFORMATION_SCHEMA.columns where TABLE_NAME like 'employeedata'

select * from #1

alter table #1 add maximum nvarchar(max)
alter table #1 add minimum nvarchar(max)
alter table #1 add nulls int
alter table #1 add distinct_count int
alter table #1 add mean float
alter table #1 add median float
alter table #1 add mode nvarchar(max)
alter table #1 add SD float
alter table #1 add Zero_Values int

-----------------------------------------------------------------------------------------
-- Declare variables
DECLARE @i INT = 1;
DECLARE @j INT;
SET @j = (SELECT MAX(ordinal_position) FROM #1);

DECLARE @column_name NVARCHAR(MAX);
DECLARE @datatype NVARCHAR(MAX);
DECLARE @sql NVARCHAR(MAX);

-- Loop through each column
WHILE @i <= @j
BEGIN
    SELECT 
        @column_name = column_name, 
        @datatype = data_type 
    FROM #1 
    WHERE ordinal_position = @i;

    -- NUMERIC or DATE columns
    IF @datatype IN ('DATE','DATETIME','DATETIME2','SMALLDATETIME','TIME',
                     'INT','FLOAT','DECIMAL','NUMERIC','MONEY','SMALLINT','TINYINT')
    BEGIN
        -- MAX
        SET @sql = N'UPDATE #1 SET maximum = (SELECT MAX(' + QUOTENAME(@column_name) + ') FROM EmployeeData) WHERE ordinal_position = ' + CAST(@i AS NVARCHAR);
        EXEC sp_executesql @sql;

        -- MIN
        SET @sql = N'UPDATE #1 SET minimum = (SELECT MIN(' + QUOTENAME(@column_name) + ') FROM EmployeeData) WHERE ordinal_position = ' + CAST(@i AS NVARCHAR);
        EXEC sp_executesql @sql;

        -- MEAN & SD for numeric only
        IF @datatype IN ('INT','FLOAT','DECIMAL','NUMERIC','MONEY','SMALLINT','TINYINT')
        BEGIN
            SET @sql = N'UPDATE #1 SET mean = (SELECT AVG(TRY_CAST(' + QUOTENAME(@column_name) + ' AS FLOAT)) FROM EmployeeData) WHERE ordinal_position = ' + CAST(@i AS NVARCHAR);
            EXEC sp_executesql @sql;

            SET @sql = N'UPDATE #1 SET sd = (SELECT STDEV(TRY_CAST(' + QUOTENAME(@column_name) + ' AS FLOAT)) FROM EmployeeData) WHERE ordinal_position = ' + CAST(@i AS NVARCHAR);
            EXEC sp_executesql @sql;

            SET @sql = N'UPDATE #1 SET zero_values = (SELECT COUNT(*) FROM EmployeeData WHERE ' + QUOTENAME(@column_name) + ' = 0) WHERE ordinal_position = ' + CAST(@i AS NVARCHAR);
            EXEC sp_executesql @sql;
        END
        ELSE
        BEGIN
            SET @sql = N'UPDATE #1 SET zero_values = (SELECT COUNT(*) FROM EmployeeData WHERE TRY_CAST(' + QUOTENAME(@column_name) + ' AS DATE) = ''1900-01-01'') WHERE ordinal_position = ' + CAST(@i AS NVARCHAR);
            EXEC sp_executesql @sql;
        END
    END

    -- TEXTUAL columns
    ELSE IF @datatype IN ('VARCHAR','NVARCHAR','TEXT','CHAR','NCHAR')
    BEGIN
        -- MAX
        SET @sql = N'UPDATE #1 SET maximum = (SELECT MAX(' + QUOTENAME(@column_name) + ') FROM EmployeeData) WHERE ordinal_position = ' + CAST(@i AS NVARCHAR);
        EXEC sp_executesql @sql;

        -- MIN
        SET @sql = N'UPDATE #1 SET minimum = (SELECT MIN(' + QUOTENAME(@column_name) + ') FROM EmployeeData) WHERE ordinal_position = ' + CAST(@i AS NVARCHAR);
        EXEC sp_executesql @sql;

        -- ZERO values: Check string '0'
        SET @sql = N'UPDATE #1 SET zero_values = (SELECT COUNT(*) FROM EmployeeData WHERE ' + QUOTENAME(@column_name) + ' = ''0'') WHERE ordinal_position = ' + CAST(@i AS NVARCHAR);
        EXEC sp_executesql @sql;
    END

    -- NULLs (common to all)
    SET @sql = N'UPDATE #1 SET nulls = (SELECT COUNT(*) FROM EmployeeData WHERE ' + QUOTENAME(@column_name) + ' IS NULL) WHERE ordinal_position = ' + CAST(@i AS NVARCHAR);
    EXEC sp_executesql @sql;

    -- DISTINCT COUNT
    SET @sql = N'UPDATE #1 SET distinct_count = (SELECT COUNT(DISTINCT ' + QUOTENAME(@column_name) + ') FROM EmployeeData) WHERE ordinal_position = ' + CAST(@i AS NVARCHAR);
    EXEC sp_executesql @sql;

    -- MODE
    SET @sql = N'
        UPDATE #1 
        SET mode = (
            SELECT STRING_AGG(CAST(Value AS NVARCHAR(MAX)), '','') 
            FROM (
                SELECT Value, COUNT_ALL, DENSE_RANK() OVER (ORDER BY COUNT_ALL DESC) AS DR 
                FROM (
                    SELECT ' + QUOTENAME(@column_name) + ' AS Value, COUNT(*) AS COUNT_ALL
                    FROM EmployeeData
                    GROUP BY ' + QUOTENAME(@column_name) + '
                ) AS X
            ) AS Y
            WHERE DR = 1
        )
        WHERE ordinal_position = ' + CAST(@i AS NVARCHAR);
    EXEC sp_executesql @sql;

    -- MEDIAN (using TRY_CAST to avoid conversion errors)
    SET @sql = '
        DECLARE @cnt INT, @mid INT, @median FLOAT;

        IF OBJECT_ID(''tempdb..#tempMedian'') IS NOT NULL DROP TABLE #tempMedian;

        SELECT ' + QUOTENAME(@column_name) + ' AS val,
               ROW_NUMBER() OVER (ORDER BY TRY_CAST(' + QUOTENAME(@column_name) + ' AS FLOAT)) AS rn
        INTO #tempMedian
        FROM EmployeeData
        WHERE TRY_CAST(' + QUOTENAME(@column_name) + ' AS FLOAT) IS NOT NULL;

        SELECT @cnt = COUNT(*) FROM #tempMedian;
        SET @mid = @cnt / 2;

        IF @cnt % 2 = 0
            SELECT @median = AVG(TRY_CAST(val AS FLOAT)) FROM #tempMedian WHERE rn IN (@mid, @mid + 1);
        ELSE
            SELECT @median = TRY_CAST(val AS FLOAT) FROM #tempMedian WHERE rn = @mid + 1;

        UPDATE #1 SET median = @median WHERE ordinal_position = ' + CAST(@i AS NVARCHAR) + ';
    ';
    EXEC sp_executesql @sql;




   -- Inside your WHILE loop, after other type checks

IF @datatype = 'bit'
BEGIN
    -- ZERO values (bit = 0)
    SET @sql = N'
        UPDATE #1 
        SET zero_values = (
            SELECT COUNT(*) 
            FROM EmployeeData 
            WHERE ' + QUOTENAME(@column_name) + ' = 0
        ) 
        WHERE ordinal_position = ' + CAST(@i AS NVARCHAR);
    EXEC sp_executesql @sql;
END

-- NULL values (common for all)
SET @sql = N'
    UPDATE #1 
    SET nulls = (
        SELECT COUNT(*) 
        FROM EmployeeData 
        WHERE ' + QUOTENAME(@column_name) + ' IS NULL
    )
    WHERE ordinal_position = ' + CAST(@i AS NVARCHAR);
EXEC sp_executesql @sql;

-- DISTINCT count
SET @sql = N'
    UPDATE #1 
    SET distinct_count = (
        SELECT COUNT(DISTINCT ' + QUOTENAME(@column_name) + ') 
        FROM EmployeeData
    )
    WHERE ordinal_position = ' + CAST(@i AS NVARCHAR);
EXEC sp_executesql @sql;

-- MODE
SET @sql = N'
    UPDATE #1 
    SET mode = (
        SELECT STRING_AGG(CAST(Value AS NVARCHAR(MAX)), '','') 
        FROM (
            SELECT Value, COUNT_ALL, DENSE_RANK() OVER (ORDER BY COUNT_ALL DESC) AS DR 
            FROM (
                SELECT ' + QUOTENAME(@column_name) + ' AS Value, COUNT(*) AS COUNT_ALL
                FROM EmployeeData
                GROUP BY ' + QUOTENAME(@column_name) + '
            ) AS X
        ) AS Y
        WHERE DR = 1
    )
    WHERE ordinal_position = ' + CAST(@i AS NVARCHAR);
EXEC sp_executesql @sql;













    -- Debug
    PRINT '✅ Processed Column: ' + @column_name + ' | Data Type: ' + @datatype;

    -- Next
    SET @i = @i + 1;
END
