import db_sqlite
import strutils
import math

type
  #Vertices=set[int]
  #Edges=set[tuple[v1:int,v2:int]]
  Graph[size:static[int]]=object
    #nodes : set[int16]
    dim : int
    cities :ref array[1..size,array[1..size,float]]

proc initGraph(g:Graph):Graph=
  var
    g=g

  for i in countup(1,g.dim):
    for j in countup(1,g.dim):
      if i == j :
        g.cities[i][j]= 0
      else:
        g.cities[i][j]= -1

  return g

proc addNodes(cities:seq[seq[string]],g: Graph):Graph=
  var
    g=g

  for c in cities:
    var
      i=parseInt(c[0])
      j=parseInt(c[1])
      d=parseFloat(c[2])
    #echo "i: ", i, " j: ", j," d: ", d
    g.cities[i][j]=d

  return g

proc rad(g:float):float=
  return (g*PI)/180

proc A(u,v:tuple):float=
  var
    latu=rad(u[0])
    latv=rad(v[0])
    lonu=rad(u[1])
    lonv=rad(v[1])

  result=sin((latv-latu)/2)^2 + cos(latu)*cos(latv)*sin((lonv-lonu)/2)^2
  return result

proc naturalDistance(u,v:tuple):float=
  var
    d:float
    a:float
  a=A(u,v)
  d=6373000*(2*arctan(sqrt(a)))
  return d

proc weights(u,v:int,g:Graph):Graph=
  var g=g
  return g

#proc maxDistance()

#proc normalizer(S:Graph)

#proc cost(S:graph)

#proc neighbor(s:solution)



let db= open("tsp.db","","","")
var
  r:seq[seq[string]]
  g:Graph[1092]

r=db.getAllRows(sql"SELECT * FROM connections")
g.dim=1092
new(g.cities)
g=initGraph(g)
g=addNodes(r,g)

#echo g.cities[1084][1085]
#for i in 1..100:
 #for j in 1..100:
  # echo "i: ",i," j: ",j," d: ",g.cities[i][j]
db.close()
