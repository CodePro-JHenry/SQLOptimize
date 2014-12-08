USE AdventureWorks2014;
GO

--- Consider when using a LEFT JOIN: If you are applying filter criteria against the right-side table
--- in the main WHERE clause, the tables will be joined first, and then the filter applies.
--- But because NULLs won't match the filter criteria, you will lose records from the left table - effectively making the query
--- behave like an INNER JOIN.
--- To avoid this and get records from the LEFT table that have no match, include the filter criteria in the ON clause of the LEFT JOIN.
--- Or, if the right-side is a subquery, include the criteria in the sub-query.


SELECT
	c.CustomerID
,	ISNULL(o.NumberOfOrders, 0) AS NumberOfOrders
FROM 
	Sales.Customer c
		LEFT OUTER JOIN (
			SELECT
				h.CustomerID
			,	COUNT(h.SalesOrderID) AS NumberOfOrders
			FROM
				Sales.SalesOrderHeader h
			GROUP BY
				h.CustomerID
			) o
		ON (c.CustomerID = o.CustomerID)
WHERE
	o.NumberOfOrders < 2
;


SELECT
	c.CustomerID
,	ISNULL(o.NumberOfOrders, 0) AS NumberOfOrders
FROM 
	Sales.Customer c
		LEFT OUTER JOIN (
			SELECT
				h.CustomerID
			,	COUNT(h.SalesOrderID) AS NumberOfOrders
			FROM
				Sales.SalesOrderHeader h
			GROUP BY
				h.CustomerID
			) o
		ON (c.CustomerID = o.CustomerID) AND (o.NumberOfOrders < 2)
;