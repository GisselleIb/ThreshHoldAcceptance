import db_sqlite
import strutils
import math


proc rad*(g:float):float=
  return g*PI/180


proc A*(u,v:seq[string]):float=
  var
    latu=rad(parseFloat(u[0]))
    latv=rad(parseFloat(v[0]))
    lonu=rad(parseFloat(u[1]))
    lonv=rad(parseFloat(v[1]))

  result=sin((latv-latu)/2)^2 + cos(latu)*cos(latv)*sin((lonv-lonu)/2)^2
  return result


proc naturalDistance*(u,v:seq[string]):float=
  var
    d:float
    a:float
  a=A(u,v)
  d=6373000*(2*arctan2(sqrt(a),sqrt(1-a)))
  return d


proc getLatLon*(db:string):seq[seq[string]]=
  let db= open(db,"","","")
  result=db.getAllRows(sql"SELECT latitude, longitude FROM cities")
  db.close()
  return result


proc getDistances*(db:string):seq[seq[string]]=
  let db= open(db,"","","")
  result=db.getAllRows(sql"SELECT * FROM connections")
  db.close()
  return result
