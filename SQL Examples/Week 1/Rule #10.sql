USE AdventureWorks2014
GO


/*	RULE #10 - Use UNION ALL instead of UNION if possible (which is most of the time)
	- UNION selects only DISTINCT rows, whereas UNION ALL includes all rows.
	- If you know that the two queries will result in rows that are distinct from each other, use UNION ALL.
	- This is, again, a difficult one to demonstrate the performance difference with the AdventureWorks database,
	  but the execution plan does show the extra step involved in the UNION.  When working with large tables or more 
	  columns, this extra step can make a significant difference.
*/

SELECT FirstName, LastName, ISNULL(Title, '') AS Title FROM Person.Person WHERE PersonType IN (N'EM', N'SP')
UNION
SELECT p.FirstName, p.LastName, ISNULL(p.Title, '')
FROM
	HumanResources.Employee e
		INNER JOIN Person.Person p
		ON e.BusinessEntityID = p.BusinessEntityID
			INNER JOIN Sales.SalesPerson sp
			ON p.BusinessEntityID = sp.BusinessEntityID
ORDER BY
	FirstName, LastName
;



SELECT FirstName, LastName, ISNULL(Title, '') AS Title FROM Person.Person WHERE PersonType IN (N'EM', N'SP')
UNION ALL
SELECT p.FirstName, p.LastName, p.Title
FROM
	HumanResources.Employee e
		INNER JOIN Person.Person p
		ON e.BusinessEntityID = p.BusinessEntityID
			INNER JOIN Sales.SalesPerson sp
			ON p.BusinessEntityID = sp.BusinessEntityID
ORDER BY
	FirstName, LastName
;
