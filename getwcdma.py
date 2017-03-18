#function to get wcma data.  Currently only for test.  
# Will add the capability to pass the dbase name as argument
def getwcdma():
	import datetime
	""" db_print.py -- a simple demo for ADO database reads."""

	import adodbapi
	import numpy as np
	adodbapi.adodbapi.verbose = False # adds details to the sample printout

	# connection string templates from http://www.connectionstrings.com
	# Switch test providers by changing the "if True" below

	# connection string for an Access data table:


	# connection string for an SQL server
	_computername="135.222.212.16" #or name of computer with SQL Server
	_databasename="wms_kpi" #or something else
	_table_name= 'dbo.test'

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
	print 'Executing the command: "%s"' % sql
	c.execute(sql)

	#check the results
	print 'result rowcount shows as= %d. (Note: -1 means "not known")' \
		  % (c.rowcount,)
	print
	print 'result data description is:'
	print '            NAME TypeCd DispSize IntrnlSz Prec Scale Null?'
	for d in c.description:
		print ('%16s %6d %8d %8d %4d %5d %5d') % d
	print


	#get the results
	db = c.fetchmany(10)
	kk = c.fetchall()
	#Get RRC attempts
	howmany = int(c.rowcount)
	psrrc= np.zeros((howmany,1))
	csrrc= np.zeros((howmany,1))
	cellid = np.chararray((howmany,1), itemsize=20)
	for rows in range(len(kk)):
		psrrc[rows] = kk[rows][3]
		csrrc[rows]= kk[rows][2]
		cellid[rows] = kk[rows][1]
	#print them
	if False:
		for rec in db:
			print repr(rec)
	if False:
		print psrrc
	#psrrc =psrrc.tolist()
	csrrc = csrrc.tolist()
	cellid = cellid.tolist()
	if False:
		print psrrc
	c.close()
	con.close()
	return cellid,psrrc
	
