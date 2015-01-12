/*
	Tip #6
	Calculate Sequence within groups.
*/
USE AdventureWorks2014;
GO

--- View top/sequenced vendors based on items purchased per product category:
WITH
VendorProdCats (Vendor, ProductCategory, ItemsPurchased)
AS (
SELECT
	v.Name AS Vendor
,	c.Name AS ProductCategory
,	SUM(d.OrderQty) AS ItemsPurchased
FROM
	Purchasing.PurchaseOrderDetail d
		INNER JOIN	Production.Product p
		ON d.ProductID = p.ProductID
			INNER JOIN Purchasing.ProductVendor pv
			ON p.ProductID = pv.ProductID
				INNER JOIN Production.ProductSubcategory s
				ON p.ProductSubcategoryID = s.ProductSubcategoryID
					INNER JOIN Production.ProductCategory c
					ON s.ProductCategoryID = c.ProductCategoryID
						INNER JOIN Person.BusinessEntity b
						ON pv.BusinessEntityID = b.BusinessEntityID
							INNER JOIN Purchasing.Vendor v
							ON b.BusinessEntityID = v.BusinessEntityID
GROUP BY
	v.Name
,	c.Name
)
SELECT
	vnd.Vendor
,	vnd.ProductCategory
,	vnd.ItemsPurchased
,	ROW_NUMBER() OVER (PARTITION BY vnd.ProductCategory ORDER BY vnd.ItemsPurchased DESC) AS VendorRankForCategory
FROM
	VendorProdCats vnd
ORDER BY
	vnd.ProductCategory
,	vnd.ItemsPurchased DESC
;


