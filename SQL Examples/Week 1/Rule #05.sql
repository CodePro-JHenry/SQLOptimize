USE AdventureWorks2014
GO


/*	RULE #5 - Filter tables/sub-queries used in JOINs first in the FROM clause instead of the main WHERE clause
	-	NOTE: Usually, the query optimizer will use this logic anyhow when it creates its execution plan, but sometimes - especially in complex
		or very deep queries with several views/sub-queries - the optimizer gets hung up on some other aspect of joins and ends up applying
		the filter later.
	-	You want to ensure that the query optimizer retrieves and works with the minimal number of rows possible at each step of the execution.
	-	There are two possible options:
		1) put the filter in the ON clause of the JOIN - even though the operator will actually only be comparing a field from ONE of the tables
		2) create a sub-query around the table or view in the main FROM clause and add the criteria in the sub-query's WHERE clause
*/



