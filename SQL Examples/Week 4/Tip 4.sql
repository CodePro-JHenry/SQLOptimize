/*
	Tip #4
	Avoid Divide by Zero error using NULLIF().

	NULLIF(x,y) returns NULL if x = y
	Use this to compare the possible 0 value to 0 so it will NULLify the expression instead of throwing an error.
*/


DECLARE @tTmp AS TABLE (
	[page] varchar(50) NOT NULL
,	[visits] int
,	[clicks] int
);

INSERT INTO @tTmp
VALUES
	('index.htm', 1000, 10)
,	('page1.htm', 0, 0)
,	('page2.htm', 500, 10)
;

--- Divide-by-Zero error
SELECT t.page, 100 * ((clicks * 1.0) / visits) AS ClickRate
FROM @tTmp t
;

--- No error
SELECT t.page, 100 * ((clicks * 1.0) / NULLIF(visits, 0)) AS ClickRate
FROM @tTmp t
;

--- No error, NULL considered 0
SELECT t.page, ISNULL(100 * ((clicks * 1.0) / NULLIF(visits, 0)), 0) AS ClickRate
FROM @tTmp t
;
