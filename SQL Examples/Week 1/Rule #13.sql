USE AdventureWorks2014
GO


/*	RULE #13 - If you are just trying to see if any records exist given certain criteria, use EXISTS() instead of COUNT() to determine if any records exist.
	-	To do a COUNT(), the query has to get all records
	-	EXISTS() can stop as soon as it finds one instance
*/

-- Did we sell any items in 2013?

--- DON'T do this:
DECLARE @Count AS int
SELECT @Count = COUNT(d.SalesOrderDetailID)
FROM
	Sales.SalesOrderHeader h
		INNER JOIN Sales.SalesOrderDetail d
		ON h.SalesOrderID = d.SalesOrderID
WHERE
	h.OrderDate BETWEEN '1/1/2013' AND '12/31/2013'

IF @Count > 0
	PRINT 'YES'
ELSE
	PRINT 'NO'


--- DO do this:
IF EXISTS(
		SELECT d.SalesOrderDetailID
		FROM
			Sales.SalesOrderHeader h
				INNER JOIN Sales.SalesOrderDetail d
				ON h.SalesOrderID = d.SalesOrderID
		WHERE
			h.OrderDate BETWEEN '1/1/2013' AND '12/31/2013'
		)
	PRINT 'YES'
ELSE
	PRINT 'NO'
