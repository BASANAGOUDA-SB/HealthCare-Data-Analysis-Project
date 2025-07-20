-- Use the correct database
USE [data profiling];

-- Step 1: Create #3 from EmployeeData
IF OBJECT_ID('tempdb..#3') IS NOT NULL 
    DROP TABLE #3;

SELECT * INTO #3 FROM EmployeeData;

-- Step 2: Delete EmployeeID = 10
DELETE FROM #3 WHERE EmployeeID = 10;

-- Step 3: Drop #2 if it already exists
IF OBJECT_ID('tempdb..#2') IS NOT NULL 
    DROP TABLE #2;

-- Step 4: Create #2 with Salary and row numbers
SELECT Salary, ROW_NUMBER() OVER (ORDER BY Salary) AS rn INTO #2 FROM #3;

-- Step 5: View #2 (optional)
SELECT * FROM #2;

-- Step 6: Declare variables
DECLARE @l INT, @m INT, @n INT;

-- Step 7: Set values for median calculation
SET @l = (SELECT MAX(rn) FROM #2); -- total rows
SET @m = @l % 2;                   -- odd/even
SET @n = @l / 2;                   -- midpoint

-- Step 8: Median calculation
IF @m = 0  -- Even number of records
BEGIN

    SELECT AVG(Salary) AS [Median Salary]
    FROM #2
    WHERE rn IN (@n, @n + 1);

END

IF @m <> 0  -- Odd number of records

BEGIN

    SELECT Salary AS [Median Salary]
    FROM #2
    WHERE rn = @n + 1;

END
