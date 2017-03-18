use wms_kpi
--deletes previous table
If OBJECT_ID ('dbo.carriera0830', 'U') is NOT NULL
DROP Table dbo.carriera0830;
GO

--creates new table based on filter
SELECT *
INTO dbo.carriera0830
 FROM dbo.new_base
 where  datename(hour,startDateTime) = 08
 and
 datename(minute,startDateTime) =30
 and
 totPSRRCAtts between 10 and 500000
 --totPSRRCAtts between 10 and 100
 and
 cell like '%a'
 order by totPSRRCAtts, cell
GO
--%%% next
If OBJECT_ID ('dbo.carriera1130', 'U') is NOT NULL
DROP Table dbo.carriera1130;
GO
SELECT *
INTO dbo.carriera1130
 FROM dbo.new_base
 where  datename(hour,startDateTime) = 11
 and
 datename(minute,startDateTime) =30
 and
 totPSRRCAtts between 10 and 50000
 --totPSRRCAtts between 10 and 100
 and
 cell like '%a'
order by totPSRRCAtts, cell
GO
--%%% next
If OBJECT_ID ('dbo.carriera1630', 'U') is NOT NULL
DROP Table dbo.carriera1630;
GO
SELECT *
INTO dbo.carriera1630
 FROM dbo.new_base
 where  datename(hour,startDateTime) = 16
 and
 datename(minute,startDateTime) =30
 and
 totPSRRCAtts between 10 and 500000
 --totPSRRCAtts between 10 and 100
 and
 cell like '%a'
-- order by startDateTime, cell
GO
--%%% next
If OBJECT_ID ('dbo.carriera2330', 'U') is NOT NULL
DROP Table dbo.carriera2330;
GO
SELECT *
INTO dbo.carriera2330
 FROM dbo.new_base
 where  datename(hour,startDateTime) = 23
 and
 datename(minute,startDateTime) =30
 and
 totPSRRCAtts between 10 and 500
 --totPSRRCAtts between 10 and 100
 and
 cell like '%a'
--order by startDateTime, cell
GO