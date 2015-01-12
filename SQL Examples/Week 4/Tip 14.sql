/*
	Tip #14
	Count with conditions and "bucket" your counts/data
*/

SELECT
	SUM(CASE wo.ScrapReasonID WHEN 2 THEN 1 ELSE 0 END) AS WOsWithScrap_ColorIncorrect
,	SUM(CASE wo.ScrapReasonID WHEN 3 THEN 1 ELSE 0 END) AS WOsWithScrap_GougeInMetal
,	SUM(CASE wo.ScrapReasonID WHEN 8 THEN 1 ELSE 0 END) AS WOsWithScrap_PaintProcessFailed
,	SUM(CASE wo.ScrapReasonID WHEN 11 THEN 1 ELSE 0 END) AS WOsWithScrap_StressTestFailed

,	SUM(CASE wo.ScrapReasonID WHEN 2 THEN wo.ScrappedQty ELSE 0 END) AS ScrapQty_ColorIncorrect
,	SUM(CASE wo.ScrapReasonID WHEN 3 THEN wo.ScrappedQty ELSE 0 END) AS ScrapQty_GougeInMetal
,	SUM(CASE wo.ScrapReasonID WHEN 8 THEN wo.ScrappedQty ELSE 0 END) AS ScrapQty_PaintProcessFailed
,	SUM(CASE wo.ScrapReasonID WHEN 11 THEN wo.ScrappedQty ELSE 0 END) AS ScrapQty_StressTestFailed

,	SUM(CASE wo.ScrapReasonID WHEN 2 THEN p.StandardCost ELSE 0 END) AS ScrapValue_ColorIncorrect
,	SUM(CASE wo.ScrapReasonID WHEN 3 THEN p.StandardCost ELSE 0 END) AS ScrapValue_GougeInMetal
,	SUM(CASE wo.ScrapReasonID WHEN 8 THEN p.StandardCost ELSE 0 END) AS ScrapValue_PaintProcessFailed
,	SUM(CASE wo.ScrapReasonID WHEN 11 THEN p.StandardCost ELSE 0 END) AS ScrapValue_StressTestFailed
FROM
	Production.WorkOrder wo
		INNER JOIN Production.Product p
		ON wo.ProductID = p.ProductID
WHERE
	wo.StartDate BETWEEN '1/1/2012' AND '12/31/2012'
;
