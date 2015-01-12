
/*
	Tip #1
	Calculate the Maximum or Minimum of two numeric values (from the same row)

	max(x, y) = (x + y + ABS(x - y)) / 2
	min(x, y) = (x + y - ABS(x - y)) / 2
*/
DECLARE @x int;
DECLARE @y int;
SET @x = -201;
SET @y = -202;

SELECT 
	@x AS x_value
,	@y AS y_value
,	(@x + @y - ABS(@x - @y)) / 2 AS MinValue
,	(@x + @y + ABS(@x - @y)) / 2 AS MaxValue

	

