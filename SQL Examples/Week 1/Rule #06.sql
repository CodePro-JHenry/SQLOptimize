USE AdventureWorks2014
GO


/*	RULE #6 - When using a calculation expression in a search argument (SARG), try to apply the expression to the non-column side of the comparison operator
	-	Looking at the execution plans reveals that the Filter is expected to have a slightly higher cost in the first case.
	-	This slight difference in cost can REALLY add up when querying much larger tables or more complex criteria.
*/

--- DON'T do this:
SELECT d.*
FROM Sales.SalesOrderDetail d
WHERE
	d.UnitPrice * 1.08 >= 1080.00


--- DO do this:
SELECT d.*
FROM Sales.SalesOrderDetail d
WHERE
	d.UnitPrice >= 1080.00 / 1.08
