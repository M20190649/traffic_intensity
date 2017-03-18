
# In[19]:

#First open and read Files
import os
import csv
import datetime
import pyodbc
import pandas
from operator import itemgetter, attrgetter
import numpy as np
from pandas import DataFrame, Series
import pandas as pd
import matplotlib.pyplot
##################################
# It is extremely import to include the following line in your ipython
#plotting scripts to get your graphs in-line when using matplotlib
# and pyplot
get_ipython().magic(u'pylab inline')
##################################

#Next Open database
constr =r'DSN=sqlserverdatasource;DRIVER={SQL Server}; DATABASE=wms_kpi;uid=slbryson; Pwd=marapr222!;'
##################################
cnxn = pyodbc.connect(constr)
cursor = cnxn.cursor() 
##################################
str3 = """select hour,count,tileID FROM skyhook
    where date ='2014-02-08'
    and count between 180 and 1280
    order by count
    """
cursor.execute(str3)
large_tiles = cursor.fetchall()
large_tiles = np.asarray(large_tiles)
cnxn.close()  


# Out[19]:

#     Populating the interactive namespace from numpy and matplotlib
# 

# In[20]:

print len(large_tiles), type(large_tiles)
for rows in range(5):
    print large_tiles[rows]


# Out[20]:

#     148 <type 'numpy.ndarray'>
#     ['162' '180' 'AD35F74166']
#     ['156' '180' 'AE9D26927F']
#     ['154' '180' 'AE9E158A8A']
#     ['143' '181' 'AE9D619090']
#     ['164' '181' 'AE9D2610CE']
# 

# In[21]:

frame = DataFrame(large_tiles, columns=('hour','count','tileID'))
 
#min_long_array = min_long_array.astype(np.float)
#min_lat_array = np.asarray(min_lat)
#large_tiles = np.asarray(large_tiles)
print type(frame), type(large_tiles)


# Out[21]:

#     <class 'pandas.core.frame.DataFrame'> <type 'numpy.ndarray'>
# 

# In[28]:

id_counts = frame['tileID'].value_counts()
id_counts[:10].plot(kind='barh', rot=0)
#print id_counts[:10]


# Out[28]:

#     <matplotlib.axes.AxesSubplot at 0x5ca53d0>

# image file:

# In[ ]:



