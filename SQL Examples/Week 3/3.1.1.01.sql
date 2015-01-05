

--- Scenario:  We have special reporting queries for 3 of our territories: 6, 7, and 10 where we are often searching by CustomerID.

CREATE NONCLUSTERED INDEX IXF_Territory10 ON Sales.Customer (TerritoryID, CustomerID)
WHERE TerritoryID = 10;

CREATE NONCLUSTERED INDEX IXF_Territory7 ON Sales.Customer (TerritoryID, CustomerID)
WHERE TerritoryID = 7;

CREATE NONCLUSTERED INDEX IXF_Territory6 ON Sales.Customer (TerritoryID, CustomerID)
WHERE TerritoryID = 6;

