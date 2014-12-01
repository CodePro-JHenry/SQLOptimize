USE AdventureWorks2014
GO


/*	RULE #4 - Avoid applying functions in join and filter expressions if possible
	-	Also, don't bother with UPPER() and LOWER() functions unless your database has specifically been set to be case-sensitive.
	-	To see the difference, while the time is not that different between these two queries in this particular example, 
		the execution plans highlight the difference.
		- The Index Seek is MUCH preferred over an Index Scan generally speaking... especially on tables with a large number of rows.
*/

--- DON'T do this:
SELECT
	b.*
FROM
	Production.BillOfMaterials b
		INNER JOIN Production.Product p
		ON b.ComponentID = p.ProductID
WHERE
	SUBSTRING(p.Name, 1, 5) = 'Chain'
;

--- DO do this:
SELECT
	b.*
FROM
	Production.BillOfMaterials b
		INNER JOIN Production.Product p
		ON b.ComponentID = p.ProductID
WHERE
	p.Name LIKE 'Chain%'
;

