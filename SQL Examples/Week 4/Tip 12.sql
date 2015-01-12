/*
	Tip #12
	Determine Quarter

*/

DECLARE @TodaysDate date;
SET @TodaysDate = '2/14/2012';

SELECT
	YEAR(h.OrderDate) AS Yr
,	MONTH(h.OrderDate) AS Mth
,	FLOOR((MONTH(h.OrderDate) - 1) / 3) + 1 AS Qrtr
,	h.TotalDue
FROM
	Purchasing.PurchaseOrderHeader h
ORDER BY
	h.OrderDate
;


--- Q: What if your fiscal reporting year doesn't start with January???
--- A: Simply subtract from all dates, the offset in MONTHS from the 1st of the calendar year to the beginning month of your fiscal year.
--- Example:  Your company's Fiscal Year starts with June.  That means that the first 5 months of the calendar year belong to the previous Fiscal Year.
SELECT
	YEAR(DATEADD(MONTH, -5, h.OrderDate)) AS FiscalYr
,	Year(h.OrderDate) AS CalendarYr
,	MONTH(h.OrderDate) AS Mth
,	FLOOR((MONTH(DATEADD(MONTH, -5, h.OrderDate)) - 1) / 3) + 1 AS Qrtr
,	h.TotalDue
FROM
	Purchasing.PurchaseOrderHeader h
ORDER BY
	h.OrderDate
;


