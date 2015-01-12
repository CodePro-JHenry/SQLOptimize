/*
	Tip #7
	Keep a running total.

	WARNING: This technique can be pretty resource intensive.
*/
DECLARE @tTmp AS TABLE (
	YrMth int NOT NULL
);
INSERT INTO @tTmp VALUES
(201301), (201302), (201303), (201304), (201305), (201306), (201307), (201308), (201309), (201310), (201311), (201312);

--- Get purchase totals for Vendor by month
WITH
VndMthTots (Vendor, VendorID, YrMth, TotalOrdered) AS (
SELECT
	vnd.Name AS Vendor
,	vnd.BusinessEntityID AS VendorID
,	t.YrMth
,	SUM(d.LineTotal) AS TotalOrdered
FROM
	@tTmp t
		--- Make sure we get the Vendor name (and ID) returned even if we had no purchases from the vendor in the month.
		INNER JOIN Purchasing.Vendor vnd
		ON 1 = 1
			LEFT OUTER JOIN (
			Purchasing.PurchaseOrderHeader h
				INNER JOIN Purchasing.PurchaseOrderDetail d
				ON h.PurchaseOrderID = d.PurchaseOrderID
			)
			ON t.YrMth = ((100 * YEAR(h.OrderDate)) + MONTH(h.OrderDate)) AND (vnd.BusinessEntityID = h.VendorID)
GROUP BY
	vnd.Name
,	vnd.BusinessEntityID
,	t.YrMth
)
--- Show running total - YTD 
SELECT
	v1.Vendor
,	v1.VendorID
,	v1.YrMth
,	v1.TotalOrdered
,	SUM(v2.TotalOrdered) AS YTDOrdered
FROM
	VndMthTots v1
		INNER JOIN VndMthTots v2
		ON v1.VendorID = v2.VendorID AND v1.YrMth >= v2.YrMth
GROUP BY
	v1.Vendor
,	v1.VendorID
,	v1.YrMth
,	v1.TotalOrdered
;


