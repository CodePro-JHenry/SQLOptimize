USE AdventureWorks2014
GO



/*	RULE #12 - Don’t use sub-queries in the WHERE clause – and don’t do with 2 sub-queries what you could do with one
	-	In my tests, the second query runs consistently just a few miliseconds faster...
	-	But the real difference can be seen in the execution plans.
*/

--- DON'T do this:
SELECT 
	e.BusinessEntityID 
FROM
	HumanResources.EmployeePayHistory ph
		INNER JOIN HumanResources.Employee e
		ON ph.BusinessEntityID = e.BusinessEntityID
WHERE
	e.JobTitle LIKE 'Sales%'
AND (
		ph.Rate = (
			SELECT MAX(ph.Rate) 
			FROM
				HumanResources.EmployeePayHistory ph
					INNER JOIN HumanResources.Employee e
					ON ph.BusinessEntityID = e.BusinessEntityID
			WHERE
				e.JobTitle LIKE 'Sales%'
			) 
	OR  e.BirthDate = (
			SELECT MIN(e.BirthDate) 
			FROM
				HumanResources.Employee e
			WHERE
				e.JobTitle LIKE 'Sales%'
			) 
	)


--- DO do this:
SELECT 
	e.BusinessEntityID 
FROM
	HumanResources.EmployeePayHistory ph
		INNER JOIN HumanResources.Employee e
		ON ph.BusinessEntityID = e.BusinessEntityID
			INNER JOIN (
				SELECT MAX(ph.Rate) AS MaxRate, MIN(e.BirthDate) AS MinBirthDate
				FROM
					HumanResources.EmployeePayHistory ph
						INNER JOIN HumanResources.Employee e
						ON ph.BusinessEntityID = e.BusinessEntityID
				WHERE
					e.JobTitle LIKE 'Sales%'
				) q1
			ON ph.Rate = q1.MaxRate OR e.BirthDate = q1.MinBirthDate
WHERE
	e.JobTitle LIKE 'Sales%'
