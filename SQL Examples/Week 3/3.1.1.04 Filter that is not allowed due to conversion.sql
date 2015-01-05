

--SELECT * FROM Production.Product

CREATE NONCLUSTERED INDEX IXF_Product_SizeUnitMeasureCode_MakeFlag1 ON Production.Product (ProductID, ProductNumber)
WHERE CONVERT(varchar(3), MakeFlag) = '1';

DROP INDEX IXF_Product_SizeUnitMeasureCode_MakeFlag1 ON Production.Product;
