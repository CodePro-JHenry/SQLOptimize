

--- Non-deterministic view

CREATE VIEW Production.vSellEndGT2yrs WITH SCHEMABINDING
AS
SELECT
	p.ProductID
,	p.SellStartDate
,	p.SellEndDate
FROM
	Production.Product p
WHERE
	p.SellEndDate < DATEADD(YEAR, -2, GETDATE())
;
GO


CREATE UNIQUE CLUSTERED INDEX [IX_vSellEndGT2yrs] ON Production.vSellEndGT2yrs
(
	[ProductID] ASC,
	[SellEndDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
				

DROP VIEW Production.vSellEndGT2yrs;
