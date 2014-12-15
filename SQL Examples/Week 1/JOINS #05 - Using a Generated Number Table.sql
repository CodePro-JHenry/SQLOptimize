USE TimeSheet;
GO

--- Set earliest known PayPeriod Start date
DECLARE @SeedPPStartDate datetime;
SET @SeedPPStartDate = '9/12/2010';

--- Create a table variable with base integers for integer creation.
DECLARE @tblInts TABLE (val int NOT NULL);
INSERT INTO @tblInts (val) VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

--- Determine maximum number of Pay Periods to-date
DECLARE @NumPayPeriods int;
SET	@NumPayPeriods = (DATEDIFF(dd, @SeedPPStartDate, GETDATE()) / 14) + 1;

SELECT
	t.Username
,	pp.PPStart
,	pp.PPEnd
,	CONVERT(date, t.TimeIn) AS DateWorked
,	CASE DATEPART(WEEKDAY, t.TimeIn)
		WHEN 1 THEN 'Sunday'
		WHEN 2 THEN 'Monday'
		WHEN 3 THEN 'Tuesday'
		WHEN 4 THEN 'Wednesday'
		WHEN 5 THEN 'Thursday'
		WHEN 6 THEN 'Friday'
		WHEN 7 THEN 'Saturday'
	END AS [WeekDay]
,	t.TimeIn
,	t.TimeOut
--,	DATEDIFF(MINUTE, t.TimeIn, t.TimeOut) AS Time_Minutes
,	SUM(DATEDIFF(MINUTE, t.TimeIn, t.TimeOut) / 60.0) AS HoursWorked
FROM
TimeInOut t
	INNER JOIN (
		--- Create result set that has all possible pay periods up through current pay period.
		SELECT
			DATEADD(DAY, (14 * i.val), s.SeedPPStartDate) AS PPStart
		,	DATEADD(DAY, ((14 * (i.val + 1)) - 1), s.SeedPPStartDate) AS PPEnd
		FROM
			(
			--- Create result set with all numbers from 0 to 999
			SELECT
				(i1.val * 100) + (i2.val * 10) + i3.val AS val
			FROM
				-- CROSS join to create all possible combinations
				@tblInts i1, @tblInts i2, @tblInts i3
			) i
				 CROSS JOIN	(SELECT @SeedPPStartDate AS SeedPPStartDate) s
		WHERE
			i.val <= @NumPayPeriods
		) pp
	ON (t.TimeIn >= pp.PPStart) AND (t.TimeIn <= pp.PPEnd)
WHERE
	t.Username = 'Angela'
GROUP BY
	t.Username
,	pp.PPStart
,	pp.PPEnd
,	CONVERT(date, t.TimeIn)
,	CASE DATEPART(WEEKDAY, t.TimeIn)
		WHEN 1 THEN 'Sunday'
		WHEN 2 THEN 'Monday'
		WHEN 3 THEN 'Tuesday'
		WHEN 4 THEN 'Wednesday'
		WHEN 5 THEN 'Thursday'
		WHEN 6 THEN 'Friday'
		WHEN 7 THEN 'Saturday'
	END
,	t.TimeIn
,	t.TimeOut
ORDER BY
	pp.PPStart
,	CONVERT(date, t.TimeIn)
;

