

--- RIGHT outer joins can just make things more confusing... Rewrite with LEFT joins whenever possible.


SELECT
	c.CustomerID
,	p.FirstName + ' ' + p.LastName AS Name
,	ISNULL(s.NumberOrdered, 0) AS NumberOrdered
FROM
	(
	SELECT
		h.CustomerID
	,	SUM(d.OrderQty) AS NumberOrdered
	FROM
		Sales.SalesOrderDetail d
			INNER JOIN sales.SalesOrderHeader h
			ON d.SalesOrderID = h.SalesOrderID
	WHERE
		d.ProductID = 760
	GROUP BY
		h.CustomerID
	) s
		RIGHT OUTER JOIN Sales.Customer c
		ON s.CustomerID = c.CustomerID
			INNER JOIN Person.Person p
			ON c.PersonID = p.BusinessEntityID
WHERE
	ISNULL(s.NumberOrdered, 0) < 10	
;



SELECT
	c.CustomerID
,	p.FirstName + ' ' + p.LastName AS Name
,	ISNULL(s.NumberOrdered, 0) AS NumberOrdered
FROM
	Sales.Customer c
		INNER JOIN Person.Person p
		ON c.PersonID = p.BusinessEntityID
			LEFT OUTER JOIN
			(
			SELECT
				h.CustomerID
			,	SUM(d.OrderQty) AS NumberOrdered
			FROM
				Sales.SalesOrderDetail d
					INNER JOIN sales.SalesOrderHeader h
					ON d.SalesOrderID = h.SalesOrderID
			WHERE
				d.ProductID = 760
			GROUP BY
				h.CustomerID
			) s
			ON s.CustomerID = c.CustomerID
WHERE
	ISNULL(s.NumberOrdered, 0) < 10	
;


