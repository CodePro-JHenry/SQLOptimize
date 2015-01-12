/*
	Tip #19
	Query the results of a Stored Procedure

	1) Create a temp table with the same field names (in the same order) and compatible data types for every field returned by the SP.
	2) Use INSERT INTO #temptablename EXEC sp_name [parameter]... 
	3) Query away.
	4) Be sure to drop your temp table when you're done.
*/

CREATE TABLE #tmp (
	ProductAssemblyID int NOT NULL
,	ComponentID int NOT NULL
,	ComponentDesc varchar(400) NOT NULL
,	TotalQuantity decimal(18,4) NOT NULL
,	StandardCost money NOT NULL
,	ListPrice money NULL
,	BOMLevel int NOT NULL
,	RecursionLevel int NOT NULL
);

INSERT INTO #tmp EXEC uspGetWhereUsedProductID 321, '10/1/2012';

SELECT * FROM #tmp WHERE TotalQuantity > 1;

DROP TABLE #tmp;


--- Alternatively, use OPENROWSET function:
sp_configure 'Show Advanced Options', 1
GO
RECONFIGURE
GO

sp_configure 'Ad Hoc Distributed Queries', 1
GO
RECONFIGURE
GO

SELECT * INTO #tmp FROM OPENROWSET('SQLNCLI', 'Server=ERS-Jeremy-LT\SQLEXPRESS2014;Trusted_Connection=yes;Database=AdventureWorks2014;', 'EXEC dbo.uspGetWhereUsedProductID 321, ''10/1/2012''')

SELECT * FROM #tmp WHERE TotalQuantity > 1;

DROP TABLE #tmp;
