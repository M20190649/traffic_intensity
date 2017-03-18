
import csv
import os
import numpy as np
import matplotlib.pyplot as pl
from operator import itemgetter
from mpl_toolkits.mplot3d import Axes3D
from mpl_toolkits.mplot3d.axes3d import Axes3D



# Skyhook data are structured as follows:
# Tile ID: a 9 character hexadecimal identifier of the Tile
# Hour ID: local time zone adjusted day of the week (0-168, 0 represents from
# Midnight to 1AM on Sunday morning)
# Tile Requests: activity summary for the Tile at that particular Hour ID (1-n)
# Average Latitude: averaged centroid of requests within the TileID for the
# given hour as measured in degrees
# Average Longitude: averaged centroid of requests within the TileID for the
# given hour as measured in degrees
# The rest 4 coordinates define the bounding box of the tile.
in_file = r"C:\Projects\Python_Projects\simcity\data\skyhook-data\2013-09-01\Skyhook.csv"
out_file = "Skyhook.shp"


if False:
	in_file ="Skyhook.csv"
	with open(in_file, 'rb') as csvfile:
		r = csv.reader(csvfile, delimiter=',')
		# create 9 lists containing the columns of the dataset
		date, tileID, hour, count, average_lat, average_long, min_lat, min_long, max_lat, max_long = [
		], [], [], [], [], [], [], [], [], []

		for row in r:
			date.append('20130901')
			tileID.append(row[0])
			hour.append(row[1])
			count.append(row[2])
			average_lat.append(row[3])
			average_long.append(row[4])
			min_lat.append(row[5])
			min_long.append(row[6])
			max_lat.append(row[7])
			max_long.append(row[8])
 
if True:
	in_file = r"C:\Users\slbryson\Documents\saas\LA\LA6\2014-02-01\part-r-00000"
	filedate =in_file[40:-13:]
 	with open(in_file, 'rb') as csvfile:
		r = csv.reader(csvfile, delimiter='\t')
		# create 9 lists containing the columns of the dataset
		date, tileID, hour, count, average_lat, average_long, min_lat, min_long, max_lat, max_long = [
		], [], [], [], [], [], [], [], [], []

		for row in r:
			date.append(filedate)
			tileID.append(row[0])
			hour.append(row[1])
			count.append(row[2])
			average_lat.append(row[3])
			average_long.append(row[4])
			min_lat.append(row[5])
			min_long.append(row[6])
			max_lat.append(row[7])
			max_long.append(row[8])
dset = zip(count, tileID, hour, date, average_lat, average_long, min_lat, min_long, max_lat, max_long)		
print ("{0} {1} {2}".format (len(hour),"number of rows in this file",in_file))
 
csvfile.close()
pl.figure(1)
pl.cla()
c,m  = [('b'),('o')]
# Now Plot the Averages of each tile to see where they lay
pl.title("The average Tile Locations in LA for " + filedate)
pl.xlabel('Longitude')
pl.ylabel('Latitude')
pl.plot(average_long,average_lat,'r+')
	
pl.ion()

pl.show() 
pl.figure(2)
pl.cla()
hm = 0
for rows in range(len(count)):
	if float(count[rows]) > 300.:
	 #print count[rows], tileID[rows]
	 hm += 1
print "Number of Tiles > 300", hm, len(hour)
newset = sorted(dset,key=lambda x: int(x[0]), reverse=True)
count, tileID, hour, date, average_lat, average_long, min_lat, min_long, max_lat, max_long = zip(*newset)	

for rows in range(1,hm):
	pl.plot(min_long[rows],min_lat[rows],c+m)
	pl.plot(max_long[rows],max_lat[rows],c+m)
	pl.plot(min_long[rows],max_lat[rows],c+m)
	pl.plot(max_long[rows],min_lat[rows],c+m, average_long[rows],average_lat[rows],'r+')
	#pl.text(average_long[rows],average_lat[rows],tileID[rows])
	pl.text(average_long[rows],average_lat[rows],count[rows])
pl.title("A few select Tiles from LA " + filedate)
pl.xlabel('Longitude')
pl.ylabel('Latitude')
pl.show()

fig = pl.figure(8)
pl.cla()
ax = fig.gca(projection='3d')

hc = 150
#Key for some of the matplotlib routines is proper type casting of variables.
# Also some of the variables from the skyhook data e.g. count may be read initially as char arrays
# instead of integers making processing problematic.
for rows in range (1, hc):
	ax.scatter(float(average_long[rows]),float(average_lat[rows]),int(count[rows]),c='b',marker='^')
 	
ax.set_xlabel('Longitude')
ax.set_ylabel('Latitude')
pl.title('Top ' +str(hc) + ' Tiles ' + 'from LA ' + filedate)
pl.show()
print filedate


