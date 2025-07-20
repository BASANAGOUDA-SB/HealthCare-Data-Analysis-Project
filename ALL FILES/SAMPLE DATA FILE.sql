

use healthcare

SELECT * FROM ClinicalData

SELECT *FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME LIKE 'ClinicalData'


DECLARE @i INT = 1;
DECLARE @sql NVARCHAR(MAX);
DECLARE @j INT;

-- Get total columns from the ClinicalData table
SET @j = (
    SELECT MAX(ordinal_position)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'ClinicalData'
);

DECLARE @columnname VARCHAR(MAX);

WHILE @i <= @j
BEGIN
    -- Get column name for current position
    SELECT @columnname = column_name
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'ClinicalData' AND ordinal_position = @i;

    -- Build the SQL with correct spacing
    SET @sql = 'SELECT [' + @columnname + '], COUNT(*) AS frequency FROM ClinicalData GROUP BY [' + @columnname + '] ORDER BY COUNT(*) DESC;';
    
    -- Execute dynamic SQL
    EXEC sp_executesql @sql;

    -- Move to next column
    SET @i = @i + 1;
END
