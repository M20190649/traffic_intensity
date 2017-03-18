If OBJECT_ID ('dbo.NewProduct', 'U') is NOT NULL
DROP Table dbo.NewProduct;
GO

SELECT *
INTO dbo.NewProduct
 FROM [dbo].[kpi_series] 
 where datename(hour,startDateTime)=7 
 and
 datename(minute,startDateTime) =0
 and
 startDateTime between '2013-03-20 00:00:00' and '2013-04-20 00:00:00'
 and
 totPSRRCAtts > 1500
 and
 cell like 'N%'
GO