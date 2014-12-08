USE AdventureWorks2014;
GO

--- Identify all Products that we have never sold on a Sales Order.
--- (or Sales Orders that have an invalid Product ID... which hasn't happened, and shouldn't be possible because of the database structure.)

SELECT
	p.Name
,	sod.SalesOrderID
FROM
	Production.Product p
		FULL OUTER JOIN Sales.SalesOrderDetail sod
		ON p.ProductID = sod.ProductID
WHERE
	p.ProductID IS NULL
OR	sod.ProductID IS NULL
ORDER BY
	p.Name
;

