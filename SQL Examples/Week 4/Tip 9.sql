/*
	Tip #9
	DISaggregate information.

	Scenario:
		- You have a hotel Bookings table that contains the StayStartDate, NumberOfNights, and VisitPrice
		- For the purposes of this example, we assume that every night for a particular booking is billed at the same rate - otherwise, there would be a separate booking record.
		- This information, stored this way, is aggregate stored data.
		- You want to break this information out into one record per night - useful for analyzing overall vacancy for a given date.
	Key:
		- Cross join bookings with an integer table containing numbers up to the maximum # of nights a guest can stay.

*/


DECLARE @Bookings AS TABLE (
	StartDate date NOT NULL
,	VisitPrice money NOT NULL
,	Nights int
);
INSERT INTO @Bookings VALUES
('1/20/2014', 210.00, 2),
('1/21/2014', 105.00, 1),
('1/18/2014', 380.00, 4),
('1/23/2014', 240.00, 2),
('1/24/2014', 120.00, 1)
;

DECLARE @tI AS TABLE (i int NOT NULL);
INSERT INTO @tI VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

SELECT
	b.StartDate
,	DATEADD(DD, Ints.Value - 1, b.StartDate) AS StayDate
,	b.VisitPrice / b.Nights AS Price
FROM
	@Bookings b
		CROSS JOIN (
			SELECT
				(i1.i * 10) + i2.i AS Value
			FROM
				@tI i1 CROSS JOIN @tI i2 
		) Ints
WHERE
	Ints.Value BETWEEN 1 AND b.Nights
ORDER BY
	b.StartDate
,	DATEADD(DD, Ints.Value - 1, b.StartDate)
;


--- We can now re-aggregate this to find out how many rooms are booked by day (although there are certainly other ways to do that)
SELECT
	q1.StayDate
,	COUNT(q1.StayDate) AS RoomsBooked
FROM
	(
	SELECT
		b.StartDate
	,	DATEADD(DD, Ints.Value - 1, b.StartDate) AS StayDate
	,	b.VisitPrice / b.Nights AS Price
	FROM
		@Bookings b
			CROSS JOIN (
				SELECT
					(i1.i * 10) + i2.i AS Value
				FROM
					@tI i1 CROSS JOIN @tI i2 
			) Ints
	WHERE
		Ints.Value BETWEEN 1 AND b.Nights
	) q1
GROUP BY
	q1.StayDate
;
