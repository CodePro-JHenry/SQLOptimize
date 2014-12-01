USE AdventureWorks2014
GO

/*	RULE #1 - Select only the fields you need instead of using *
	Selecting all fields using * when only a subset of columns is needed
	vs.
	Selecting only the fields/columns needed.
*/
-- ToDo:  Refine this to include the example in a join.

SELECT * FROM Sales.SalesOrderHeader

SELECT SalesOrderID, RevisionNumber, OrderDate, DueDate, ShipDate, Status FROM Sales.SalesOrderHeader
