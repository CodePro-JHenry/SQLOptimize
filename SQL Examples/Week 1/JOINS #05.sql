USE AdventureWorks2014;
GO


--- Explicit CROSS JOIN:
SELECT
	p.BusinessEntityID
,	t.Name AS Territory
FROM
	Sales.SalesPerson p
	CROSS JOIN Sales.SalesTerritory t
ORDER BY
	p.BusinessEntityID
;

--- Implicit CROSS JOIN:
SELECT
	p.BusinessEntityID
,	t.Name AS Territory
FROM
	Sales.SalesPerson p, Sales.SalesTerritory t
ORDER BY
	p.BusinessEntityID
;

--- Unintentional, slightly restrictive CROSS JOIN (because condition always evaluates to TRUE, so long as SalesPerson.TerritoryID is not NULL):
SELECT
	p.BusinessEntityID
,	t.Name AS Territory
FROM
	Sales.SalesPerson p
		INNER JOIN Sales.SalesTerritory t
		ON (p.TerritoryID = p.TerritoryID)
ORDER BY
	p.BusinessEntityID
;

--- Turning a CROSS JOIN into an INNER JOIN with criteria in the WHERE clause:
SELECT
	p.BusinessEntityID
,	t.Name AS Territory
FROM
	Sales.SalesPerson p
	CROSS JOIN Sales.SalesTerritory t
WHERE
	p.TerritoryID = t.TerritoryID
ORDER BY
	p.BusinessEntityID
;



--- Use CROSS JOIN for creating dummy data - Use to create large number of records from combination of shorter lists.
DECLARE @tblFirstNames TABLE (FirstName varchar(20));
DECLARE @tblMiddleNames TABLE (MiddleName varchar(20));
DECLARE @tblLastNames TABLE (LastName varchar(20));
--DECLARE @tblStates TABLE ([State] char(2));

INSERT INTO @tblFirstNames (FirstName) VALUES ('Jeremy'), ('Michael'), ('Julie'), ('Tyrone'), ('Jim'), ('Angela'), ('Pat'), ('Benjamin'), ('Chris'), ('Lisa');
INSERT INTO @tblMiddleNames (MiddleName) VALUES ('Winston'), ('Ray'), ('Michele'), ('Morgan'), ('Lang');
INSERT INTO @tblLastNames (LastName) VALUES ('Henry'), ('Preston'), ('Jordan'), ('James'), ('Presley'), ('Jezewski'), ('Hall'), ('Schall');
--INSERT INTO @tblStates ([State]) VALUES ('SC'), ('OH'), ('CA'), ('NC'), ('FL'), ('GA'), ('OK'), ('TX'), ('AK'), ('AR'), ('ME'), ('NH'), ('MA'), ('MS'), ('NY');

SELECT
	f.FirstName
,	m.MiddleName
,	l.LastName
--,	s.State	
FROM
	@tblFirstNames f
,	@tblMiddleNames m
,	@tblLastNames l
--,	@tblStates s
;

