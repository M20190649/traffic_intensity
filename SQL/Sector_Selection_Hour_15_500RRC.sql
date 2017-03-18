use wms_kpi
--deletes previous table
If OBJECT_ID ('dbo.sector_a', 'U') is NOT NULL
DROP Table dbo.sector_a;
GO

--creates new table based on filter
SELECT *
INTO dbo.sector_a
 FROM dbo.new_base
 where  datename(hour,startDateTime) = 16
 and
 datename(minute,startDateTime) =15
 and
 totPSRRCAtts > 500
 and
 cell like '%a'
 order by startDateTime, cell
GO