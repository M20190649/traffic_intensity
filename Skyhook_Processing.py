import csv
import os
from pandas import DataFrame
from geopandas import GeoDataFrame
from shapely.geometry import box
import pyproj
import numpy as np
# Make all matlib functions accessible at the top level via M.func()
import numpy.matlib as M
# Make some matlib functions accessible directly at the top level via,
# e.g. rand(3,3)
from numpy.matlib import rand, zeros, ones, empty, eye
# Define a Hermitian function


def hermitian(A, **kwargs):
    return np.transpose(A, **kwargs).conj()

# Make some shorcuts for transpose,hermitian:
#    num.transpose(A) --> T(A)
#    hermitian(A) --> H(A)
T = np.transpose
H = hermitian


#in_file = 'C:\\Projects\\Data\\Skyhook\\2013-09-01\\Skyhook.csv'
in_file = 'C:\\Projects\\Python_Projects\\simcity\\data\\skyhook-data\\2013-09-01\\Skyhook.csv'
#in_file = os.path.normpath("C:\Projects\Python_Projects\simcity\data\skyhook-data\2013-09-01\Skyhook.csv")
in_file = r"C:\Projects\Python_Projects\simcity\data\skyhook-data\2013-09-01\Skyhook.csv"

out_file = r"C:\Projects\Python_Projects\simcity\source\traffic-intensity-map\Skyhook.shp"
#out_file = os.path.normpath("C:\Projects\Python_Projects\simcity\data\skyhook-data\2013-09-01\Skyhook.shp")
print(in_file)
print(out_file)

def main():
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

# read data from csv file and store in lists
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
            min_lat.append(row[5])
            min_long.append(row[6])
            max_lat.append(row[7])
            max_long.append(row[8])
		
    len(hour)	

    # set up coordinate projection suitable for NYC
    nyp = pyproj.Proj('+datum=NAD83 +lat_0=40.1666666667 +lat_1=40.6666666667 '
           '+lat_2=41.0333333333 +lon_0=-74 +no_defs +proj=lcc +units=us-ft '
           '+x_0=300000 +y_0', preserve_units=True)
    wgs84 = pyproj.Proj(init='epsg:4326')

    x_l, y_b, x_r, y_t = [], [], [], []
    # convert the bounding box into geometric coordinates
    min_long_array = np.asarray(min_long)
    min_long_array = min_long_array.astype(np.float)
    min_lat_array = np.asarray(min_lat)
    min_lat_array = min_lat_array.astype(np.float)
    max_long_array = np.asarray(max_long)
    max_long_array = max_long_array.astype(np.float)
    max_lat_array = np.asarray(max_lat)
    max_lat_array = max_lat_array.astype(np.float)
    # create (N,2) arrays where N is the number of points and 2 are the coordinates
    # pyproj expects the coordinates as (long, lat)
    x_l, y_b = pyproj.transform(wgs84, min_long_array, min_lat_array)
    x_r, y_t = pyproj.transform(wgs84, max_long_array, max_lat_array)

    # form a point array representing the bounding box
    tl = [x_l, y_t]
    tr = [x_r, y_t]
    br = [x_r, y_b]
    bl = [x_l, y_b]
    parr = [tl, tr, br, bl, tl]
    # Set up shapefile writer and create empty fields
    maxStringLength = 50
    w.field('name', 'C', maxStringLength)

    # Set up shapefile writer and create empty fields
    w = box.Writer(box.POLYGON)
    w.autoBalance = 1  # ensures gemoetry and attributes match
    w.field('X', 'F', 10, 8)
    w.field('Y', 'F', 10, 8)
    w.field('Date', 'D')
    w.field('ID', 'N')

    # loop through the data and write the shapefile
    for j, name in enumerate(name):
        w.poly(parts=parr[j])
        w.record(name)

    # Save shapefile
    w.save(out_file)

    data = DataFrame.from_csv('rect.csv')
    boxes = [box(row['x_l'], row['y_b'], row['x_r'], row['y_t'])
        for key, row in data.iterrows()]
    df = GeoDataFrame(boxes, columns=['geometry'], index=data.index)
    df.to_file('out.shp', driver='ESRI Shapefile')
