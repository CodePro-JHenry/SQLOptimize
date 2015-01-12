/*
	Tip #16
	Find transposition errors

	Scenario: You have a paper trail that indicates total expenses were one $$ figure, but your database indicates a different total.
	You suspect a data-entry error - possibly a transposition of numbers.  You need to identify possible culprits.

*/


DECLARE @Expenses AS TABLE (
	ID int IDENTITY(1,1) PRIMARY KEY
,	EnteredBy varchar(50)
,	Expense money
);

DECLARE @PaperSystem AS TABLE (
	ID int IDENTITY(1,1) PRIMARY KEY
,	Expense money
);

INSERT INTO @Expenses (EnteredBy, Expense) VALUES ('Julie', 2640), ('Julie', 1452), ('Barbara', 1450), ('Barbara', 1610), ('Barbara', 1772), ('Julie', 1160), ('Barbara', 1754.72), ('Julie', 1698);
INSERT INTO @PaperSystem (Expense) VALUES (2460), (1452), (1450), (1610), (1772), (1160), (1754.27), (1698);

DECLARE @verifyTotal money;
SELECT @verifyTotal = SUM(e.Expense)
FROM @Expenses e
;
DECLARE @correctTotal money;
SELECT @correctTotal = SUM(e.Expense)
FROM @PaperSystem e 
;

DECLARE @difference money;
SET @difference = @verifyTotal - @correctTotal;
SELECT @correctTotal AS TotalOnPaper, @verifyTotal AS TotalInDatabase, @difference AS [Difference];
--- This tells us that we have a problem in our Expenses table.
--- Because the difference is evenly divisible by 9, this is a good indicator of a transposition error.
---	Example:  46 vs 64 -> difference = 18.   71 vs 17 -> difference is -54		59 vs 95 -> difference is 36

--- The magnitude is the lowest power of 10 that evenly divides into the difference, so that will indicate which digits we need to look at (i.e. the 2nd and 3rd positions from the right)
--- LOG(ABS(@difference))/LOG(10) is the logarithm of @difference base 10.
--- Taking the FLOOR() indicates # of digits. (i.e. 2, in this case)
---	Using that (minus 1) as the exponent to apply to 10, gives us our multiplier to use for our next test...
SELECT LOG(ABS((@difference * 100)))/LOG(10)
DECLARE @magnitude int;
SET @magnitude = POWER(10, FLOOR(LOG(ABS(@difference*100))/LOG(10))-1);
DECLARE @digitDiff int;
SET @digitDiff = (@difference * 100) / @magnitude / 9;
SELECT @difference AS diff, @magnitude AS magnitude, @digitDiff AS digitDiff;


SELECT
	e.Expense
,	(FLOOR((e.Expense * 100) / @magnitude / 10) % 10) AS digitA
,	(FLOOR((e.Expense * 100) / @magnitude) % 10) AS digitB
,	(FLOOR((e.Expense * 100) / @magnitude / 10) % 10) - (FLOOR((e.Expense * 100) / @magnitude) % 10) AS digitDiff
FROM @Expenses e
--WHERE (FLOOR(e.Expense / @magnitude / 10) % 10) - (FLOOR(e.Expense / @magnitude) % 10) = @digitDiff
;

SELECT
	Expense
,	EnteredBy
,	CASE WHEN (FLOOR((Expense * 100) / @magnitude / 10) % 10) - (FLOOR((Expense * 100) / @magnitude) % 10) = @digitDiff THEN '******' ELSE '' END AS NeedsInvestigation
FROM @Expenses
;

