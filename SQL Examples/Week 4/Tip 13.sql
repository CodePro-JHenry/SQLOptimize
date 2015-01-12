/*
	Tip #13
	Find the Nth ___Day of the month

	If you want to find the LAST Xday of the month, just always pass in 5 for Nth.  You can't have more than 5 of any weekday in a month.
*/



DECLARE @mth AS date;
DECLARE @firstWeekDay AS int;
DECLARE @Nth AS int;
DECLARE @WeekDay AS int;	--- 1 - 7 (Sunday - Saturday)
DECLARE @offset AS int;
DECLARE @daysToAdd AS int;

SET @mth = '1/12/2015' --GETDATE();
SET @Nth = 1;		-- 3rd
SET @WeekDay = 5;	-- Tuesday

IF @Nth > 5
	SET @Nth = 5;

--- Get first day of month
SET @mth = CONVERT(date, CONVERT(varchar(2), MONTH(@mth)) + '/1/' + CONVERT(varchar(4), YEAR(@mth)));
--- Determine the 1st weekday of the month.
SET @firstWeekDay = DATEPART(WEEKDAY, @mth);
/*
	Determine the offset for the desired weekday from the firstday of the month.  This will be 0 to 6.
	This formula uses mathematical logic using a 7-unit cycle (i.e. both variables are guaranteed to be between 1 and 7):
	The division sign is an Integer division which will yield 0 if the numerator is smaller than the denominator.
	Using the result in a subsequent multiplication operation (in this case, * 7) effectively includes or excludes the next operand.
	(((@firstWeekDay - @WeekDay + 6) / 7) * 7) yields either 0 or 7...
	Another way to write this would be: 
		IF @WeekDay < @firstWeekDay
			SET @offset = (@WeekDay + 7) - @firstWeekDay
		ELSE
			SET @offset = @WeekDay - @firstWeekDay

	This is a great binary trick to determine which variable is larger given two variable with a range of 1 to N - especially
	in cases where you might not have the ability to use a structured language.

	You can also use this pattern and add " * 2) - 1)" to change the output from 0|1 to -1|+1 - useful if you need to logically determine 
	whether to add or subtract the next operand.  For example:
		((((@firstWeekDay - @WeekDay + 6) / 7) * 2) - 1) will now yield -1 or +1

	You can actually use this technique to yield any 2 numbers you wish ... for example:
		((((@firstWeekDay - @WeekDay + 6) / 7) * 200) + 250) will yield 250 or 450
		((((@firstWeekDay - @WeekDay + 6) / 7) * 2) + 3) will yield 3 or 5
		((((@firstWeekDay - @WeekDay + 6) / 7) * 21) + 1)  will yield 1 or 22

	Reversing the two variables has the effect of reversing the logic.
*/
SET @offset = (((@firstWeekDay - @WeekDay + 6) / 7) * 7) + @WeekDay - @firstWeekDay;
--- Determine # of days to add to beginning of month to find Nth ____Day.
SET @daysToAdd = ((@Nth * 7) - 7) + @offset;

--- If calculated day would be in the following month (this can only happen when @Nth = 5), then subtract back out 7 days.  This will yield the Last
--- Xday of the month.
IF MONTH(DATEADD(DD, @daysToAdd, @mth)) = MONTH(@mth)
	SELECT DATEADD(DD, @daysToAdd, @mth) AS NthXday
ELSE
	SELECT DATEADD(DD, @daysToAdd - 7, @mth) AS NthXday
;
GO
	

/*
CREATE FUNCTION udfGetNthWeekday(
	@mth AS date		--- any date within the month you are searching
,	@Nth AS int			---	Instance of the weekday being sought
,	@WeekDay AS int		--- 1 - 7 (Sunday - Saturday)
) RETURNS date
AS
BEGIN

DECLARE @firstWeekDay AS int;
DECLARE @offset AS int;
DECLARE @daysToAdd AS int;
DECLARE @retDate AS date;


IF @Nth > 5
	SET @Nth = 5;

--- Get first day of month
SET @mth = CONVERT(date, CONVERT(varchar(2), MONTH(@mth)) + '/1/' + CONVERT(varchar(4), YEAR(@mth)));
--- Determine the 1st weekday of the month.
SET @firstWeekDay = DATEPART(WEEKDAY, @mth);
/*
	Determine the offset for the desired weekday from the firstday of the month.  This will be 0 to 6.
	This formula uses mathematical logic using a 7-unit cycle (i.e. both variables are guaranteed to be between 1 and 7):
	The division sign is an Integer division which will yield 0 if the numerator is smaller than the denominator.
	Using the result in a subsequent multiplication operation (in this case, * 7) effectively includes or excludes the next operand.
	(((@firstWeekDay - @WeekDay + 6) / 7) * 7) yields either 0 or 7...
	Another way to write this would be: 
		IF @WeekDay < @firstWeekDay
			SET @offset = (@WeekDay + 7) - @firstWeekDay
		ELSE
			SET @offset = @WeekDay - @firstWeekDay

	This is a great binary trick to determine which variable is larger given two variable with a range of 1 to N - especially
	in cases where you might not have the ability to use a structured language.

	You can also use this pattern and add " * 2) - 1)" to change the output from 0|1 to -1|+1 - useful if you need to logically determine 
	whether to add or subtract the next operand.  For example:
		((((@firstWeekDay - @WeekDay + 6) / 7) * 2) - 1) will now yield -1 or +1

	You can actually use this technique to yield any 2 numbers you wish ... for example:
		((((@firstWeekDay - @WeekDay + 6) / 7) * 200) + 250) will yield 250 or 450
		((((@firstWeekDay - @WeekDay + 6) / 7) * 2) + 3) will yield 3 or 5
		((((@firstWeekDay - @WeekDay + 6) / 7) * 21) + 1)  will yield 1 or 22

	Reversing the two variables has the effect of reversing the logic.
*/
SET @offset = (((@firstWeekDay - @WeekDay + 6) / 7) * 7) + @WeekDay - @firstWeekDay;
--- Determine # of days to add to beginning of month to find Nth ____Day.
SET @daysToAdd = ((@Nth * 7) - 7) + @offset;

--- If calculated day would be in the following month (this can only happen when @Nth = 5), then subtract back out 7 days.  This will yield the Last
--- Xday of the month.
IF MONTH(DATEADD(DD, @daysToAdd, @mth)) = MONTH(@mth)
	SET @retDate = DATEADD(DD, @daysToAdd, @mth)
ELSE
	SET @retDate = DATEADD(DD, @daysToAdd - 7, @mth)
;
 
RETURN @retDate;

END
GO
*/