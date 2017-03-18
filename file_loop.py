# Pyhton File Looper
import os
import csv

in_dir = r"C:\Projects\Python_Projects\simcity\data\skyhook-data"

for path, subdirs, files in os.walk(in_dir):
 for filename in files:
  f = os.path.join(path,filename)
  print filename, '\t', f
