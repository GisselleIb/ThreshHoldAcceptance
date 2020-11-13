import db_sqlite
import strutils
import math

## Module with the procedures needed to calculate everything related to the
## distances in the graph.
proc rad*(g:float):float=
  ## Convertion of degrees to radians.
  return g*PI/180


proc A*(u,v:seq[string]):float=
  ## Auxiliary method for the calculus of the natural distance.
  var
    latu=rad(parseFloat(u[0]))
    latv=rad(parseFloat(v[0]))
    lonu=rad(parseFloat(u[1]))
    lonv=rad(parseFloat(v[1]))

  result=sin((latv-latu)/2)^2 + cos(latu)*cos(latv)*sin((lonv-lonu)/2)^2
  return result


proc naturalDistance*(u,v:seq[string]):float=
  ## Calculates the natural distance between two cities given the latitude and
  ## longitude of the two.
  var
    d:float
    a:float
  a=A(u,v)
  d=6373000*(2*arctan2(sqrt(a),sqrt(1-a)))
  return d


proc getLatLon*(db:string):seq[seq[string]]=
  ## Gets the latitude and longitude of all the cities in the given database.
  let db= open(db,"","","")
  result=db.getAllRows(sql"SELECT latitude, longitude FROM cities")
  db.close()
  return result


proc getDistances*(db:string):seq[seq[string]]=
  ## Gets all the distances between cities in the given database.
  let db= open(db,"","","")
  result=db.getAllRows(sql"SELECT * FROM connections")
  db.close()
  return result
