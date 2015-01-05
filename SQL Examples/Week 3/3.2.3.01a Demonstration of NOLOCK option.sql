

--- Start an update transaction to update ProductVendor
BEGIN TRAN

UPDATE Purchasing.ProductVendor
SET StandardPrice = 50.00
WHERE
	ProductID = 1
AND BusinessEntityID = 1580


--- DON'T include this following line when you execute initially.  But be sure to come back and execute this later...
ROLLBACK TRAN
