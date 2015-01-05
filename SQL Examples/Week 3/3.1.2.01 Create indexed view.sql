USE [AdventureWorks2014]
GO

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

GO

/****** Object:  Index [IX_vStateProvinceCountryRegion]    Script Date: 1/5/2015 2:02:27 PM ******/
CREATE UNIQUE CLUSTERED INDEX [IX_vStateProvinceCountryRegion] ON [Person].[vStateProvinceCountryRegion]
(
	[StateProvinceID] ASC,
	[CountryRegionCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clustered index on the view vStateProvinceCountryRegion.' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'VIEW',@level1name=N'vStateProvinceCountryRegion', @level2type=N'INDEX',@level2name=N'IX_vStateProvinceCountryRegion'
GO


