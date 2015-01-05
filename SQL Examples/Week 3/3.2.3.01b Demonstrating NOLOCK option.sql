

--- Try executing this before you commit/rollback active transaction in other window.
SELECT v.* 
FROM
	Purchasing.ProductVendor v
WHERE
	v.ProductID = 1
AND v.BusinessEntityID = 1580


--- No try executing this before and after you commit/rollback active transaction in other window.
SELECT v.* 
FROM
	Purchasing.ProductVendor v WITH (NOLOCK)
WHERE
	v.ProductID = 1
AND v.BusinessEntityID = 1580
