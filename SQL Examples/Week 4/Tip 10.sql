/*
	Tip #10
	Solve a Crossword Puzzle with LIKE and underutilized wildcard character...

	The _ (underscore) character acts as a single character wildcard.  Often overlooked and underused, it can
	come in handy on many occassions.
	1) If you have a dictionary table loaded, you can use SQL to help find words that match patterns (such as those you come across in crossword puzzles)
	2) Maybe you need to lookup a record by name, but you're not quite sure exactly how to spell the name.
*/


SELECT *
FROM Person.Person p
WHERE p.FirstName LIKE '__ch%l'
;

SELECT *
FROM Person.Person p
WHERE p.LastName LIKE '__t_k_ge_'
;
