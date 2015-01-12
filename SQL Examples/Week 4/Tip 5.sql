/*
	Tip #5
	Calculate Ranks.

	
*/
USE AdventureWorks2014;
GO

WITH
SalesNumbers (SalesPersonID, TotalSales, TotalVolume) AS (
SELECT
	h.SalesPersonID
,	SUM(h.SubTotal) AS TotalSales
,	SUM(d.ItemsSold) AS TotalVolume
FROM
	Sales.SalesOrderHeader h
		INNER JOIN (SELECT d.SalesOrderID, COUNT(d.SalesOrderID) AS ItemsSold FROM Sales.SalesOrderDetail d GROUP BY d.SalesOrderID) d
		ON h.SalesOrderID = d.SalesOrderID
GROUP BY
	h.SalesPersonID
)
SELECT
	s.SalesPersonID
,	s.TotalSales
,	s.TotalVolume
,	RANK() OVER (ORDER BY s.TotalSales DESC) SalesRank
,	RANK() OVER (ORDER BY s.TotalVolume DESC) VolumeRank
FROM
	SalesNumbers s
ORDER BY
	s.TotalVolume DESC
;


