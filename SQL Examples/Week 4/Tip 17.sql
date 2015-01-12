/*
	Tip #17
	Pivot tables

	1) In the PIVOT clause, you define your Aggregate() FOR [Field] whose values are IN (list) that you want to turn into individual columns
	2) Exclude any fields not being used in the PIVOT from your base query.  
		- Any fields NOT used by the pivot will be used to identify unique value combinations for which to aggregate.
		- If there are only 2 fields in the base query, both used - one for the aggregate function and the other for columns - you will get
		  just one total summary record
	3) Be sure to name your PIVOT () AS xxxx

	NOTE: Most PIVOT queries can be accomplished with conditional aggregation in a regular query.
*/


SELECT
	'AverageCost' AS Cost_Sorted_By_Production_Days
,	[0], [1], [2], [3], [4]
FROM
	(
	SELECT
		DaysToManufacture, StandardCost
	FROM Production.Product
	) a
PIVOT (
	AVG(a.StandardCost) FOR a.DaysToManufacture	IN ([0], [1], [2], [3], [4])
) AS PivotTable;


--- Cross-tabulation report
SELECT
	VendorID
,	[250] AS Emp1
,	[251] AS Emp2
,	[256] AS Emp3
,	[257] AS Emp4
,	[260] AS Emp5
FROM 
	(
	SELECT
		PurchaseOrderID, EmployeeID, VendorID
	FROM
		Purchasing.PurchaseOrderHeader
	) p
PIVOT
(
	COUNT (PurchaseOrderID) FOR EmployeeID IN ( [250], [251], [256], [257], [260] )
) AS pvt
ORDER BY pvt.VendorID
;

--- Accomplishing the same thing with conditional counting
SELECT
	VendorID
,	SUM(CASE EmployeeID WHEN 250 THEN 1 ELSE 0 END) AS Emp1
,	SUM(CASE EmployeeID WHEN 251 THEN 1 ELSE 0 END) AS Emp2
,	SUM(CASE EmployeeID WHEN 256 THEN 1 ELSE 0 END) AS Emp3
,	SUM(CASE EmployeeID WHEN 257 THEN 1 ELSE 0 END) AS Emp4
,	SUM(CASE EmployeeID WHEN 260 THEN 1 ELSE 0 END) AS Emp5
FROM Purchasing.PurchaseOrderHeader
GROUP BY
	VendorID
ORDER BY VendorID
;


/*
	Scenario:  Michael wants to figure out what day of the week is the best to take a vacation.  He wants to see what week days
	have historically received the most orders (by value).
*/
SELECT
	CustomerID
,	[1] AS 'Sunday'
,	[2] AS 'Monday'
,	[3] AS 'Tuesday'
,	[4] AS 'Wednesday'
,	[5] AS 'Thursday'
,	[6] AS 'Friday'
,	[7] AS 'Saturday'
FROM
	(
	SELECT
		h.CustomerID
--	,	h.SalesOrderID
--	,	h.SalesPersonID
	,	h.SubTotal
	,	DATEPART(WEEKDAY, h.OrderDate) AS [WeekDay]
	FROM
		Sales.SalesOrderHeader h
	WHERE
		h.SalesPersonID = 279
	) w
PIVOT (
	SUM(SubTotal) FOR [WeekDay] IN ([1], [2], [3], [4], [5], [6], [7])
--	COUNT(SalesOrderID) FOR [WeekDay] IN ([1], [2], [3], [4], [5], [6], [7])
) AS pvt
ORDER BY
	CustomerID
;

--- Now modify to condense down to single row
SELECT
	'Total Sales $$ To-Date' AS [Day of Week]
,	[1] AS 'Sunday'
,	[2] AS 'Monday'
,	[3] AS 'Tuesday'
,	[4] AS 'Wednesday'
,	[5] AS 'Thursday'
,	[6] AS 'Friday'
,	[7] AS 'Saturday'
FROM
	(
	SELECT
--		h.CustomerID
--	,	h.SalesOrderID
--	,	h.SalesPersonID
		h.SubTotal
	,	DATEPART(WEEKDAY, h.OrderDate) AS [WeekDay]
	FROM
		Sales.SalesOrderHeader h
	WHERE
		h.SalesPersonID = 279
	) w
PIVOT (
	SUM(SubTotal) FOR [WeekDay] IN ([1], [2], [3], [4], [5], [6], [7])
--	COUNT(SalesOrderID) FOR [WeekDay] IN ([1], [2], [3], [4], [5], [6], [7])
) AS pvt
;
