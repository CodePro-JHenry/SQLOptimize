USE AdventureWorks2014
GO


/*	RULE #14 - Remove the need for OUTER JOINs by creating a "dummy" record in the joined table and use its key as the default for the joining table.
	-	The AdventureWorks database doesn't provide us any good opportunities to demonstrate this, so we will do it with our own scenario...
*/

/* SCENARIO:  You have a WishList table that provides a column for ItemCategory.  ItemCategories are in a Category table.
	However, sometimes when users are adding an item to their wish list, they don't know what category to put it in, so they leave it blank.
	Now, when we want to create a query that joins WishList items to Cateogory, we have to do a LEFT JOIN and then test to see if there is
	no Category, and return "[Not Specified]" if that is the case.
*/
/*
CREATE SCHEMA Christmas;
GO

CREATE TABLE Christmas.WishList (
	WishListID int NOT NULL IDENTITY(1,1) PRIMARY KEY
,	Name varchar(50) NOT NULL
,	UserName varchar(50) NOT NULL
);
GO

CREATE TABLE Christmas.WishListItems (
	WishListItemID int NOT NULL IDENTITY(1,1) PRIMARY KEY
,	WishListID int NOT NULL CONSTRAINT FK_WishListItems_WishList FOREIGN KEY REFERENCES Christmas.WishList(WishListID)
,	ItemDescription varchar(50) NOT NULL
,	[Priority] int NOT NULL DEFAULT(1)
,	CategoryID int NULL	-- Note: no FK
);
GO

CREATE TABLE Christmas.Category (
	CategoryID int NOT NULL IDENTITY(1,1) PRIMARY KEY
,	CategoryName varchar(50)
);
GO

INSERT INTO Christmas.Category (CategoryName) VALUES ('Electronics'), ('Toys'), ('Clothing'), ('Household'), ('Entertainment'), ('Furniture');
*/


SELECT
	i.[Priority]
,	i.ItemDescription
,	ISNULL(c.CategoryName, '[Not Specified]') AS CategoryName
FROM
	Christmas.WishList w
		INNER JOIN Christmas.WishListItems i
		ON w.WishListID = i.WishListID
			LEFT OUTER JOIN Christmas.Category c
			ON i.CategoryID = c.CategoryID
ORDER BY
	i.[Priority] DESC
;


--- Alternatively, we could change the table structure so that CategoryID is no longer nullable with a DEFAULT of 0
--- and insert a record in Category (after disabling Identity())
INSERT INTO Christmas.Category (CategoryID, CategoryName) VALUES (0, '[Not Specified]');

--- Now, we could rewrite the above query as simply:
SELECT
	i.[Priority]
,	i.ItemDescription
,	c.CategoryName
FROM
	Christmas.WishList w
		INNER JOIN Christmas.WishListItems i
		ON w.WishListID = i.WishListID
			INNER JOIN Christmas.Category c
			ON i.CategoryID = c.CategoryID
ORDER BY
	i.[Priority] DESC
;
