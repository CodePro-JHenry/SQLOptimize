USE AdventureWorks2014
GO


/*	RULE #17 - Foreign Keys - use them, but be aware of their dark side.
	-	Foreign keys add a bit of overhead to write (INSERT, UPDATE, and DELETE) operations
	-	But, foreign keys can provide clues to the query optimizer so that it can eliminate unnecessary tables, scans, etc…. especially if the FK is indexed.
	-	Again, this is one that we can't demonstrate well against the AdventureWorks database.
*/

