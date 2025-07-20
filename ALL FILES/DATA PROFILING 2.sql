



SELECT * FROM [dbo].[EmpSalary1]

SELECT * FROM [dbo].[EmpSalary2]

SELECT * FROM [dbo].[EmpSalary3]

SELECT * FROM [dbo].[EmpSalary4]


---- UNION ALL 
SELECT * INTO #1 FROM( 
SELECT * FROM [dbo].[EmpSalary1]
UNION ALL
SELECT * FROM [dbo].[EmpSalary2]
UNION ALL
SELECT * FROM [dbo].[EmpSalary3]
UNION ALL
SELECT * FROM [dbo].[EmpSalary4]
)X

SELECT * FROM #1

DECLARE @i INT = 1;
DECLARE @sql NVARCHAR(MAX);

select top 0 * into #2 from [dbo].[EmpSalary4]




while @i <=4
begin

set @sql = 'insert into #2  select *from  dbo.EmpSalary' + cast(@i as nvarchar(max))


exec sp_executesql @sql

set @i =@i+1
end


select * from #2