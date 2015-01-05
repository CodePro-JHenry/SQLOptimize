
-- Scenario:  We have several queries that are run frequently that search for specific products within products that have SizeUnitMeasureCode of 'CM'

--SELECT * FROM Production.Product WHERE ISNULL(SizeUnitMeasureCode, '') = 'CM'

CREATE NONCLUSTERED INDEX IXF_Product_SizeUnitMeasureCode_CM ON Production.Product (ProductID, ProductNumber)
WHERE SizeUnitMeasureCode = 'CM';
