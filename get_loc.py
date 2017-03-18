##python
## This module reads from the UMTS database in SaaS and returns a cell name, latitude and longitude
## unfornuately, the password is hardcoded for the access

def get_loc ():

	import datetime
	import numpy as np
	""" db_print.py -- a simple demo for ADO database reads."""

	import adodbapi
	adodbapi.adodbapi.verbose = False	# adds details to the sample printout

	# connection string templates from http://www.connectionstrings.com
	# Switch test providers by changing the "if True" below

	# connection string for an Access data table:


	# connection string for an SQL server
	_computername="135.222.212.16" #or name of computer with SQL Server
	_databasename="wms_kpi" #or something else
	_table_name= 'dbo.location'

	_username="slbryson"
	_password='janfeb222!'
			# this set opens a MS-SQL table with SQL authentication 
	constr = r"Provider=SQLOLEDB.1; Initial Catalog=%s; Data Source=%s; user ID=%s; Password=%s; " \
	% (_databasename, _computername, _username, _password)
	#-----------------------
	# Ths would work better with Windows Authentication then you would not need to expose your password.
		
	#tell the server  we are not planning to update...
	adodbapi.adodbapi.defaultIsolationLevel = adodbapi.adodbapi.adXactBrowse

	#and we want a local cursor (so that we will have an accurate rowcount)
	adodbapi.adodbapi.defaultCursorLocation = adodbapi.adodbapi.adUseClient

	#create the connection
	con = adodbapi.connect(constr)

	#make a cursor on the connection
	c = con.cursor()

	#run an SQL statement on the cursor
	sql = 'select * from %s' % _table_name
	print 'Table Being Read "%s"' % _table_name
	c.execute(sql)

	#get the results
	db = c.fetchmany(10)
	#c.execute("select latitude from %s" % _table_name)
	kk = c.fetchall()
	#print 
	if False:
	 for rec in db:
		print repr(rec)
		
	howmany = int(c.rowcount)
	lat= np.zeros((howmany,1))
	lon = np.zeros((howmany,1))
	name = np.chararray((howmany,1), itemsize=20)
	for rows in range(len(kk)):
		lat[rows] = kk[rows][0]
		lon[rows]= kk[rows][1]
		name[rows] = kk[rows][4]

		#print  rec.latitude, rec.longitude
		
	if False:
		for rows in range(45,50):
			print lat[rows], name[rows], len(name)
	c.close()
	con.close()
	return name, lat, lon