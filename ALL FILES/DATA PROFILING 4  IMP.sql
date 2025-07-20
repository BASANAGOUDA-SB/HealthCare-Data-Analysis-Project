-- Use the correct database
USE [data profiling];

select * from EmployeeData
-- Drop temp table if it already exists
IF OBJECT_ID('tempdb..#2') IS NOT NULL 
DROP TABLE #2;

-- Create temp table with Salary and Row Number
SELECT Salary,ROW_NUMBER() OVER (ORDER BY Salary) AS rn INTO #2 FROM EmployeeData;

-- Optional: View the temp table
SELECT * FROM #2;

-- Declare variables
DECLARE @l INT;
DECLARE @m INT;
DECLARE @n INT;
DECLARE @x FLOAT;

-- Get the total number of rows and calculate values
SET @l = (SELECT MAX(rn) FROM #2);  -- Total rows
SET @m = @l % 2;                    -- Check odd/even
SET @n = @l / 2;                    -- Midpoint

-- Calculate median
IF @m = 0  -- Even number of records
BEGIN
    SET @x = (
        SELECT AVG(CAST(Salary AS FLOAT)) AS [Median Salary]
        FROM #2
        WHERE rn IN (@n, @n + 1)
    );
END

IF @m <> 0  -- Odd number of records
BEGIN
    SET @x = (
        SELECT Salary AS [Median Salary]
        FROM #2
        WHERE rn = @n + 1
    );
END