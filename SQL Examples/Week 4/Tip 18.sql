/*
	Tip #18
	Generate dynamic SQL for dynamic Columns in a PIVOT query.
*/

--- First, example of a common PIVOT table:
SELECT *
FROM
	(
	SELECT
		CustomerID
	,	YEAR(OrderDate) AS OrderYear
	,	TotalDue
	FROM
		Sales.SalesOrderHeader
	) header
PIVOT (
	SUM(TotalDue) FOR OrderYear IN ([2011],[2012],[2013])
) AS pvt
ORDER BY
	CustomerID
;

--- But that only displays the years we specify.
--- What if we want the Year columns to be dynamic instead of having to modify our query to add new years?

--- First, generate a delimited string of all the years
DECLARE @years VARCHAR(1000)
WITH Years
AS
(
	SELECT DISTINCT Year(OrderDate) AS Year
	FROM Sales.SalesOrderHeader
)
SELECT
	@years = ISNULL(@years+ ',[','[')+ CAST([Year] AS NVARCHAR(10))+']'
FROM Years
ORDER BY Year
;

--- Now build our PIVOT SQL statement dynamically and store as a varchar
DECLARE @sql  nvarchar(max)
SET @sql =
	'SELECT *
	FROM
		(
		SELECT
			CustomerID
		,	YEAR(OrderDate) AS OrderYear
		,	TotalDue
		FROM
			Sales.SalesOrderHeader
		) header
	PIVOT (
		SUM(TotalDue) FOR OrderYear IN ('+   @years+ ')
	) AS pvt
	ORDER BY
		CustomerID';

--- Finally, execute the SQL string using the sp_executesql built-in SP
EXEC sp_executesql @sql

