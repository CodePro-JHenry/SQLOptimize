USE AdventureWorks2014
GO


/*	RULE #2 - Avoid using correlated sub-queries in the SELECT list at all costs!
	- Almost all sub-queries within a SELECT list can be rewritten as a JOIN
*/
--- Display Customer informationn and include the date of the last Order that they placed
--- I'm using Order Date instead of SalesOrderID to show the difference in run-time/performance.  The performance difference (on these tables) 
--- isn't as significant when the sub-query is returning an indexed field.

--- DON'T do this:
SELECT
	c.CustomerID
,	LastSalesOrderDate = (SELECT MAX(OrderDate) FROM Sales.SalesOrderHeader WHERE CustomerID = c.CustomerID GROUP BY CustomerID)
FROM
	Sales.Customer c
--- The other problem, in this case, is that I can't write a simple filter to give me just customers who have had an order.
WHERE
	ISNULL((SELECT MAX(OrderDate) FROM Sales.SalesOrderHeader WHERE CustomerID = c.CustomerID GROUP BY CustomerID), '1/1/1900') <> '1/1/1900'
;

--- DO do this:
SELECT
	c.CustomerID
,	h.LastSalesOrderDate
FROM
	Sales.Customer c
		LEFT OUTER JOIN (
			SELECT
				CustomerID
			,	MAX(OrderDate) AS LastSalesOrderDate
			FROM
				Sales.SalesOrderHeader
			GROUP BY
				CustomerID
			) h
		ON (c.CustomerID = h.CustomerID)	
WHERE
	NOT h.LastSalesOrderDate IS NULL
;

--- OR, better yet, I can simply do an INNER join to filter out the customers with no order history:
--- This yields about the same performance as the previous query, but it's a little cleaner...
SELECT
	c.CustomerID
,	h.LastSalesOrderDate
FROM
	Sales.Customer c
		INNER JOIN (
			SELECT
				CustomerID
			,	MAX(OrderDate) AS LastSalesOrderDate
			FROM
				Sales.SalesOrderHeader
			GROUP BY
				CustomerID
			) h
		ON (c.CustomerID = h.CustomerID)	
;