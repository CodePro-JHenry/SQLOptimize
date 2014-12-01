USE AdventureWorks2014
GO

/*	RULE #16 - Specify the Index to use with WITH (Index(idxName)) after the table in the FROM clause
	-	WARNING! As this demonstration shows, sometimes adding HINTS can have a higher cost than letting the query optimizer do its own thing!
	-	Both queries execute in close to the same time, but the cost of the second query (with the hint) is a bit higher.
	-	However, there may be times when the engine doesn't appear to be using the Index you think it OUGHT to be using... in those cases, give a hint a try.
*/

SELECT
	h.SalesOrderID
,	d.OrderQty
,	p.Name
FROM
	Sales.SalesOrderHeader h
		INNER JOIN Sales.SalesOrderDetail d 
		ON h.SalesOrderID = d.SalesOrderID
			INNER JOIN Production.Product p
			ON d.ProductID = p.ProductID
WHERE
	p.ProductID = 800


SELECT
	h.SalesOrderID
,	d.OrderQty
,	p.Name
FROM
	Sales.SalesOrderHeader h
		INNER JOIN Sales.SalesOrderDetail d WITH (INDEX(IX_SalesOrderDetail_ProductID))
		ON h.SalesOrderID = d.SalesOrderID
			INNER JOIN Production.Product p
			ON d.ProductID = p.ProductID
WHERE
	p.ProductID = 800