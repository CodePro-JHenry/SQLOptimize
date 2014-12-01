USE AdventureWorks2014
GO

/*	RULE #3 - Make sure all fields used in filters (WHERE clause) and JOINs are indexed/included in an index (if possible)
	- For this demonstration, we are going to create a copy of an existing table, but with no indexes (except for the Primary key)
	- We will query against the original table with an index on the field we are using to filter, and then run the same query against the copy (without the indexes)
*/

/*
DROP TABLE Sales.SalesOrderDetail2
SELECT * INTO Sales.SalesOrderDetail2 FROM Sales.SalesOrderDetail
*/

SELECT * FROM Sales.SalesOrderDetail WHERE ProductID = 773;

SELECT * FROM Sales.SalesOrderDetail2 WHERE ProductID = 773;
--- To see the difference between an indexed and non-indexed field being used, and because this is such a simple query, we have to 
--- clear the statistics after each run.  When the query is first run, there are no existing statistics (which you would have on an indexed table).
--- Statistics associated with an index cannot be deleted.  The index itself would have to be deleted.  That's one more reason to use indexed fields.
--- NOTE: The statistics name may differ on your computer...
DROP STATISTICS Sales.SalesOrderDetail2._WA_Sys_00000005_2F2FFC0C;
