


WITH Prod2007 (ProductNumber,Amount)
AS
(
     SELECT
		Prod.ProductNumber
	,	SUM(LineTotal)
     FROM
		Sales.SalesOrderDetail SOD
			INNER JOIN Sales.SalesOrderHeader SOH
			ON SOD.SalesOrderID = SOH.SalesOrderID
				INNER JOIN Production.Product Prod
				ON Prod.ProductID = SOD.ProductID
     WHERE
		YEAR(OrderDate) = 2007
     GROUP BY
		Prod.ProductNumber
)
,
Prod2008 (ProductNumber,Amount)
AS
(
	SELECT
		Prod.ProductNumber,
		SUM(LineTotal)
	FROM
		Sales.SalesOrderDetail SOD
			INNER JOIN Sales.SalesOrderHeader SOH
			ON SOD.SalesOrderID = SOH.SalesOrderID
				INNER JOIN Production.Product Prod
				ON Prod.ProductID = SOD.ProductID
     WHERE
		YEAR(OrderDate) = 2008
     GROUP BY
		Prod.ProductNumber
)
SELECT
	Prod2007.ProductNumber
,	Prod2007.Amount Sales2007
,	Prod2008.Amount Sales2008
,	Prod2008.Amount - Prod2007.Amount SalesIncrement
FROM
	Prod2007
		INNER JOIN   Prod2008
		ON Prod2007.ProductNumber = Prod2008.ProductNumber
