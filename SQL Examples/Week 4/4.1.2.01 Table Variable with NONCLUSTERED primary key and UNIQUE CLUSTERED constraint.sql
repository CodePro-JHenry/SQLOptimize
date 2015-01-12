


--- Create table variable with NONCLUSTERED primary key and UNIQUE CLUSTERED constraint/index
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

SELECT
	* 
FROM @tVar
WHERE CustomerID = 29958
;
