import sqlite3;
from datetime import datetime, date;
import time
 
inConn = sqlite3.connect('banklist.sqlite3')
outConn = sqlite3.connect('FailedBanksCD.sqlite')
 
inCursor = inConn.cursor()
outCursor = outConn.cursor()
 
outConn.execute("DELETE FROM ZFAILEDBANKINFO")
outConn.execute("DELETE FROM ZFAILEDBANKDETAILS")
 
maxId = 0
inCursor.execute("select * from failed_banks")
for row in inCursor:
    closeDate = datetime.strptime(row[5], "%Y-%m-%d %H:%M:%S")
    updatedDate = datetime.strptime(row[6], "%Y-%m-%d %H:%M:%S")
    closeDateSecs = time.mktime(closeDate.timetuple())
    updatedDateSecs = time.mktime(updatedDate.timetuple())
 
    # Convert time references secs to NSDate reference
    deltaSecs = time.mktime((2001, 1, 1, 0, 0, 0, 0, 0, 0))
    closeDateSecs = closeDateSecs - deltaSecs
    updatedDateSecs = updatedDateSecs - deltaSecs
 
    if row[0] > maxId:
        maxId = row[0]
 
    # Create ZFAILEDBANKINFO entry
    vals = []
    vals.append(row[0]) # Z_PK
    vals.append(2) # Z_ENT
    vals.append(1) # Z_OPT
    vals.append(row[0]) # ZDETAILS
    vals.append(row[1]) # ZNAME
    vals.append(row[3]) # ZSTATE
    vals.append(row[2]) # ZCITY
    outConn.execute("insert into ZFAILEDBANKINFO(Z_PK, Z_ENT, Z_OPT, ZDETAILS, ZNAME, ZSTATE, ZCITY) values(?, ?, ?, ?, ?, ?, ?)", vals)
 
    # Create ZFAILEDBANKDETAILS entry
    vals = []
    vals.append(row[0]) # Z_PK
    vals.append(1) # Z_ENT
    vals.append(1) # Z_OPT
    vals.append(row[0]) # ZINFO
    vals.append(row[4]) # ZZIP
    vals.append(closeDateSecs) # ZCLOSEDATE
    vals.append(updatedDateSecs) # ZUPDATEDDATE
    outConn.execute("insert into ZFAILEDBANKDETAILS(Z_PK, Z_ENT, Z_OPT, ZINFO, ZZIP, ZCLOSEDATE, ZUPDATEDDATE) values(?, ?, ?, ?, ?, ?, ?)", vals)
 
outConn.execute("update Z_PRIMARYKEY set Z_MAX=?", [maxId])
 
outConn.commit()