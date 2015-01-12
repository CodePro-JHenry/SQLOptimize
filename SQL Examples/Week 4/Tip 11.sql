/*
	Tip #11
	Test for Current Month and Previous Month

*/

DECLARE @TodaysDate date;
SET @TodaysDate = '2/14/2012';

SELECT
	h.*
FROM
	Purchasing.PurchaseOrderHeader h
WHERE
	--- Current month
	(YEAR(h.OrderDate) = YEAR(@TodaysDate))
AND	(MONTH(h.OrderDate) = MONTH(@TodaysDate))
;


SELECT
	h.*
FROM
	Purchasing.PurchaseOrderHeader h
WHERE
	--- Previous month
	(YEAR(h.OrderDate) = YEAR(DATEADD(MONTH, -1, @TodaysDate)))
AND	(MONTH(h.OrderDate) = MONTH(DATEADD(MONTH, -1, @TodaysDate)))


