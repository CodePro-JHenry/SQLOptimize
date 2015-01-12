/*
	Tip #2
	Calculate distance between two GPS locations

	The problem:  differences in Latitude translate directly into distance, but Longitude lines converge making distance calculations dependent upon Latitude. 
	The solution: Convert degrees to Radians, convert coordinates to 3D coordinates, and use basic trigonometry
*/

DECLARE @Lon1 float;
DECLARE @Lat1 float;
DECLARE @Lon2 float;
DECLARE @Lat2 float;

DECLARE @rLon1 float;
DECLARE @rLat1 float;
DECLARE @rLon2 float;
DECLARE @rLat2 float;

DECLARE @R float;
SET @R = 3958.75587;	-- Mean Radius of Earth in Miles

--- Enter coordinates in Degrees

SET @Lon1 = -3.207630;
SET @Lat1 = 55.954742;
SET @Lon2 = -3.214617;
SET @Lat2 = 55.932809;

--- Not much difference in simple vs. advanced calculation with values above.
--- Now try these, where the two locations are MUCH further apart.
/*
SET @Lon1 = -3.207630;
SET @Lat1 = 55.954742;
SET @Lon2 = 113.670094;
SET @Lat2 = 34.749660;
*/
--- Convert Latitude and Longitude coordinates to Radians
SET @rLon1 = (PI() * @Lon1 / 180);
SET @rLat1 = (PI() * @Lat1 / 180);
SET @rLon2 = (PI() * @Lon2 / 180);
SET @rLat2 = (PI() * @Lat2 / 180);

--- Straight-line distance (short distances)
WITH
BaseCalc (dLon, dLat)
AS (
SELECT
	@R * (@rLon2 - @rLon1) * COS(@rLat1) AS dLon
,	@R * (@rLat2 - @rLat1) AS dLat
)
SELECT
	--- Simply apply Pythagorean theorem
	SQRT((dLon * dLon) + (dLat * dLat)) AS FlatDistance
FROM
	BaseCalc b
;

--- More accurate distance - taking into consideration basic curvature of the Earth.
WITH
CoordinateCalc (x1, y1, z1, x2, y2, z2)
AS (
SELECT
	--- Calculate x, y, and z coordiates relative to center of the Earth
	@R * COS(@rLat1) * COS(@rLon1) AS x1
,	@R * COS(@rLat1) * SIN(@rLon1) AS y1
,	@R * SIN(@rLat1) AS z1
,	@R * COS(@rLat2) * COS(@rLon2) AS x2
,	@R * COS(@rLat2) * SIN(@rLon2) AS y2
,	@R * SIN(@rLat2) AS z2
)
SELECT
	--- Simply apply Pythagorean theorem (in 3 dimensions)
	SQRT((dx * dx) + (dy * dy) + (dz * dz)) AS StraightDistanceThroughSphere
	--- Take the arcsin (i.e. angle - in radians - for sin value) of half of the total angle between the two points
	---		1) We take the point-to-point distance (through the sphere) and divide by 2 to find the half-way point which creates a right-triangle.
	---		2) We then divide that length (i.e. the "Opposite") side by the Radius (i.e. the Hypotenuse) to get the SIN of that angle (i.e. half the angle between our two points)
	---		3) Because the angle (in radians) * Radius = arc distance, we multiply by @R (radius)
	---		4) Because we only measured HALF of the total p2p distance in order to get the SIN so we could use arcsin to calculate half of the angle,
	---			we now must multiply by 2 to get the full arc length.
,	2 * @R * ASIN(SQRT((dx * dx) + (dy * dy) + (dz * dz)) / 2 / @R) AS ArcDistance
FROM
	--- Calculate differences
	(
		SELECT
			b.x2 - b.x1 AS dx
		,	b.y2 - b.y1 AS dy
		,	b.z2 - b.z1 AS dz
		FROM
			CoordinateCalc b
	) d
;

/*
dx = (@R * COS(@rLat2) * COS(@rLon2)) - (@R * COS(@rLat1) * COS(@rLon1))
dy = (@R * COS(@rLat2) * SIN(@rLon2)) - (@R * COS(@rLat1) * SIN(@rLon1))
dz = (SIN(@rLat2)) - (SIN(@rLat1))
*/
--- The whole thing in one, big, ugly expression...
SELECT
	2
*	@R
*	ASIN(
		SQRT(
			(((@R * COS(@rLat2) * COS(@rLon2)) - (@R * COS(@rLat1) * COS(@rLon1))) * ((@R * COS(@rLat2) * COS(@rLon2)) - (@R * COS(@rLat1) * COS(@rLon1))))
		+	(((@R * COS(@rLat2) * SIN(@rLon2)) - (@R * COS(@rLat1) * SIN(@rLon1))) * ((@R * COS(@rLat2) * SIN(@rLon2)) - (@R * COS(@rLat1) * SIN(@rLon1))))
		+	(((@R * SIN(@rLat2)) - (@R * SIN(@rLat1))) * ((@R * SIN(@rLat2)) - (@R * SIN(@rLat1))))
		)
	/	2
	/	@R
	)
 AS ArcDistance
;

--- Using Spherical law of Cosines:
SELECT
	ACOS((SIN(@rLat1) * SIN(@rLat2)) + (COS(@rLat1) * COS(@rLat2) * COS(@rLon2 - @rLon1))) * @R AS DistancePerSLoC
;
