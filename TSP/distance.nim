import db_sqlite
import strutils
import math
import graph
import solution

proc rad*(g:float):float=
  return (g*PI)/180

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

proc getLatLon*(v,u:int):seq[seq[string]]=
  let db= open("tsp.db","","","")
  result=db.getAllRows(sql"SELECT latitude, longitude FROM cities WHERE id=? OR id=?", v, u)
  db.close()
  return result

proc maxDistance*(g:Graph,s:Solution):float=
  var
    max=0.0

  for k in countup(0,len(s.cities)-2):
      var
        i=s.cities[k]
        j=s.cities[k+1]

      if g.cities[i][j] > max:
        max=g.cities[i][j]

  return max

proc weight*(u,v:seq[string],g:Graph,s:Solution):float=
  return naturalDistance(u,v)*maxDistance(g,s)
