USE [AdventureWorks2014]
GO

/*
	Don't overcomplicate your sub-queries
*/


SELECT
	dpt.BusinessEntityID
,	dpt.Department
,	dpt.FirstName
,	dpt.LastName
,	dpt.GroupName
,	pa.AddressLine1
,	pa.AddressLine2
,	pa.City
,	pa.StateProvinceID
,	pa.PostalCode
FROM
	HumanResources.[vEmployeeDepartmentHistory] dpt
		INNER JOIN Person.BusinessEntityAddress ba
		ON dpt.BusinessEntityID = ba.BusinessEntityID	
			INNER JOIN Person.Address pa
			ON ba.AddressID = pa.AddressID
WHERE
	dpt.EndDate IS NULL
ORDER BY
	BusinessEntityID



SELECT
	dpt.BusinessEntityID
,	dpt.Department
,	dpt.FirstName
,	dpt.LastName
,	dpt.GroupName
,	pa.AddressLine1
,	pa.AddressLine2
,	pa.City
,	pa.StateProvinceID
,	pa.PostalCode
FROM
	HumanResources.[vEmployeeDepartment] dpt
		INNER JOIN Person.BusinessEntityAddress ba
		ON dpt.BusinessEntityID = ba.BusinessEntityID	
			INNER JOIN Person.Address pa
			ON ba.AddressID = pa.AddressID
ORDER BY
	BusinessEntityID
