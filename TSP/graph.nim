import db_sqlite
import strutils
import math
import algorithm
import distance


type
  Graph*[size:static[int]]=ref object
    dim* : int
    cities* :array[1..size,array[1..size,tuple[distance:float,exists:bool]]]


proc initGraph*(g:Graph,size:int):Graph=
  var
    g=g
  g.dim=size

  for i in countup(1,size):
    for j in countup(1,size):
      if i == j :
        g.cities[i][j]= (0.0,true)
      else:
        g.cities[i][j]= (-1.0,false)

  return g


proc addNodes*(g: Graph):Graph=
  var
    g=g
    cities=getDistances()
    latlon=getLatLon()
  for c in cities:
    var
      i=parseInt(c[0])
      j=parseInt(c[1])
      d=parseFloat(c[2])
    #echo "i: ", i, " j: ", j," d: ", d
    g.cities[i][j]=(d,true)

  for i in countup(1,g.dim):
    for j in countup(1,g.dim):
      if not g.cities[i][j].exists:
        g.cities[i][j].distance=naturalDistance(latlon[i-1],latlon[j-1])

  return g
