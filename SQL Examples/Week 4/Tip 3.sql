
/*
	Tip #3
	How to effectively perform a PRODUCT() aggregate - similar to the SUM() function, but multiplying instead.

	1) The SUM of the logarithms of n numbers is equal to the logarithm of the product of those numbers.
	2) The EXP (exponent) function is the inverse of the LOG (logarithm) function (for natural log)
		- So, once you've got the sum of the logarithms of the list of numbers, just run that through the EXP() function to get the final product.
*/

DECLARE @val1 int;
DECLARE @val2 int;
DECLARE @val3 int;
DECLARE @val4 int;
SET @val1 = 212;
SET @val2 = 45;
SET @val3 = 67;
SET @val4 = 8;

SELECT @val1 * @val2 * @val3 * @val4;

SELECT EXP(LOG(@val1) + LOG(@val2) + LOG(@val3) + LOG(@val4));


--- Use this concept to find effective interest based on multiple records.
DECLARE @tTmp AS TABLE (
	Yr int NOT NULL
,	Rate decimal(18,4)
);
INSERT INTO @tTmp
VALUES 
(2002, 0.035), (2003, 0.042), (2004, 0.05), (2005, 0.04)
;

SELECT 0.035 + 0.042 + 0.05 + 0.04 AS IncorrectApproximation;

SELECT
	EXP(SUM(LOG(1 + t.Rate))) - 1 AS EffectiveInterestRate
FROM @tTmp t
;


