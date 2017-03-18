If OBJECT_ID ('dbo.new_base', 'U') is NOT NULL
DROP Table dbo.new_base;
GO
USE [wms_kpi]
GO
select DISTINCT startDateTime, cell, totCSRRCAtts,totPSRRCAtts,kpi16,kpi35p
into [dbo].new_base
from [dbo].base_data
	order by startDateTime, cell
GO

select DISTINCT startDateTime, cell, totCSRRCAtts,totPSRRCAtts,kpi16,kpi35p
from [dbo].kpi_series
	order by startDateTime, cell
GO
