/*
	Tip #8
	Sub-totals using WITH ROLLUP.
*/
DECLARE @tTmp AS TABLE (
	YrMth int NOT NULL
);
INSERT INTO @tTmp VALUES
(201301), (201302), (201303), (201304), (201305), (201306), (201307), (201308), (201309), (201310), (201311), (201312);

SELECT
	vnd.Name AS Vendor
,	t.YrMth
,	SUM(d.LineTotal) AS TotalOrdered
FROM
	@tTmp t
		--- Make sure we get the Vendor name returned even if we had no purchases from the vendor in the month.
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
,	t.YrMth
WITH ROLLUP
;



