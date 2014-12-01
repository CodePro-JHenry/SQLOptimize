USE AdventureWorks2014
GO

/*	EXAMPLE #1
	Selecting all fields using * when only a subset of columns is needed
	vs.
	Selecting only the fields/columns needed.
*/
SELECT * FROM Sales.SalesOrderHeader

SELECT SalesOrderID, RevisionNumber, OrderDate, DueDate, ShipDate, Status FROM Sales.SalesOrderHeader
