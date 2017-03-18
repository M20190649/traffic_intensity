These Matlab scripts call a SQL database wms_kpi and read specific tables that have been pre-sorted using SQL scripts.
The tables called are labeled "carrierXYYYY" where x is the letter of the sector(cell) which could be a different carrier and YYYY is a timestamp.
The collection of data has been pre-sorted for four times during the day over about a 4 month period.
The scripts needed for the GP interpolation are:
gp_real_cell.m
average.m
DatabaseHandler.m

Within gp_real_cell_working.m is a username and password for access to the database. The password may have been removed prior to commiting the file.

The user also needs to choose which database tables to interpolate.  listTable is the variable.  This is to reduce the amount of processing for any given run.