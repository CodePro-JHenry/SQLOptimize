USE AdventureWorks2014
GO


/*	
	Put your filters inside the sub-query/in-line view as much as possible.
	Usually, the optimizer will do this for you, but don't count on it - especially when
	things get more complicated.
*/

SELECT
	c.CustomerID
,	c.AccountNumber
,	q1.SalesOrderID
,	q1.OrderDate
FROM
	(
		SELECT
			h.CustomerID
		,	h.SalesOrderID
		,	h.OrderDate
		FROM
			Sales.SalesOrderHeader h
	) q1
		INNER JOIN Sales.Customer c
		ON q1.CustomerID = c.CustomerID
WHERE
	q1.OrderDate BETWEEN '6/1/2013' AND '6/30/2013'
;
	
SELECT
	c.CustomerID
,	c.AccountNumber
,	q1.SalesOrderID
,	q1.OrderDate
FROM
	(
		SELECT
			h.CustomerID
		,	h.SalesOrderID
		,	h.OrderDate
		FROM
			Sales.SalesOrderHeader h
		WHERE
			OrderDate BETWEEN '6/1/2013' AND '6/30/2013'
	) q1
		INNER JOIN Sales.Customer c
		ON q1.CustomerID = c.CustomerID
;

