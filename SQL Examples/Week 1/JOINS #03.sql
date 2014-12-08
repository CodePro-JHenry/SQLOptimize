USE AdventureWorks2014;
GO

--- While both of these perform at about the same speed on my computer, the execution plans show a significant difference in query costs.
--- NOTE: In this case, it is primarily due to the Merge Join operation that the second query uses.

SELECT
	ProductID
FROM
	Production.Product
WHERE
	ProductID NOT IN (
		SELECT ProductID
		FROM Production.WorkOrder
	)
;
GO


SELECT
	p.ProductID
FROM
	Production.Product p
		LEFT JOIN Production.WorkOrder w
		ON p.ProductID = w.ProductID
WHERE
	w.ProductID IS NULL
;
GO
