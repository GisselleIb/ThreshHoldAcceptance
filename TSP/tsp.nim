import db_sqlite
import algorithm
import graph
import solution
import distance


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

  for i in countup(0,len(s.cities)-2):
    if i >= len(l):
      break
    suma=suma+l[i]

  return suma

proc cost(s:Solution,g:Graph):float=
  var sum=0.0
  for k in countup(0,len(s.cities)-2):
    var
      i=s.cities[k]
      j=s.cities[k+1]
    if g.cities[i][j] == -1:
      var latlon=getLatLon(i,j)
      sum=sum+weight(latlon[0],latlon[1],g,s)
    else:
      sum=sum+g.cities[i][j]
      #echo g.cities[i][j]
  return sum/normalizer(g,s)

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

s.cities= @[ 1,2,3,4,5,6,7,163,164,165,168,172,327,329,331,332,333,489,490,491,
492,493,496,653,654,656,657,661,815,816,817,820,823,871,978,979,980,981,982,984]
var lo=getLatLon(1,2)
#echo naturalDistance(lo[0],lo[1])
#echo normalizer(g,s)
echo cost(s,g)
