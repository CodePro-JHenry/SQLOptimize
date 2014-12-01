USE AdventureWorks2014
GO


/*	RULE #8 - Sequence your filter criteria in your WHERE clause
	-	Usually, the query optimizer will do this for you, but it's good practice for those times (in complex queries) when the 
		query optimizer engine might not get it right
	-	Put (expected) most selective first.
	-	In these examples, the query optimizer essentially creates the same execution plan regardless.  But when you have very complex queries
		joining lots of views and/or sub-queries, ordering your criteria can provide the clues the optimizer might miss.
*/


SELECT
	h.SalesOrderID
,	h.CustomerID
,	p.FirstName + ' ' + p.LastName AS SalesPersonName
,	e.JobTitle
,	d.NumItemsOrdered
,	sp.Name AS StateProvince
,	tx.TaxRate
FROM
	Sales.SalesOrderHeader h
		INNER JOIN (
			SELECT
				d.SalesOrderID
			,	COUNT(d.ProductID) AS NumItemsOrdered
			FROM
				Sales.SalesOrderDetail d
			GROUP BY
				d.SalesOrderID
		) d
		ON h.SalesOrderID = d.SalesOrderID
			INNER JOIN HumanResources.Employee e
			ON h.SalesPersonID = e.BusinessEntityID
				INNER JOIN Person.Person p
				ON h.SalesPersonID = p.BusinessEntityID
					INNER JOIN Person.Address a
					ON h.ShipToAddressID = a.AddressID
						INNER JOIN Person.StateProvince sp
						ON a.StateProvinceID = sp.StateProvinceID
							INNER JOIN Sales.SalesTaxRate tx
							ON sp.StateProvinceID = tx.StateProvinceID
				
WHERE
	h.OrderDate BETWEEN '1/1/2013' AND '12/31/2013'	-- 14,182
AND	h.TotalDue >= 10000.00	-- 1,878
AND	d.NumItemsOrdered > 50	-- 145
AND sp.Name LIKE 'California%'
;

SELECT
	h.SalesOrderID
,	h.CustomerID
,	p.FirstName + ' ' + p.LastName AS SalesPersonName
,	e.JobTitle
,	d.NumItemsOrdered
,	sp.Name AS StateProvince
,	tx.TaxRate
FROM
	Sales.SalesOrderHeader h
		INNER JOIN (
			SELECT
				d.SalesOrderID
			,	COUNT(d.ProductID) AS NumItemsOrdered
			FROM
				Sales.SalesOrderDetail d
			GROUP BY
				d.SalesOrderID
		) d
		ON h.SalesOrderID = d.SalesOrderID
			INNER JOIN HumanResources.Employee e
			ON h.SalesPersonID = e.BusinessEntityID
				INNER JOIN Person.Person p
				ON h.SalesPersonID = p.BusinessEntityID
					INNER JOIN Person.Address a
					ON h.ShipToAddressID = a.AddressID
						INNER JOIN Person.StateProvince sp
						ON a.StateProvinceID = sp.StateProvinceID
							INNER JOIN Sales.SalesTaxRate tx
							ON sp.StateProvinceID = tx.StateProvinceID
WHERE
	d.NumItemsOrdered > 50	-- 145
AND	h.TotalDue >= 10000.00	-- 1,878
AND	h.OrderDate BETWEEN '1/1/2013' AND '12/31/2013'	-- 14,182
AND sp.Name LIKE 'California%'
;


