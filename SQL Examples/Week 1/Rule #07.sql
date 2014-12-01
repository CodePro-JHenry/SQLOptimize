USE AdventureWorks2014
GO


/*	RULE #7 - Avoid using CURSORs unless there is a REALLY good reason to (which there definitely are... on occasion)
*/
ALTER TABLE Person.Address
ADD UsedForShipping bit NOT NULL DEFAULT(0)
;

--- DON'T do this:
--- Loop through list of Addresses that have ever been used as a shipping address, and update flag in Person.Address table
DECLARE crs CURSOR FAST_FORWARD FOR
SELECT DISTINCT h.ShipToAddressID
FROM Sales.SalesOrderHeader h
;

DECLARE @AddressID int;
OPEN crs;
FETCH NEXT FROM crs INTO @AddressID;
WHILE @@FETCH_STATUS = 0
  BEGIN
	UPDATE Person.Address SET UsedForShipping = 1 WHERE AddressID = @AddressID;

	FETCH NEXT FROM crs INTO @AddressID;
  END

CLOSE crs;
DEALLOCATE crs;

SELECT COUNT(AddressID) FROM Person.Address WHERE UsedForShipping = 1;


--- DO do this:
UPDATE Person.Address SET UsedForShipping = 0	-- This is just to clear the flags so we can start over and compare to make sure this second query does the same thing as the first.0

UPDATE Person.Address
SET UsedForShipping = CASE WHEN h.ShipToAddressID IS NULL THEN 0 ELSE 1 END
FROM
	Person.Address a
		INNER JOIN Sales.SalesOrderHeader h
		ON (a.AddressID = h.ShipToAddressID)
;

SELECT COUNT(AddressID) FROM Person.Address WHERE UsedForShipping = 1;
