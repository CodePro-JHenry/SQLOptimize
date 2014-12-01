USE AdventureWorks2014
GO


/*	RULE #11 - NOT can truly be a negative influence.  Be careful when using the NOT (or other "negative") operator
	-	NOT can produce unexpected results when comparing Nullable fields.
	-	Using NOT or other negative operators (<>, !=, etc.) can sometimes prevent the query optimizer from using a useful index.
	-	When used as NOT IN or NOT EXISTS, it poses a couple of pitfalls:
		-	The values that are ultimately NOT in the set must be compared to every value in the set.  If you expect MOST of the rows
			from the source NOT to meet your criteria, then the NOT IN/EXISTS will cost you more than an alternative positive comparison.
*/

--- Demonstration of unexpected results:
--- Yields 2,562 rows.  Rows with ProductAssemblyID = NULL are not included.
SELECT b.*
FROM Production.BillOfMaterials b
WHERE
	NOT b.ProductAssemblyID = 800
;

--- Also yields 2,562 rows.  Rows with ProductAssemblyID = NULL are not included.
SELECT b.*
FROM Production.BillOfMaterials b
WHERE
	b.ProductAssemblyID <> 800
;

--- Yields 2,665 rows!
SELECT b.*
FROM Production.BillOfMaterials b
WHERE
	b.ProductAssemblyID IS NULL
OR NOT b.ProductAssemblyID = 800
;

