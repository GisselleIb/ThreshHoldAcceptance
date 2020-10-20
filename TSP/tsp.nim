import db_sqlite
import strutils
import math
import algorithm

type
  Graph[size:static[int]]=ref object
    dim : int
    cities :array[1..size,array[1..size,float]]
  Solution=object
    cities:seq[int]

proc initGraph(g:Graph,size:int):Graph=
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

proc A(u,v:seq[string]):float=
  var
    latu=rad(parseFloat(u[0]))
    latv=rad(parseFloat(v[0]))
    lonu=rad(parseFloat(u[1]))
    lonv=rad(parseFloat(v[1]))

  result=sin((latv-latu)/2)^2 + cos(latu)*cos(latv)*sin((lonv-lonu)/2)^2
  return result

proc naturalDistance(u,v:seq[string]):float=
  var
    d:float
    a:float
  a=A(u,v)
  d=6373000*(2*arctan2(sqrt(a),sqrt(1-a)))
  return d

proc getLatLon(v,u:int):seq[seq[string]]=
  let db= open("tsp.db","","","")
  result=db.getAllRows(sql"SELECT latitude, longitude FROM cities WHERE id=? OR id=?", v, u)
  db.close()
  return result

proc maxDistance(g:Graph,s:Solution):float=
  var
    max=0.0

  for k in countup(0,len(s.cities)-2):
      var
        i=s.cities[k]
        j=s.cities[k+1]

      if g.cities[i][j] > max:
        max=g.cities[i][j]

  return max

proc weight(u,v:seq[string],g:Graph,s:Solution):float=
  return naturalDistance(u,v)*maxDistance(g,s)

proc normalizer(g:Graph,s:Solution):float=
  var
    suma:float
    l:seq[float]

  for n in 0..len(s.cities)-2:
    for m in n+1..len(s.cities)-1:
      var
        i=s.cities[n]
        j=s.cities[m]
      if g.cities[i][j] != -1:
        l.add(g.cities[i][j])

  sort(l,system.cmp[float],Descending)

  for i in countup(0,len(s.cities)-1):
    if i > len(l):
      break
    suma=suma+l[i]

  return suma

proc cost(s:Solution,g:Graph):float=
  var suma=0.0
  for k in countup(0,len(s.cities)-2):
    var
      i=s.cities[k]
      j=s.cities[k+1]
    if g.cities[i][j] == -1:
      var latlon=getLatLon(i,j)
      echo latlon
      suma=suma+weight(latlon[0],latlon[1],g,s)
    else:
      suma=suma+g.cities[i][j]
  return suma/normalizer(g,s)

#proc neighbor(s:solution)
var
  r:seq[seq[string]]
  g:Graph[1092]
  s:Solution

let db= open("tsp.db","","","")
r=db.getAllRows(sql"SELECT * FROM connections")
db.close()

new(g)
g=initGraph(g,1092)
g=addNodes(r,g)

s.cities= @[1,2,3,4,5,6,7,163,164,165,168,172,327,329,331,332,333,489,490,491,
492,493,496,653,654,656,657,661,815,816,817,820,823,871,978,979,980,981,982,984]
echo cost(s,g)


#echo g.cities[1084][1085]
#for i in 1..7:
 #for j in 1..7:
  # echo "i: ",i," j: ",j," d: ",g.cities[i][j]
