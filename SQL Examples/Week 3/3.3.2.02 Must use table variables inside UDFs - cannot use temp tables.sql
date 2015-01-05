
--- Error trying to use Temp table inside user-defined function
CREATE FUNCTION fncTest1(@CustomerID int) RETURNS int
AS
BEGIN

CREATE TABLE #tVar (
	SalesOrderID int NOT NULL PRIMARY KEY NONCLUSTERED	
,	CustomerID int NOT NULL
,	PurchaseOrderNumber nvarchar(25) NOT NULL
,	UNIQUE CLUSTERED (CustomerID, PurchaseOrderNumber)
)
;

INSERT INTO #tVar
SELECT SalesOrderID, CustomerID, PurchaseOrderNumber
FROM Sales.SalesOrderHeader
WHERE
	TotalDue > 30000
;

DECLARE @ret int;

IF EXISTS (
			SELECT
				SalesOrderID 
			FROM #tVar
			WHERE CustomerID = @CustomerID
			)
	SET @ret = 1;
ELSE
	SET @ret = 0;

DROP TABLE #tVar;

RETURN @ret;

END
;
GO



CREATE FUNCTION fncTest1(@CustomerID int) RETURNS int
AS
BEGIN

DECLARE @tVar AS TABLE (
	SalesOrderID int NOT NULL PRIMARY KEY NONCLUSTERED	
,	CustomerID int NOT NULL
,	PurchaseOrderNumber nvarchar(25) NOT NULL
,	UNIQUE CLUSTERED (CustomerID, PurchaseOrderNumber)
)
;

INSERT INTO @tVar
SELECT SalesOrderID, CustomerID, PurchaseOrderNumber
FROM Sales.SalesOrderHeader
WHERE
	TotalDue > 30000
;

DECLARE @ret int;

IF EXISTS (
			SELECT
				SalesOrderID 
			FROM @tVar
			WHERE CustomerID = @CustomerID
			)
	SET @ret = 1;
ELSE
	SET @ret = 0;

RETURN @ret;

END
GO


--DROP FUNCTION fncTest1;
