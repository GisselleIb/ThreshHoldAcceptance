import db_sqlite
import strutils
import math
import algorithm


type
  Graph*[size:static[int]]=ref object
    dim* : int
    cities* :array[1..size,array[1..size,float]]


proc initGraph*(g:Graph,size:int):Graph=
  var
    g=g
  g.dim=size

  for i in countup(1,size):
    for j in countup(1,size):
      if i == j :
        g.cities[i][j]= 0
      else:
        g.cities[i][j]= -1

  return g

proc getDistances():seq[seq[string]]=
  let db= open("tsp.db","","","")
  result=db.getAllRows(sql"SELECT * FROM connections")
  db.close()
  return result

proc addNodes*(g: Graph):Graph=
  var
    g=g
    cities=getDistances()
  for c in cities:
    var
      i=parseInt(c[0])
      j=parseInt(c[1])
      d=parseFloat(c[2])
    #echo "i: ", i, " j: ", j," d: ", d
    g.cities[i][j]=d
  return g
