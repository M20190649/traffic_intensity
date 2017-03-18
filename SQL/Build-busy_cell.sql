If OBJECT_ID ('dbo.NewProduct', 'U') is NOT NULL
DROP Table dbo.NewProduct;
GO

SELECT distinct cell,
totPSRRCAtts,
startDateTime
INTO dbo.NewProduct
 FROM [dbo].[kpi_series] 
 where datename(hour,startDateTime) = 16
 and
  startDateTime between '2013-04-18 16:00:00' and '2013-04-18 16:05:00'
  and
 totPSRRCAtts  between 1 and 9000
 and
 cell like 'N%'
 order by cell
GO