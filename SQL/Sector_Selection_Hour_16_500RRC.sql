use wms_kpi
--deletes previous table
If OBJECT_ID ('dbo.carrierh0830', 'U') is NOT NULL
DROP Table dbo.carrierh0830;
GO

--creates new table based on filter
SELECT *
INTO dbo.carrierh0830
 FROM dbo.new_base
 where  datename(hour,startDateTime) = 08
 and
 datename(minute,startDateTime) =30
 and
 totPSRRCAtts between 10 and 500000
 --totPSRRCAtts between 10 and 100
 and
 cell like '%h'
-- order by startDateTime, cell
GO
--%%% next
If OBJECT_ID ('dbo.carrierh1130', 'U') is NOT NULL
DROP Table dbo.carrierh1130;
GO
SELECT *
INTO dbo.carrierh1130
 FROM dbo.new_base
 where  datename(hour,startDateTime) = 11
 and
 datename(minute,startDateTime) =30
 and
 totPSRRCAtts between 10 and 500000
 --totPSRRCAtts between 10 and 100
 and
 cell like '%h'
-- order by startDateTime, cell
GO
--%%% next
If OBJECT_ID ('dbo.carrierh1630', 'U') is NOT NULL
DROP Table dbo.carrierh1630;
GO
SELECT *
INTO dbo.carrierh1630
 FROM dbo.new_base
 where  datename(hour,startDateTime) = 16
 and
 datename(minute,startDateTime) =30
 and
 totPSRRCAtts between 10 and 500000
 --totPSRRCAtts between 10 and 100
 and
 cell like '%h'
-- order by startDateTime, cell
GO
--%%% next
If OBJECT_ID ('dbo.carrierh2330', 'U') is NOT NULL
DROP Table dbo.carrierh2330;
GO
SELECT *
INTO dbo.carrierh2330
 FROM dbo.new_base
 where  datename(hour,startDateTime) = 23
 and
 datename(minute,startDateTime) =30
 and
 totPSRRCAtts between 10 and 500000
 --totPSRRCAtts between 10 and 100
 and
 cell like '%h'
-- order by startDateTime, cell
GO