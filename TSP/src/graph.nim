import strutils
import distance


## Module that defines the class and the procedures needed for modeling a graph used for TSP.

type
  ## Type that contains the definition of a graph modeled with an adjacency matrix.
  Graph*[size:static[int]]=ref object
    dim* : int
    cities* :array[1..size,array[1..size,tuple[distance:float,exists:bool]]]


proc initGraph*(g:var Graph,size:int,db:string)=
  ## Initialize the graph, fills the diagonal with (0.0,true) and the rest of
  ## it with (0.0,false), then fills the rest of the graph using the
  ## auxiliary procedure addNodes(g,db).
  var
    cities=getDistances(db)
    latlon=getLatLon(db)

  g.dim=size
  for c in cities:
    var
      i=parseInt(c[0])
      j=parseInt(c[1])
      d=parseFloat(c[2])
    #echo "i: ", i, " j: ", j," d: ", d
    g.cities[i][j]=(d,true)
    g.cities[j][i]=(d,true)

  for i in countup(1,g.dim):
    for j in countup(1,g.dim):
      if i == j :
        g.cities[i][j]= (0.0,true)
      if not g.cities[i][j].exists:
        g.cities[i][j].distance=naturalDistance(latlon[i-1],latlon[j-1])

  for i in countup(1,size):
    for j in countup(1,size):
      if i == j :
        g.cities[i][j]= (0.0,true)
      else:
        g.cities[i][j]= (-1.0,false)

  g.addNodes(db)



proc addNodes*(g:var Graph,db:string)=
  ## For each pair of cities associated with a cell of the graph that is not in
  ## the diagonal, fills it with the distance of the database if it exists
  ## and if not, fills it with the natural distance calculated with the
  ## latitudes and longitudes of the cities.
  var
    cities=getDistances(db)
    latlon=getLatLon(db)
  for c in cities:
    var
      i=parseInt(c[0])
      j=parseInt(c[1])
      d=parseFloat(c[2])
    #echo "i: ", i, " j: ", j," d: ", d
    g.cities[i][j]=(d,true)
    g.cities[j][i]=(d,true)

  for i in countup(1,g.dim):
    for j in countup(1,g.dim):
      if not g.cities[i][j].exists:
        g.cities[i][j].distance=naturalDistance(latlon[i-1],latlon[j-1])
