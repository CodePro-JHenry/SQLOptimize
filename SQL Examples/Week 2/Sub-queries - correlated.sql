USE AdventureWorks2014
GO


/*
	Rewrite a correlated sub-query as an in-line view in the FROM clause.
	If the purpose of the correlated sub-query is to get aggregates, you might
	be able to do away with the sub-query altogether.	
*/

SELECT
	c.CustomerID
,	c.AccountNumber
,	h.SalesOrderID
,	h.OrderDate
,	MaxItemValue = (
					SELECT
						MAX(d.UnitPrice) AS MaxItemValue
					FROM
						Sales.SalesOrderDetail d
					WHERE
						d.SalesOrderID = h.SalesOrderID
					)
FROM
	Sales.SalesOrderHeader h
		INNER JOIN Sales.Customer c
		ON h.CustomerID = c.CustomerID
WHERE
	h.OrderDate BETWEEN '6/1/2013' AND '6/30/2013'
;



SELECT
	c.CustomerID
,	c.AccountNumber
,	h.SalesOrderID
,	h.OrderDate
,	d1.MaxItemValue
FROM
	Sales.SalesOrderHeader h
		INNER JOIN Sales.Customer c
		ON h.CustomerID = c.CustomerID
			INNER JOIN (
				SELECT
					d.SalesOrderID
				,	MAX(d.UnitPrice) AS MaxItemValue
				FROM
					Sales.SalesOrderDetail d
				GROUP BY
					d.SalesOrderID
			) d1
			ON h.SalesOrderID = d1.SalesOrderID
WHERE
	h.OrderDate BETWEEN '6/1/2013' AND '6/30/2013'
;
	



SELECT
	c.CustomerID
,	c.AccountNumber
,	h.SalesOrderID
,	h.OrderDate
,	MAX(d.UnitPrice) AS MaxItemValue
FROM
	Sales.SalesOrderHeader h
		INNER JOIN Sales.Customer c
		ON h.CustomerID = c.CustomerID
			INNER JOIN Sales.SalesOrderDetail d
			ON h.SalesOrderID = d.SalesOrderID
WHERE
	h.OrderDate BETWEEN '6/1/2013' AND '6/30/2013'
GROUP BY
	c.CustomerID
,	c.AccountNumber
,	h.SalesOrderID
,	h.OrderDate
;
