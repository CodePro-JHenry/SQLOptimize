USE AdventureWorks2014
GO


/*	RULE #9 - Don't use the HAVING clause to apply basic filters.
	-	Again, unfortunately, this example doesn't really demonstrate the performance difference because the query optimizer is smart
		enough to create the same execution plan.
	-	The SQL Standard states that the HAVING clause is applied after the primary result set is determined.  The query optimizer doesn't 
		always follow this rule if it recognizes the criteria in the HAVING as a basic filter, so this isn't usually a big problem.
	-	However, there are some complex scenarios (especially in real-world scenarios where the DB is not nearly normalized or indexed
		like it should be) where this small tip can make a difference.
	-	Besides, putting basic filter criteria in the HAVING clause is just bad form!
*/

--- DON'T do this:
SELECT
	d.SalesOrderID
,	d.OrderQty
,	COUNT(d.ProductID) AS NumItemsOrdered
FROM
	Sales.SalesOrderDetail d
GROUP BY
	d.SalesOrderID
,	d.OrderQty
HAVING
	d.OrderQty >= 20
;

--- DO do this:
SELECT
	d.SalesOrderID
,	d.OrderQty
,	COUNT(d.ProductID) AS NumItemsOrdered
FROM
	Sales.SalesOrderDetail d
WHERE
	d.OrderQty >= 20
GROUP BY
	d.SalesOrderID
,	d.OrderQty
;