/*
	Tip #15
	Identify overlapping ranges

	Scenario: Suppose you have a table of job-seekers with low and high salaries defining the range they are looking for,
	and you have a Jobs table with job offerings that also difine a range.  You want to match job-seekers with job offerings
	that are within their desired salary range.
*/


DECLARE @JobSeekers AS TABLE (
	Name varchar(50)
,	Low money
,	High money
);

DECLARE @JobListing AS TABLE (
	Title varchar(50)
,	Low money
,	High money
);


INSERT INTO @JobSeekers VALUES ('Harry', 22000, 31000), ('Joe', 18000, 25000), ('Bill', 45000, 65000);
INSERT INTO @JobListing VALUES ('Sales Rep', 24000, 28000), ('Window Cleaner', 18000, 22500), ('Custodian', 17000, 21000), ('Junior Software Developer', 44000, 62000), ('Senior Helpdesk Tech', 38000, 47000);

SELECT
	s.*
,	l.*
FROM
	@JobSeekers s
		INNER JOIN @JobListing l
		ON s.High >= l.Low AND s.Low <= l.High
ORDER BY
	s.Name
,	l.High DESC